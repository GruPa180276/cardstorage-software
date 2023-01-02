package response

import (
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strconv"

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
	s := meridian.StaticHttpReporter{ErrorHandler: ErrorHandlerFactory(self.Logger, self.CardLogChannel), SuccessHandler: SuccessHandlerFactory(self.Logger)}
	router.HandleFunc(paths.API_STORAGES_CARDS, s.Reporter(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, s.Reporter(self.GetByNameHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_CARDS, s.Reporter(self.CreateHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, s.Reporter(self.DeleteHandler)).Methods(http.MethodDelete)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, s.Reporter(self.UpdateHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_INCREMENT, s.Reporter(self.IncrementAccessCountHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_DECREMENT, s.Reporter(self.DecrementAccessCountHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_AVAILABLE, s.Reporter(self.SetCardAvailabilityHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_FETCH_KNOWN_USER, s.Reporter(self.FetchCardKnownUserHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME_FETCH_UNKNOWN_USER, s.Reporter(self.FetchCardUnknownUserHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_CARDS_WS_LOG, controller.LoggerChannelHandlerFactory(self.CardLogChannel, self.Logger, self.Upgrader)).Methods(http.MethodGet)
}

func (self *CardHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	cards := make([]*model.Card, 0)
	if err := self.DB.Preload("Reservations").Find(&cards).Error; err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&cards)
}

func (self *CardHandler) GetByNameHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]
	card := model.Card{}
	if err := self.DB.Preload("Reservations").Where("name = ?", name).First(&card).Error; err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&card)
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
func (self *CardHandler) CreateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type Creator struct {
		Name    string `json:"name"`
		Storage string `json:"storage"`
	}
	c := &Creator{}

	if err := json.NewDecoder(req.Body).Decode(&c); err != nil {
		return err, nil
	}
	if !paths.CardNameMatcher.MatchString(c.Name) {
		return fmt.Errorf("attribute 'name' does not match required pattern: %s", c.Name), nil
	}
	if !paths.StorageNameMatcher.MatchString(c.Storage) {
		return fmt.Errorf("attribute 'storage' does not match required pattern: %s", c.Storage), nil
	}

	s := model.Storage{}
	if err := self.DB.Preload("Cards").Where("name = ?", c.Storage).First(&s).Error; err != nil {
		return err, nil
	}

	if uint(len(s.Cards)) == s.Capacity {
		return fmt.Errorf("storage-unit '%s' is full!", s.Name), nil
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

	return nil, meridian.OkayMustJson(&struct {
		Storage  string `json:"storage"`
		Position uint   `json:"position"`
		Name     string `json:"name"`
	}{
		Storage:  s.Name,
		Position: uint(next),
		Name:     c.Name,
	})
}

func (self *CardHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type Updater struct {
		Name        *string `json:"name"`
		Position    *int    `json:"position"`
		AccessCount *int    `json:"accessed"`
		ReaderData  *string `json:"reader"`
		Available   *bool   `json:"available"`
	}
	card := model.Card{}
	vars := mux.Vars(req)
	if err := self.DB.Where("name = ?", vars["name"]).First(&card).Error; err != nil {
		return err, nil
	}
	u := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err, nil
	}

	updateName, updatePosition, updateReaderData, updateAccessCount, updateAvailability := false, false, false, false, false

	if u.Name != nil {
		updateName = true
		card.Name = *u.Name
		self.Logger.Println("update Name", card.Name)
	}
	if u.Position != nil {
		updatePosition = true
		card.Position = uint(*u.Position)
		self.Logger.Println("update Position", card.Position)
	}
	if u.ReaderData != nil {
		updateReaderData = true
		card.ReaderData = util.NullableString(*u.ReaderData)
		self.Logger.Println("update ReaderData", card.ReaderData)
	}
	if u.AccessCount != nil {
		updateAccessCount = true
		card.AccessCount = uint(*u.AccessCount)
		self.Logger.Println("update AccessCount", card.AccessCount)
	}
	if u.Available != nil {
		updateAvailability = true
		card.CurrentlyAvailable = *u.Available
		self.Logger.Println("update CurrentlyAvailable", card.CurrentlyAvailable)
	}

	if updateName || updatePosition || updateReaderData || updateAccessCount || updateAvailability {
		if err := self.DB.Save(&card).Error; err != nil {
			return err, nil
		}
	}

	return nil, meridian.OkayMustJson(&card)
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
func (self *CardHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]
	card := model.Card{}
	if err := self.DB.Preload("Reservations").Where("name = ?", name).First(&card).Error; err != nil {
		return err, nil
	}

	if !card.CurrentlyAvailable {
		return fmt.Errorf("attempting to delete (currently) non-existent card '%s'", card.Name), nil
	}

	if len(card.Reservations) != 0 {
		return fmt.Errorf("attempting to delete card '%s' with remaining (possibly active) reservations", card.Name), nil
	}

	storages := make([]model.Storage, 0)
	if result := self.DB.Preload("Cards").Find(&storages); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("no storage units available"), nil
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
		return fmt.Errorf("found card that doesnt't belong to any storage-unit: %s (%s)", card.Name, name), nil
	}
	s := storages[sidx]
	c := s.Cards[cidx]

	if err := self.Controller.DeleteCardDispatcher(s.Name, s.Location, c.Name, c.Position); err != nil {
		return err, nil
	}

	return nil, meridian.Okay()
}

func (self *CardHandler) IncrementAccessCountHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]

	card := model.Card{}
	if err := self.DB.Where("name = ?", name).First(&card).Error; err != nil {
		return err, nil
	}

	card.AccessCount++
	if err := self.DB.Save(&card).Error; err != nil {
		return err, nil
	}

	return nil, meridian.Okay()
}

func (self *CardHandler) DecrementAccessCountHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]

	card := &model.Card{}
	if err := self.DB.Where("name = ?", name).First(card).Error; err != nil {
		return err, nil
	}

	if (card.AccessCount - 1) < 0 {
		return fmt.Errorf("attempting to decrement counter to negative realm"), nil
	}

	card.AccessCount--
	if err := self.DB.Save(card).Error; err != nil {
		return err, nil
	}

	return nil, meridian.Okay()
}

func (self *CardHandler) SetCardAvailabilityHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	vars := mux.Vars(req)
	name := vars["name"]
	flag := util.Must(strconv.ParseBool(vars["flag"])).(bool)

	card := model.Card{}
	if err := self.DB.Where("name = ?", name).First(&card).Error; err != nil {
		return err, nil
	}
	if card.CurrentlyAvailable == flag {
		return nil, meridian.Okay()
	}
	card.CurrentlyAvailable = flag
	if err := self.DB.Save(&card).Error; err != nil {
		return err, nil
	}
	return nil, meridian.Okay()
}

func (self *CardHandler) FetchCardKnownUserHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	vars := mux.Vars(req)
	name := vars["name"]
	email := vars["email"]

	user := model.User{}
	if err := self.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return err, nil
	}

	card := model.Card{}
	if err := self.DB.Where("name = ?", name).First(&card).Error; err != nil {
		return err, nil
	}

	if !card.CurrentlyAvailable {
		return fmt.Errorf("attempting to fetch currently unavailable card! '%s'", card.Name), nil
	}

	card.CurrentlyAvailable = false
	if err := self.DB.Save(&card).Error; err != nil {
		return err, nil
	}

	storages := make([]model.Storage, 0)
	if result := self.DB.Preload("Cards").Find(&storages); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("no storage units available"), nil
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
		return fmt.Errorf("found card that doesnt't belong to any storage-unit: %s (%s)", card.Name, name), nil
	}

	s := storages[sidx]
	c := s.Cards[cidx]

	if err := self.Controller.FetchCardKnownUserDispatcher(s.Name, s.Location, c.Name, c.Position, user.Email); err != nil {
		return err, nil
	}

	return nil, meridian.Okay()
}

func (self *CardHandler) FetchCardUnknownUserHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	vars := mux.Vars(req)
	name := vars["name"]

	card := model.Card{}
	if err := self.DB.Where("name = ?", name).First(&card).Error; err != nil {
		return err, nil
	}

	if !card.CurrentlyAvailable {
		return fmt.Errorf("attempting to fetch currently unavailable card! '%s'", card.Name), nil
	}

	storages := make([]model.Storage, 0)
	if result := self.DB.Preload("Cards").Find(&storages); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("no storage units available"), nil
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
		return fmt.Errorf("found card that doesnt't belong to any storage-unit: %s (%s)", card.Name, name), nil
	}

	s := storages[sidx]
	c := s.Cards[cidx]
	if err := self.Controller.FetchCardUnknownUserDispatcher(s.Name, s.Location, c.Name, c.Position); err != nil {
		return err, nil
	}

	return nil, meridian.Okay()
}
