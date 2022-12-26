package response

import (
	"bytes"
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type CardDataStore DataStore
type CardHandler CardDataStore

func (self *CardDataStore) RegisterHandlers(router *mux.Router) {
	handler := CardHandler(*self)
	router.HandleFunc(paths.API_STORAGES_CARDS, handler.GetAllHandler).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_CARDS_FILTER_NAME, handler.GetByNameHandler).Methods(http.MethodGet)
}

func (self *CardHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) {
	cards := make([]*model.Card, 0)

	if result := self.DB.Find(&cards); result.Error != nil {
		self.Logger.Println(result.Error)
		util.HttpBasicJsonError(res, http.StatusBadRequest)
		return
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(cards); err != nil {
		self.Logger.Println(err)
		util.HttpBasicJsonError(res, http.StatusBadRequest)
		return
	}

	res.WriteHeader(http.StatusOK)
	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return
	}
}

func (self *CardHandler) GetByNameHandler(res http.ResponseWriter, req *http.Request) {

}

func (self *CardHandler) InsertHandler(res http.ResponseWriter, req *http.Request) {

}

func (self *CardHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) {

}

func (self *CardHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) {

}

func (self *CardHandler) WebSocketUpgrader(res http.ResponseWriter, req *http.Request) {

}
