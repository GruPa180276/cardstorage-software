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

	c := &controller.Controller{
		Logger:               self.Logger,
		Map:                  self.Map,
		Client:               self.Client,
		ControllerLogChannel: self.ControllerLogChannel,
		DB:                   self.DB,
		ClientId:             self.ClientId,
	}

	for _, storage := range storages {
		topic := util.AssembleBaseStorageTopic(storage.Name, storage.Location)
		self.Printf("subscribed to %q", topic)
		subtoken := self.Subscribe(topic, 2, GetObserverHandler(c))
		<-subtoken.Done()
		if err := subtoken.Error(); err != nil {
			self.Println(err)
			return err
		}
	}

	return nil
}

func GetObserverHandler(c *controller.Controller) mqtt.MessageHandler {
	onError := func(err error) {
		if err == nil {
			return
		}
		c.Println(err)
		c.ControllerLogChannel <- err.Error()
	}
	onSuccess := func(maybe error, okMessage error) error {
		if maybe != meridian.Ok {
			return maybe
		}
		c.ControllerLogChannel <- okMessage.Error()
		c.Println(okMessage.Error())
		// log success
		return nil
	}
	return func(client mqtt.Client, msg mqtt.Message) {
		go func() {
			c.Println(msg.Topic(), string(msg.Payload()))
			if len(string(msg.Payload())) > (1 << 10) {
				onError(fmt.Errorf("message rejected due to memory footprint"))
				return
			}
			header := &controller.Header{}
			if err := json.Unmarshal(msg.Payload(), header); err != nil {
				onError(fmt.Errorf("unable to parse message header: %s", err.Error()))
				return
			}
			if header.ClientId == c.ClientId {
				return
			}

			switch header.Action {
			case controller.ActionStorageUnitPing:
				onError(onSuccess(c.PingStorageUnitHandler(msg)))
				return
			case controller.ActionStorageUnitNewCard:
				onError(onSuccess(c.StorageUnitAddCardHandler(msg)))
				return
			case controller.ActionStorageUnitDeleteCard:
				onError(onSuccess(c.DeleteCardHandler(msg)))
				return
			case controller.ActionStorageUnitFetchCardSourceMobile:
				onError(onSuccess(c.FetchCardKnownUserHandler(msg)))
				return
			case controller.ActionStorageUnitFetchCardSourceTerminal:
				onError(onSuccess(c.FetchCardUnknownUserHandler(msg)))
				return
			case controller.ActionUserSignup:
				onError(onSuccess(c.SignUpUserHandler(msg)))
				return
			case controller.ActionStorageUnitDepositCard:
				onError(onSuccess(c.DepositCardHandler(msg)))
				return
			}
		}()
	}
}
