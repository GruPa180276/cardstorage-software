package response

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Location struct {
	*sql.DB
	*log.Logger
}

func (self *Location) GetAllLocationsHandler(res http.ResponseWriter, req *http.Request) {
	location := model.Location{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	locations, err := location.SelectAll()
	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(locations); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *Location) GetLocationByIdHandler(res http.ResponseWriter, req *http.Request) {
	location := model.Location{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Printf("trying to get card #%s by id", vars["id"])

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		return
	}

	location.Id = id
	err = location.SelectById()

	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(location); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *Location) GetLocationByNameHandler(res http.ResponseWriter, req *http.Request) {
	location := model.Location{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Printf("trying to get card '%s' by name", vars["name"])

	location.Location = vars["name"]
	err := location.SelectByName()

	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(location); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *Location) AddNewLocationHandler(res http.ResponseWriter, req *http.Request) {
	location := &model.Location{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(location); err != nil {
		self.Println(err)
		return
	}

	if location.Location == model.LocationNameUnset {
		strerr := "error: at least one condition for adding new location not met"
		self.Println(strerr)
		util.HttpBasicJsonError(res, http.StatusBadRequest, strerr)
		return
	}

	locationCopy := model.ShallowCopyLocation(location)
	err := locationCopy.SelectByName()

	if err != nil && err != sql.ErrNoRows {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}

	// insert only if there is no user with the same email yet
	if err == sql.ErrNoRows {
		if err := location.Insert(); err != nil {
			self.Println(err)
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
			return
		}
		self.Println("successfully inserted", location.String())
	} else {
		self.Println("duplicate entry", location.String())
		util.HttpBasicJsonError(res, http.StatusBadRequest, "duplicate entry")
		return
	}
}
