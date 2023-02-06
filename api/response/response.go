package response

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Initializer interface {
	RegisterHandlers(router *mux.Router, validationSecret string)
}

var ErrorHandlerFactory = func(logger *log.Logger, logChannel chan string) meridian.ReportingErrorHandlerFunc {
	return func(err error, res http.ResponseWriter, req *http.Request) {
		jsonErrStr := util.JsonError(http.StatusBadRequest, err.Error())
		logger.Println(jsonErrStr)
		logChannel <- jsonErrStr
		http.Error(res, jsonErrStr, http.StatusBadRequest)
	}
}

var SuccessHandlerFactory = func(logger *log.Logger) meridian.ReportingSuccessHandlerFunc {
	return func(ok *meridian.Ok, res http.ResponseWriter, req *http.Request) {
		msg := ok.Error()
		if ok.ToJson {
			msg = string(util.Must(json.Marshal(msg)).([]byte))
		}
		logger.Println(msg)
		res.WriteHeader(http.StatusOK)
		if _, err2 := res.Write([]byte(msg)); err2 != nil {
			logger.Println(err2)
		}
	}
}
