package response

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Initializer interface {
	RegisterHandlers(*mux.Router)
}

var ErrorHandlerFactory = func(logger *log.Logger) meridian.ReportingErrorHandlerFunc {
	return func(err error, res http.ResponseWriter, req *http.Request) {
		logger.Println(err.Error())
		util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
	}
}

var SuccessHandlerFactory = func(logger *log.Logger) meridian.ReportingSuccessHandlerFunc {
	return func(res http.ResponseWriter, req *http.Request) {
		if err := util.HttpBasicJsonResponse(res, http.StatusOK, nil); err != nil {
			logger.Println(err)
		}
	}
}
