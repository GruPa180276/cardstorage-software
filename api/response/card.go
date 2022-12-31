package response

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type CardHandler struct {
	*controller.Controller
	CardLogChannel chan string
}

func (self *CardHandler) RegisterHandlers(router *mux.Router) {
	s := meridian.StaticReporter{ErrorHandler: ErrorHandlerFactory(self.Logger), SuccessHandler: SuccessHandlerFactory(self.Logger)}
	router.HandleFunc(paths.API_STORAGES_CARDS, s.Reporter(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, s.Reporter(self.GetByNameHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_CARDS, s.Reporter(self.CreateHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, s.Reporter(self.DeleteHandler)).Methods(http.MethodDelete)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, s.Reporter(self.UpdateHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_INCREMENT, s.Reporter(self.IncrementAccessCountHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_DECREMENT, s.Reporter(self.DecrementAccessCountHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_AVAILABLE, s.Reporter(self.SetCardAvailabilityHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_FETCH_KNOWN_USER, s.Reporter(self.FetchCardKnownUserHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_FETCH_UNKNOWN_USER, s.Reporter(self.FetchCardUnknownUserHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_STORAGES_CARDS_WS_LOG, controller.LoggerChannelHandlerFactory(self.CardLogChannel, self.Logger, self.Upgrader)).Methods(http.MethodGet)
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
		Name    string `json:"name"`
		Storage string `json:"storage"`
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

	if err := self.Controller.StorageUnitAddCardDispatcher(s.Name, s.Location, c.Name, uint(next)); err != nil {
		self.Logger.Println(err)
	}

	if err := util.HttpBasicJsonResponse(res, http.StatusOK, &struct {
		Storage  string `json:"storage"`
		Position uint   `json:"position"`
		Name     string `json:"name"`
	}{
		Storage:  s.Name,
		Position: uint(next),
		Name:     c.Name,
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

	if len(card.Reservations) != 0 {
		return fmt.Errorf("attempting to delete card '%s' with remaining (possibly active) reservations", card.Name)
	}

	storages := make([]model.Storage, 0)
	if err := self.DB.Preload("Cards").Find(&storages).Error; err != nil {
		return err
	}
	storage_name, sidx, cidx := "", -1, -1
	for i, storage := range storages {
		for j, c := range storage.Cards {
			if c.Name == card.Name {
				storage_name = c.Name
				sidx = i
				cidx = j
				break
			}
		}
	}
	if storage_name == "" || sidx == -1 || cidx == -1 {
		// should never happen!
		return fmt.Errorf("found card that doesnt't belong to any storage-unit: %s (%s)", card.Name, name)
	}
	s := storages[sidx]
	c := s.Cards[cidx]

	if err := self.Controller.DeleteCardDispatcher(s.Name, s.Location, c.Name, c.Position); err != nil {
		return err
	}

	return meridian.Ok
}

func (self *CardHandler) IncrementAccessCountHandler(res http.ResponseWriter, req *http.Request) error {
	name := mux.Vars(req)["name"]

	card := &model.Card{}
	if err := self.DB.Where("name = ?", name).First(card).Error; err != nil {
		return err
	}

	card.AccessCount++
	if err := self.DB.Save(card).Error; err != nil {
		return err
	}

	if err := util.HttpBasicJsonResponse(res, http.StatusOK, card); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *CardHandler) DecrementAccessCountHandler(res http.ResponseWriter, req *http.Request) error {
	name := mux.Vars(req)["name"]

	card := &model.Card{}
	if err := self.DB.Where("name = ?", name).First(card).Error; err != nil {
		return err
	}

	if (card.AccessCount - 1) < 0 {
		return fmt.Errorf("attempting to decrement counter into negative realm")
	}

	card.AccessCount--

	if err := self.DB.Save(card).Error; err != nil {
		return err
	}

	if err := util.HttpBasicJsonResponse(res, http.StatusOK, card); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *CardHandler) SetCardAvailabilityHandler(res http.ResponseWriter, req *http.Request) error {
	vars := mux.Vars(req)
	name := vars["name"]
	flag := util.Must(strconv.ParseBool(vars["flag"])).(bool)

	// self.Printf("%s, %q, %v, %T\n", vars, name, flag, flag)

	card := model.Card{}
	if err := self.DB.Where("name = ?", name).First(&card).Error; err != nil {
		return err
	}
	if card.CurrentlyAvailable == flag {
		return meridian.Ok
	}
	card.CurrentlyAvailable = flag
	if err := self.DB.Save(&card).Error; err != nil {
		return err
	}
	return meridian.Ok
}

func (self *CardHandler) FetchCardKnownUserHandler(res http.ResponseWriter, req *http.Request) error {
	vars := mux.Vars(req)
	name := vars["name"]
	email := vars["email"]

	card := model.Card{}
	if err := self.DB.Where("name = ?", name).First(&card).Error; err != nil {
		return err
	}

	if !card.CurrentlyAvailable {
		return fmt.Errorf("attempting to fetch currently unavailable card! '%s'", card.Name)
	}

	card.CurrentlyAvailable = false
	if err := self.DB.Save(&card).Error; err != nil {
		return err
	}

	storages := make([]model.Storage, 0)
	if err := self.DB.Preload("Cards").Find(&storages).Error; err != nil {
		return err
	}

	storage_name, sidx, cidx := "", -1, -1
	for i, storage := range storages {
		for j, c := range storage.Cards {
			if c.Name == card.Name {
				storage_name = c.Name
				sidx = i
				cidx = j
				break
			}
		}
	}

	if storage_name == "" || sidx == -1 || cidx == -1 {
		// should never happen!
		return fmt.Errorf("found card that doesnt't belong to any storage-unit: %s (%s)", card.Name, name)
	}

	s := storages[sidx]
	c := s.Cards[cidx]
	c.CurrentlyAvailable = false
	c.AccessCount++
	if err := self.DB.Save(&c).Error; err != nil {
		self.Logger.Println(err)
	}

	// create reservation for user
	user := model.User{}
	if err := self.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return err
	}
	reservation := model.Reservation{UserID: user.UserID, User: user, Since: time.Now(), IsReservation: false}
	if err := self.DB.Model(&user).Association("Reservations").Append(&reservation); err != nil {
		return err
	}
	if err := self.Controller.FetchCardKnownUserDispatcher(s.Name, s.Location, c.Position); err != nil {
		return err
	}

	return meridian.Ok
}

func (self *CardHandler) FetchCardUnknownUserHandler(res http.ResponseWriter, req *http.Request) error {
	vars := mux.Vars(req)
	name := vars["name"]

	card := model.Card{}
	if err := self.DB.Where("name = ?", name).First(&card).Error; err != nil {
		return err
	}

	if !card.CurrentlyAvailable {
		return fmt.Errorf("attempting to fetch currently unavailable card! '%s'", card.Name)
	}

	storages := make([]model.Storage, 0)
	if err := self.DB.Preload("Cards").Find(&storages).Error; err != nil {
		return err
	}

	storage_name, sidx, cidx := "", -1, -1
	for i, storage := range storages {
		for j, c := range storage.Cards {
			if c.Name == card.Name {
				storage_name = c.Name
				sidx = i
				cidx = j
				break
			}
		}
	}

	if storage_name == "" || sidx == -1 || cidx == -1 {
		// should never happen!
		return fmt.Errorf("found card that doesnt't belong to any storage-unit: %s (%s)", card.Name, name)
	}

	s := storages[sidx]
	c := s.Cards[cidx]
	if err := self.Controller.FetchCardUnknownUserDispatcher(s.Name, s.Location, c.Name, c.Position); err != nil {
		return err
	}

	return meridian.Ok
}
