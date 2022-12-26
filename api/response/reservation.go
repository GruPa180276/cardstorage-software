package response

import (
	"github.com/gorilla/mux"
)

type ReservationDataStore DataStore
type ReservationHandler CardDataStore

func (self *ReservationDataStore) RegisterHandlers(router *mux.Router) {
}
