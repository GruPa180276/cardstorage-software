package response

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"gorm.io/gorm"
)

type DataStore struct {
	*log.Logger
	*gorm.DB
}

type Initializer interface {
	RegisterHandlers(*mux.Router)
}

func OptionsHandler(res http.ResponseWriter, req *http.Request) {
	util.HttpBasicJsonError(res, http.StatusNotImplemented)
}
