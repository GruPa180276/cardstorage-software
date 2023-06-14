package observer

import (
	"encoding/json"
	"fmt"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Observer struct {
	*controller.Controller
}

func (self *Observer) Observe() error {
	storages := make([]model.Storage, 0)

	if result := self.DB.Find(&storages); result.Error != nil {
		return result.Error
	}

	observerOpts := self.Client.OptionsReader()
	self.Println("manager-id:", observerOpts.ClientID())

	for _, storage := range storages {
		topic := util.AssembleBaseStorageTopic(storage.Name, storage.Location)
		self.Printf("subscribed to %q", topic)
		subtoken := self.Subscribe(topic, 2, GetObserverHandler(self.Controller))
		<-subtoken.Done()
		if err := subtoken.Error(); err != nil {
			self.Println(err)
			return err
		}
	}

	return nil
}

func GetObserverHandler(c *controller.Controller) mqtt.MessageHandler {
	s := &meridian.StaticMqttReporter{
		MqttReporterErrorHandlerFunc: func(err error, _ mqtt.Message) {
			c.Println(err.Error())
			buf, errJson := json.Marshal(&struct {
				ActionSuccessful  bool            `json:"successful"`
				ControllerMessage json.RawMessage `json:"controller"`
			}{
				ActionSuccessful:  false,
				ControllerMessage: json.RawMessage(err.Error()),
			})
			if errJson != nil {
				buf = util.Must(json.Marshal(&struct {
					ActionSuccessful  bool   `json:"successful"`
					ControllerMessage string `json:"controller"`
				}{
					ActionSuccessful:  false,
					ControllerMessage: err.Error(),
				})).([]byte)
			}
			c.ControllerLogChannel <- string(buf)
		},
		MqttReporterSuccessHandlerFunc: func(ok *meridian.Ok, _ mqtt.Message) {
			c.Println(ok.Error())
			c.ControllerLogChannel <- string(util.Must(json.Marshal(&struct {
				ActionSuccessful  bool            `json:"successful"`
				ControllerMessage json.RawMessage `json:"controller"`
			}{
				ActionSuccessful:  true,
				ControllerMessage: json.RawMessage(ok.Error()),
			})).([]byte))
		},
	}
	return func(client mqtt.Client, msg mqtt.Message) {
		go func(s *meridian.StaticMqttReporter) {
			if len(string(msg.Payload())) > (1 << 10) {
				s.MqttReporterErrorHandlerFunc(fmt.Errorf("message rejected due to memory footprint"), nil)
				return
			}
			header := &controller.Header{}
			if err := json.Unmarshal(msg.Payload(), header); err != nil {
				s.MqttReporterErrorHandlerFunc(fmt.Errorf("unable to parse message header: %s", err.Error()), nil)
				return
			}
			if header.ClientId == c.ClientId {
				return
			}

			switch header.Action {
			case controller.ActionStorageUnitPing:
				s.Reporter(c.PingStorageUnitHandler)(msg)
				return
			case controller.ActionStorageUnitNewCard:
				s.Reporter(c.StorageUnitAddCardHandler)(msg)
				return
			case controller.ActionStorageUnitDeleteCard:
				s.Reporter(c.DeleteCardHandler)(msg)
				return
			case controller.ActionStorageUnitFetchCardSourceMobile:
				s.Reporter(c.FetchCardKnownUserHandler)(msg)
				return
			case controller.ActionStorageUnitFetchCardSourceTerminal:
				s.Reporter(c.FetchCardUnknownUserHandler)(msg)
				return
			case controller.ActionUserSignup:
				s.Reporter(c.SignUpUserHandler)(msg)
				return
			case controller.ActionStorageUnitDepositCard:
				s.Reporter(c.DepositCardHandler)(msg)
				return
			}
		}(s)
	}
}
