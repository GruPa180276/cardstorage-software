package response

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
)

type StorageDataStore DataStore
type StorageHandler StorageDataStore

func (self *StorageDataStore) RegisterHandlers(router *mux.Router) {
	handler := StorageHandler(*self)
	errHandler := ErrorHandlerFactory(self.Logger)
	successHandler := SuccessHandlerFactory(self.Logger)
	router.HandleFunc(paths.API_STORAGES, meridian.Reporter(handler.GetAllHandler, errHandler, successHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_FILTER_NAME, meridian.Reporter(handler.GetByNameHandler, errHandler, successHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES, meridian.Reporter(handler.CreateHandler, errHandler, successHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_STORAGES_FILTER_NAME, meridian.Reporter(handler.UpdateHandler, errHandler, successHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_FILTER_NAME, meridian.Reporter(handler.DeleteHandler, errHandler, successHandler)).Methods(http.MethodDelete)
}

func (self *StorageHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) error {
	storages := make([]*model.Storage, 0)

	if err := self.DB.Preload("Cards").Find(&storages).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(storages); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *StorageHandler) GetByNameHandler(res http.ResponseWriter, req *http.Request) error {
	name, ok := mux.Vars(req)["name"]
	if !ok {
		return fmt.Errorf("invalid field 'name': %s", name)
	}
	storage := &model.Storage{}
	if err := self.DB.Preload("Cards").Where("name = ?", name).Find(storage).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(storage); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *StorageHandler) CreateHandler(res http.ResponseWriter, req *http.Request) error {
	type Creator struct {
		Name     string `json:"name"`
		Location string `json:"location"`
		Address  string `json:"address"`
		Capacity *uint  `json:"capacity"`
	}
	c := &Creator{}

	if err := json.NewDecoder(req.Body).Decode(&c); err != nil {
		return err
	}
	if !paths.StorageNameMatcher.MatchString(c.Name) {
		return fmt.Errorf("attribute 'name' does not match required pattern: %s", c.Name)
	}
	if !paths.StorageLocationMatcher.MatchString(c.Location) {
		return fmt.Errorf("attribute 'location' does not match required pattern: %s", c.Location)
	}
	if !paths.StorageAddressMatcher.MatchString(c.Address) {
		return fmt.Errorf("attribute 'address' does not match required pattern: %s", c.Address)
	}
	if c.Capacity != nil {
		if !paths.StorageCapacityMatcher.MatchString(fmt.Sprintf("%d", *c.Capacity)) {
			return fmt.Errorf("attribute 'capacity' does not match required pattern: %s", c.Name)
		}
	}

	s := &model.Storage{Name: c.Name, Location: c.Location, Address: c.Address}
	if c.Capacity != nil {
		s.Capacity = *c.Capacity
	}

	if err := self.DB.Create(s).Error; err != nil {
		return err
	}

	s2 := &model.Storage{}
	if err := self.DB.Preload("Cards").Where("name = ?", s.Name).Find(s2).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(s2); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *StorageHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) error {
	type Updater struct {
		Name     *string `json:"name"`
		Location *string `json:"location"`
		Address  *string `json:"address"`
		Capacity *uint   `json:"capacity"`
	}
	s := &model.Storage{}
	vars := mux.Vars(req)
	if err := self.DB.Preload("Cards").Where("name = ?", vars["name"]).Find(s).Error; err != nil {
		return fmt.Errorf("card '%s' does not exist; %s", vars["name"], err.Error())
	}

	u := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err
	}

	updateName, updateLocation, updateAddress, updateCapacity := false, false, false, false

	if u.Name != nil {
		updateName = true
		s.Name = *u.Name
		self.Logger.Println("update Name", s.Name)
	}
	if u.Location != nil {
		updateLocation = true
		s.Location = *u.Location
		self.Logger.Println("update Location", s.Location)
	}
	if u.Address != nil {
		updateAddress = true
		s.Address = *u.Address
		self.Logger.Println("update Address", s.Address)
	}
	if u.Capacity != nil {
		updateCapacity = true
		s.Capacity = *u.Capacity
		self.Logger.Println("update Capacity", s.Capacity)
	}

	if updateName || updateLocation || updateAddress || updateCapacity {
		if err := self.DB.Save(s).Error; err != nil {
			return err
		}
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(s); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *StorageHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) error {
	vars := mux.Vars(req)
	s := &model.Storage{}
	if err := self.DB.Preload("Cards").Where("name = ?", vars["name"]).Find(s).Error; err != nil {
		return err
	}
	if len(s.Cards) != 0 {
		return fmt.Errorf("attempting to delete non-empty storage '%s'", s.Name)
	}
	if err := self.DB.Delete(s).Error; err != nil {
		return err
	}

	return meridian.Ok
}
