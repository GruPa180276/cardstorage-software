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

type CardStatus struct {
	*sql.DB
	*log.Logger
}

func (self *CardStatus) GetAllCardsStatusHandler(res http.ResponseWriter, req *http.Request) {
	cs := model.CardStatus{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	csAll, err := cs.SelectAll()
	if err != nil {
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(csAll); err != nil {
		self.Println(err)
		return
	}
}

func (self *CardStatus) GetCardStatusByCardIdHandler(res http.ResponseWriter, req *http.Request) {
	cs := model.CardStatus{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["id"])

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}

	cs.Id = id
	err = cs.SelectByCardId()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(cs); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}

func (self *CardStatus) PostCardStatusByCardIdHandler(res http.ResponseWriter, req *http.Request) {
	self.Println(util.ErrNotImplemented)
}

func (self *CardStatus) PutCardStatusByCardIdHandler(res http.ResponseWriter, req *http.Request) {
	cs := &model.CardStatus{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(cs); err != nil {
		self.Println(err)
		return
	}
	if cs.CardId == model.CardStatusIdUnset {
		self.Println("error: trying to update card-status with unknown card-id")
		return
	}
	if err := cs.UpdateByCardId(); err != nil {
		self.Println(err)
		return
	}
}
