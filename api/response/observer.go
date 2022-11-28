package response

import (
	"database/sql"
	"encoding/json"
	"fmt"
	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/google/uuid"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"log"
)

type Observer struct {
	mqtt.Client
	*log.Logger
	*sql.DB

	Messages map[uuid.UUID]*ObserverResult
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
		self.Publish(top, 1, false, []byte("ping")).Wait()

		// @todo: Handle incoming MQTT data here (i.e. 'readerdata' response from response.AddNewCardHandler (card.go))
		self.Subscribe(top, 1, func(client mqtt.Client, msg mqtt.Message) {
			length := len(string(msg.Payload()))
			if length > 1024 {
				return
			}
			self.Printf("got '%s' from '%s'\n", string(msg.Payload()[:length]), msg.Topic())

			controllerMessage := new(ControllerMessage)
			controllerMessage.Card = new(ControllerCard)
			err := json.Unmarshal(msg.Payload(), controllerMessage)
			if err != nil {
				// @todo: handle error properly
				self.Println(err)
				return
			}
			// @todo: check self.Messages if message-id is already present

			switch controllerMessage.Action {
			case ControllerMessageActionAddNewCardToStorageUnit:
				// @todo
			case ControllerMessageActionBorrowCardFromMobileApplication:
				// @todo
			case ControllerMessageActionBorrowCardFromTerminal:
				// @todo
			default:
				// invalid action
			}
		}).Wait()
	}
}
