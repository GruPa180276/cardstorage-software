package response

import (
	"database/sql"
	"encoding/json"
	"fmt"
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
		storage.LocationId == model.LocationIdUnset ||
		storage.IpAddress == model.StorageUnitIpAddrUnset ||
		storage.Capacity == model.StorageUnitCapacityUnset {
		strerr := "error: at least one condition for adding new storage-unit not met"
		self.Println(strerr)
		util.HttpBasicJsonError(res, http.StatusBadRequest, strerr)
		return
	}

	// check if given locationid foreign key exists
	location := model.Location{Model: storage.Model}
	location.Id = storage.LocationId
	if err := location.SelectById(); err != nil {
		if err == sql.ErrNoRows {
			// invalid location id
			strerr := fmt.Sprintf("error: trying to add new card with non-existent storage '%s'", storage.String())
			self.Printf(strerr)
			util.HttpBasicJsonError(res, http.StatusBadRequest, strerr)
			return
		}
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

func (self *StorageUnit) PingStorageUnitByIdHandler(res http.ResponseWriter, req *http.Request) {
	self.Println(util.ErrNotImplemented)
	util.HttpBasicJsonError(res, http.StatusNotImplemented)
}
