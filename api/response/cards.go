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
	"net/http"
)

type Card struct {
	*sql.DB
	*log.Logger
	mqtt.Client

	Messages map[uuid.UUID]*ObserverResult
}

func (self *Card) GetAllCardsHandler(res http.ResponseWriter, req *http.Request) {
	card := model.Card{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	cards, err := card.SelectAll()
	if err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}

	if err := json.NewEncoder(res).Encode(cards); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

// @todo: DONE! Send message over MQTT to RaspiController when adding a new card to activate card-reader and send data back over MQTT Topic
func (self *Card) AddNewCardHandler(res http.ResponseWriter, req *http.Request) {
	card := &model.Card{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(card); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		return
	}

	if card.Name == model.CardNameUnset ||
		card.StorageId == model.StorageUnitIdUnset ||
		card.Position == model.CardPositionUnset {
		/* || card.ReaderData == model.CardReaderDataUnset { */
		strerr := "error: at least one condition for adding new card not met"
		self.Println(strerr)
		util.HttpBasicJsonError(res, http.StatusBadRequest, strerr)
		return
	}

	// check if given storageid foreign key exists
	storage := model.StorageUnit{Model: card.Model}
	storage.Id = card.StorageId
	if err := storage.SelectById(); err != nil {
		if err == sql.ErrNoRows {
			// invalid storage id
			strerr := fmt.Sprintf("error: trying to add new card with non-existent storage '%s'", (&storage).String())
			self.Println(strerr)
			util.HttpBasicJsonError(res, http.StatusBadRequest, strerr)
		} else {
			self.Println(err)
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	// insert only if card does not already exist
	if _, err := card.Insert(); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		return
	}
	self.Println("successfully inserted " + card.String())
	// insert new empty card-status
	if err := card.SelectByName(); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
	cs := model.CardStatus{CardId: card.Id, Model: card.Model}
	if err := (&cs).InsertDefaultStatus(); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
	self.Println("successfully inserted " + (&cs).String())

	location := model.Location{Model: card.Model}
	location.Id = storage.LocationId
	if err := location.SelectById(); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}

	msgid := uuid.Must(uuid.NewRandom()).String()
	c := &ControllerMessage{
		Id:     msgid,
		Action: ControllerMessageActionAddNewCardToStorageUnit,
		Card: &ControllerCard{
			Name:      card.Name,
			StorageId: card.StorageId,
			Position:  card.Position,
		},
	}

	msg, err := json.Marshal(c)
	if err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
	received := make(chan bool)
	token := self.Publish(AssembleBaseStorageTopic(&storage, &location)+"/1", 1, false, msg)
	go func() {
		received <- token.Wait()
	}()
	self.Messages[uuid.MustParse(c.Id)] = &ObserverResult{Data: c, MqttMessageReceived: received}

	self.Println("successfully sent request to controller to add new card")

}

func (self *Card) GetCardByIdHandler(res http.ResponseWriter, req *http.Request) {
	self.Println(util.ErrNotImplemented)
	util.HttpBasicJsonError(res, http.StatusNotImplemented)
}

func (self *Card) GetCardByNameHandler(res http.ResponseWriter, req *http.Request) {
	self.Println(util.ErrNotImplemented)
	util.HttpBasicJsonError(res, http.StatusNotImplemented)
}
