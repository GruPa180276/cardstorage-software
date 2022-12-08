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

func AssembleBaseStorageTopic(storage model.StorageUnit, location model.Location) string {
	return fmt.Sprintf("%s@%s/1", storage.Name, location.Location)
}

func (self *Observer) Observe() {
	m := &model.Model{self.DB, self.Logger}
	storage := &model.StorageUnit{Model: m}
	location := &model.Location{Model: m}

	storages := util.Must(storage.SelectAll()).([]model.StorageUnit)
	locations := util.Must(location.SelectAll()).([]model.Location)

	observerOpts := self.Client.OptionsReader()
	self.Println("manager-id:", observerOpts.ClientID())

	for _, unit := range storages {
		locationOfUnitIdx := model.LocationIdUnset
		for idx, loc := range locations {
			if loc.Id != unit.LocationId {
				continue
			}
			locationOfUnitIdx = idx
		}
		topic := AssembleBaseStorageTopic(unit, locations[locationOfUnitIdx])
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
			case controller.ActionStorageUnitNewCard:
				if err := c.AddNewCardToStorageUnitHandler(msg); err != nil {
					self.Println(err)
					return
				}
			case controller.ActionStorageUnitPing:
				if err := c.PingStorageUnitHandler(msg); err != nil {
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
