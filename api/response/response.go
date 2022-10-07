package response

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type errToJson struct {
	err string `json:"error"`
}

func Json(res http.ResponseWriter, statuscode int, data interface{}) {
	res.WriteHeader(statuscode)
	if err := json.NewEncoder(res).Encode(data); err != nil {
		fmt.Fprintf(res, "%s", err.Error())
	}
}

func Err(res http.ResponseWriter, statuscode int, err error) {
	if err == nil {
		Json(res, http.StatusBadRequest, nil)
		return
	}
	Json(res, statuscode, errToJson{err: err.Error()})
}
