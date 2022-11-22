package response

import (
	"database/sql"
	"encoding/json"
	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"log"
	"net/http"
	"strconv"
)

type StorageUnit struct {
	*sql.DB
	*log.Logger
}

func (self *StorageUnit) GetAllStorageUnitsHandler(res http.ResponseWriter, req *http.Request) {
	storage := model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	storages, err := storage.SelectAll()
	if err != nil {
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(storages); err != nil {
		self.Println(err)
		return
	}
}

func (self *StorageUnit) GetStorageUnitByIdHandler(res http.ResponseWriter, req *http.Request) {
	storage := model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["id"])

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}

	storage.Id = id
	err = storage.SelectById()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(storage); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}

func (self *StorageUnit) GetStorageUnitByNameHandler(res http.ResponseWriter, req *http.Request) {
	storage := model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["name"])

	storage.Name = vars["name"]
	err := storage.SelectByName()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(storage); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}

func (self *StorageUnit) AddNewStorageUnitHandler(res http.ResponseWriter, req *http.Request) {
	storage := model.StorageUnit{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(&storage); err != nil {
		self.Println(err)
		return
	}

	if storage.Name == model.StorageUnitNameUnset ||
		storage.LocationId == model.LocationIdUnset ||
		storage.IpAddress == model.StorageUnitIpAddrUnset ||
		storage.Capacity == model.StorageUnitCapacityUnset {
		return
	}

	// check if given locationid foreign key exists
	location := model.Location{Model: storage.Model}
	location.Id = storage.LocationId
	if err := location.SelectById(); err != nil {
		if err == sql.ErrNoRows {
			// invalid location id
			self.Printf("error: trying to add new storage-unit with non-existent location '%s'\n", (&location).String())
			return
		}
	}

	storageCopy := model.CopyStorageUnit(&storage)
	err := storageCopy.SelectByName()

	if err != nil && err != sql.ErrNoRows {
		self.Println(err)
		return
	}

	// insert only if there is no storage-unit with the same id yet
	if err == sql.ErrNoRows {
		if err := storage.Insert(); err != nil {
			self.Println(err)
			return
		}
		self.Println("successfully inserted " + (&storage).String())
	}
}

func (self *StorageUnit) PingStorageUnitById(res http.ResponseWriter, req *http.Request) {
	self.Fatalln(util.ErrNotImplemented)
}
