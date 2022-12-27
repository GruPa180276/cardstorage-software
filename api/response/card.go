package response

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strings"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type CardDataStore DataStore
type CardHandler CardDataStore

func (self *CardDataStore) RegisterHandlers(router *mux.Router) {
	handler := CardHandler(*self)
	errHandler := ErrorHandlerFactory(self.Logger)
	successHandler := SuccessHandlerFactory(self.Logger)
	router.HandleFunc(paths.API_STORAGES_CARDS, meridian.Reporter(handler.GetAllHandler, errHandler, successHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, meridian.Reporter(handler.GetByNameHandler, errHandler, successHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_CARDS, meridian.Reporter(handler.CreateHandler, errHandler, successHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, meridian.Reporter(handler.DeleteHandler, errHandler, successHandler)).Methods(http.MethodDelete)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, meridian.Reporter(handler.UpdateHandler, errHandler, successHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, meridian.Reporter(handler.IncrementAccessCountHandler, errHandler, successHandler)).Methods(http.MethodPut)
}

func (self *CardHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) error {
	cards := make([]*model.Card, 0)

	if err := self.DB.Preload("Reservations").Find(&cards).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(cards); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *CardHandler) GetByNameHandler(res http.ResponseWriter, req *http.Request) error {
	name := mux.Vars(req)["name"]
	card := &model.Card{}
	if err := self.DB.Preload("Reservations").Where("name = ?", name).Find(card).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(card); err != nil {
		return err
	}

	res.WriteHeader(http.StatusOK)
	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

// CreateHandler Create a new card with a given name in a given storage-unit.
//
// {
//     "name": "type:string, required, constraints:paths.CardNameMatcher; name of this new card",
//	   "storage": "type:string, required, constraints:paths.StorageNameMatcher; name of storage-unit that this card belongs to",
//     "accessed": "type:int, optional, default:0; how many times has this card already been accessed",
//     "available": "type:bool, optional, default:true; is this card currently available?"
// }
//
// If successful, return the created card with assigned position and name of storage-unit which it belongs to.
//
// {"storage": "type:string; name of storage", "position": "type:int; assigned position", "name": "type:string; name of card"}
//
func (self *CardHandler) CreateHandler(res http.ResponseWriter, req *http.Request) error {
	type Creator struct {
		Name      string `json:"name"`
		Storage   string `json:"storage"`
		Accessed  *uint  `json:"accessed"`
		Available *bool  `json:"available"`
	}
	c := &Creator{}

	if err := json.NewDecoder(req.Body).Decode(&c); err != nil {
		return err
	}
	if !paths.CardNameMatcher.MatchString(c.Name) {
		return fmt.Errorf("attribute 'name' does not match required pattern: %s", c.Name)
	}
	if !paths.StorageNameMatcher.MatchString(c.Storage) {
		return fmt.Errorf("attribute 'storage' does not match required pattern: %s", c.Storage)
	}

	s := &model.Storage{}
	if err := self.DB.Preload("Cards").Where("name = ?", c.Storage).Find(s).Error; err != nil {
		return err
	}

	if uint(len(s.Cards)) == s.Capacity {
		return fmt.Errorf("storage-unit '%s' is full!", s.Name)
	}

	pos := make([]int, 0)
	for _, card := range s.Cards {
		pos = append(pos, int(card.Position))
	}
	sort.Ints(pos)
	next := 0
	if len(pos) > 0 {
		next = pos[len(pos)-1] + 1
	}

	card := model.Card{Name: c.Name, Position: uint(next)}
	if c.Available != nil {
		card.CurrentlyAvailable = *c.Available
	}
	if c.Accessed != nil {
		card.AccessCount = *c.Accessed
	}
	if err := self.DB.Model(s).Preload("Cards").Association("Cards").Append(&card); err != nil {
		self.Logger.Println(err.Error())

		if strings.Contains(err.Error(), "Error 1452") {
			return fmt.Errorf("possible duplicate card '%s'", card.Name)
		}
		return err
	}

	if err := util.HttpBasicJsonResponse(res, http.StatusOK, &struct {
		Storage  string `json:"storage"`
		Position uint   `json:"position"`
		Name     string `json:"name"`
	}{
		Storage:  s.Name,
		Position: card.Position,
		Name:     card.Name,
	}); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *CardHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) error {
	type Updater struct {
		Name        *string `json:"name"`
		Position    *int    `json:"position"`
		AccessCount *int    `json:"accessed"`
		ReaderData  *string `json:"reader"`
		Available   *bool   `json:"available"`
	}
	c := &model.Card{}
	vars := mux.Vars(req)
	if err := self.DB.Where("name = ?", vars["name"]).Find(c).Error; err != nil {
		return fmt.Errorf("card '%s' does not exist; %s", vars["name"], err.Error())
	}
	u := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err
	}
	self.Logger.Println(fmt.Sprintf("%+v", u))

	updateName, updatePosition, updateReaderData, updateAccessCount, updateAvailability := false, false, false, false, false

	if u.Name != nil {
		updateName = true
		c.Name = *u.Name
		self.Logger.Println("update Name", c.Name)
	}
	if u.Position != nil {
		updatePosition = true
		c.Position = uint(*u.Position)
		self.Logger.Println("update Position", c.Position)
	}
	if u.ReaderData != nil {
		updateReaderData = true
		c.ReaderData = util.NullableString(*u.ReaderData)
		self.Logger.Println("update ReaderData", c.ReaderData)
	}
	if u.AccessCount != nil {
		updateAccessCount = true
		c.AccessCount = uint(*u.AccessCount)
		self.Logger.Println("update AccessCount", c.AccessCount)
	}
	if u.Available != nil {
		updateAvailability = true
		c.CurrentlyAvailable = *u.Available
		self.Logger.Println("update CurrentlyAvailable", c.CurrentlyAvailable)
	}

	if updateName || updatePosition || updateReaderData || updateAccessCount || updateAvailability {
		if err := self.DB.Save(c).Error; err != nil {
			return err
		}
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(c); err != nil {
		return err
	}

	res.WriteHeader(http.StatusOK)
	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

// DeleteHandler Delete a card with a given name in a given storage-unit. If the card has active reservations or is
// currently not inside the storage-unit it will not be deleted. The admin can delete reservations manually
//
// {
//     "name": "type:string, required, constraints:paths.CardNameMatcher; name of the card to delete",
//     "storage": "type:string, required, constraints:paths.StorageNameMatcher; name of storage-unit that this card belongs to"
// }
//
// If successful, return http status code whether the card was deleted or not: 200 success, !200 failure
func (self *CardHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) error {
	name := mux.Vars(req)["name"]
	card := &model.Card{}
	if err := self.DB.Preload("Reservations").Where("name = ?", name).Find(card).Error; err != nil {
		return err
	}

	if !card.CurrentlyAvailable {
		return fmt.Errorf("attempting to delete (currently) non-existent card '%s'", card.Name)
	}

	reservationsOk := true
	for _, reservation := range card.Reservations {
		if reservation.Active {
			reservationsOk = false
		}
	}
	//if len(card.Reservations) != 0 {
	//	reservationsOk = false
	//}
	if !reservationsOk {
		return fmt.Errorf("attempting to delete card '%s' with remaining (possibly active) reservations", card.Name)
	}

	// if err := self.DB.Model(card).Association("Reservations").Delete(card.Reservations); err != nil {
	// 	return err
	// }
	if err := self.DB.Preload("Reservations").Preload("User").Select("Reservations").Delete(card).Error; err != nil {
		return err
	}

	//if err := self.DB.Preload("Reservations").Delete(card).Error; err != nil {
	//	return err
	//}

	return meridian.Ok
}

func (self *CardHandler) IncrementAccessCountHandler(res http.ResponseWriter, req *http.Request) error {
	return meridian.Ok
}

func (self *CardHandler) WebSocketUpgrader(res http.ResponseWriter, req *http.Request) error {
	return meridian.Ok
}
