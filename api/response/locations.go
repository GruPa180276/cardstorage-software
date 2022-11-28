package response

import (
	"database/sql"
	"encoding/json"
	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"log"
	"net/http"
	"strconv"
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
		return
	}

	if err := json.NewEncoder(res).Encode(locations); err != nil {
		self.Println(err)
		return
	}
}

func (self *Location) GetLocationByIdHandler(res http.ResponseWriter, req *http.Request) {
	location := model.Location{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["id"])

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}

	location.Id = id
	err = location.SelectById()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(location); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}

func (self *Location) GetLocationByNameHandler(res http.ResponseWriter, req *http.Request) {
	location := model.Location{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["name"])

	location.Location = vars["name"]
	err := location.SelectByName()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(location); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}

func (self *Location) AddNewLocationHandler(res http.ResponseWriter, req *http.Request) {
	location := model.Location{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(&location); err != nil {
		self.Println(err)
		return
	}

	if location.Location == model.LocationNameUnset {
		return
	}

	locationCopy := model.ShallowCopyLocation(&location)
	err := locationCopy.SelectByName()

	if err != nil && err != sql.ErrNoRows {
		self.Println(err)
		return
	}

	// insert only if there is no user with the same email yet
	if err == sql.ErrNoRows {
		if err := location.Insert(); err != nil {
			self.Println(err)
			return
		}
		self.Println("successfully inserted " + (&location).String())
	}
}
