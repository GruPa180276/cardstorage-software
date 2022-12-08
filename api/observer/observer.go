package observer

import (
	"database/sql"
	"fmt"
	"log"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Result struct {
	Data                *controller.Message
	MqttMessageReceived chan bool
}

type Observer struct {
	mqtt.Client
	*log.Logger
	*sql.DB

	// Messages map[uuid.UUID]*Result
}

func AssembleBaseStorageTopic(storage *model.StorageUnit, location *model.Location) string {
	return fmt.Sprintf("%s@%s", storage.Name, location.Location)
}

func (self *Observer) Observe() {
	m := &model.Model{self.DB, self.Logger}
	storage := &model.StorageUnit{Model: m}
	location := &model.Location{Model: m}

	storages := util.Must(storage.SelectAll()).([]model.StorageUnit)
	locations := util.Must(location.SelectAll()).([]model.Location)

	for _, unit := range storages {
		locationOfUnitIdx := model.LocationIdUnset
		for idx, loc := range locations {
			if loc.Id != unit.LocationId {
				continue
			}
			locationOfUnitIdx = idx
		}
		top := AssembleBaseStorageTopic(&unit, &locations[locationOfUnitIdx]) + "/1"
		self.Printf("trying to ping '%s'...\n", top)

		// <-self.Publish(top, 1, false, []byte("ping")).Done()

		<-self.Subscribe(top, 1, func(client mqtt.Client, msg mqtt.Message) {
			if len(string(msg.Payload())) > (1 << 10) {
				return
			}

		}).Done()
	}
}
