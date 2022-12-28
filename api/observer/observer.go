package observer

import (
	"encoding/json"
	"fmt"
	"log"
	"sync"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"gorm.io/gorm"
)

type Observer struct {
	mqtt.Client
	*log.Logger
	*gorm.DB
	*sync.Map
	ControllerInfoChannel chan string
}

func AssembleBaseStorageTopic(storage, location string) string {
	return fmt.Sprintf("%s@%s", storage, location)
}

func (self *Observer) Observe() error {
	storages := make([]model.Storage, 0)

	if result := self.DB.Find(&storages); result.Error != nil {
		return result.Error
	}

	observerOpts := self.Client.OptionsReader()
	self.Println("manager-id:", observerOpts.ClientID())

	c := &controller.Controller{
		Logger:                self.Logger,
		Map:                   self.Map,
		Client:                self.Client,
		ControllerInfoChannel: self.ControllerInfoChannel,
		DB:                    self.DB,
	}

	for _, storage := range storages {
		<-self.Subscribe(AssembleBaseStorageTopic(storage.Name, storage.Location), 1,
			func(client mqtt.Client, msg mqtt.Message) {
				if len(string(msg.Payload())) > (1 << 10) {
					self.Println("message rejected due to memory-footprint")
					return
				}
				header := &controller.Header{}
				if err := json.Unmarshal(msg.Payload(), header); err != nil {
					self.Println("unable to parse message header:", err.Error())
					return
				}
				if header.ClientId == observerOpts.ClientID() {
					return
				}

				switch header.Action {
				case controller.ActionSuccess:
					if err := c.SuccessHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionFailure:
					if err := c.FailureHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionStorageUnitPing:
					if err := c.PingStorageUnitHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionStorageUnitNewCard:
					if err := c.AddNewCardToStorageUnitHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionStorageUnitDeleteCard:
					if err := c.DeleteCardHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionStorageUnitFetchCardSourceMobile:
					fallthrough
				case controller.ActionStorageUnitFetchCardSourceTerminal:
					if err := c.FetchCardHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionUserSignupSourceMobile:
					fallthrough
				case controller.ActionUserSignupSourceTerminal:
					if err := c.SignUpUserHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionUserCheckExists:
					if err := c.CheckUserExistenceHandler(msg); err != nil {
						self.Println(err)
						return
					}
				case controller.ActionStorageUnitDepositCard:
					if err := c.DepositCardHandler(msg); err != nil {
						self.Println(err)
						return
					}
				default:
					strerr := fmt.Sprintf("got unknown action %q from %q", header.Action, msg.Topic())
					self.ControllerInfoChannel <- strerr
					self.Printf(strerr)
					return
				}
			},
		).Done()
	}

	return nil
}
