package response

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"sync"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/observer"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type StorageUnit struct {
	*sql.DB
	*log.Logger
	*sync.Map
	mqtt.Client
}

func (self *StorageUnit) GetAllStorageUnitsHandler(res http.ResponseWriter, req *http.Request) {
	storage := model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	storages, err := storage.SelectAll()
	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(storages); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *StorageUnit) GetStorageUnitByIdHandler(res http.ResponseWriter, req *http.Request) {
	storage := model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Printf("trying to get storage-unit '%s' by id", vars["name"])

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		self.Println(err)
		return
	}

	storage.Id = id
	err = storage.SelectById()

	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(storage); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *StorageUnit) GetStorageUnitByNameHandler(res http.ResponseWriter, req *http.Request) {
	storage := model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Printf("trying to get storage-unit '%s' by name", vars["name"])

	storage.Name = vars["name"]
	err := storage.SelectByName()

	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(storage); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *StorageUnit) AddNewStorageUnitHandler(res http.ResponseWriter, req *http.Request) {
	storage := &model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(storage); err != nil {
		self.Println(err)
		return
	}

	if storage.Name == model.StorageUnitNameUnset ||
		storage.Location == model.LocationNameUnset ||
		storage.IpAddress == model.StorageUnitIpAddrUnset ||
		storage.Capacity == model.StorageUnitCapacityUnset {
		strerr := "error: at least one condition for adding new storage-unit not met"
		self.Println(strerr)
		util.HttpBasicJsonError(res, http.StatusBadRequest, strerr)
		return
	}

	storageCopy := model.ShallowCopyStorageUnit(storage)
	err := storageCopy.SelectByName()

	if err != nil && err != sql.ErrNoRows {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}

	// insert only if there is no storage-unit with the same id yet
	if err == sql.ErrNoRows {
		if err := storage.Insert(); err != nil {
			self.Println(err)
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
			return
		}
		self.Println("successfully inserted " + storage.String())
	}
}

func (self *StorageUnit) PingStorageUnitByNameHandler(res http.ResponseWriter, req *http.Request) {
	name := mux.Vars(req)["name"]
	storage := model.StorageUnit{Model: &model.Model{self.DB, self.Logger}, Name: name}
	if err := storage.SelectByName(); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		return
	}

	c := controller.Controller{Logger: self.Logger, Map: self.Map, Client: self.Client}
	opts := self.Client.OptionsReader()
	topic := observer.AssembleBaseStorageTopic(storage, storage.Location)
	if err := c.PingStorageUnitInvoker(storage.Name, topic, opts.ClientID()); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
	self.Printf("successfully pinged storage-unit %q", topic)
}
