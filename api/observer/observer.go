package observer

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"sync"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Observer struct {
	mqtt.Client
	*log.Logger
	*sql.DB
	*sync.Map
}

func AssembleBaseStorageTopic(storage model.StorageUnit, location string) string {
	return fmt.Sprintf("%s@%s/1", storage.Name, location)
}

func (self *Observer) Observe() {
	m := &model.Model{self.DB, self.Logger}
	storage := &model.StorageUnit{Model: m}
	storages := util.Must(storage.SelectAll()).([]model.StorageUnit)
	observerOpts := self.Client.OptionsReader()
	self.Println("manager-id:", observerOpts.ClientID())

	for _, unit := range storages {
		topic := AssembleBaseStorageTopic(unit, unit.Location)
		c := controller.Controller{Logger: self.Logger, Map: self.Map, Client: self.Client}

		<-self.Subscribe(topic, 1, func(client mqtt.Client, msg mqtt.Message) {
			if len(string(msg.Payload())) > (1 << 10) {
				return
			}
			header := new(controller.Header)
			if err := json.Unmarshal(msg.Payload(), header); err != nil {
				self.Println(err)
				return
			}
			if header.ClientId == observerOpts.ClientID() {
				return
			}
			if _, ok := self.Load(header.Id); !ok {
				self.Printf("error: got unknown message-id %q", header.Id)
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
			default:
				self.Printf("error: got unknown action %q", header.Action)
				return
			}
		}).Done()
	}
}
