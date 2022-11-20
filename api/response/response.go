package response

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

type errToJson struct {
	err string `json:"error"`
}

func Json(res *http.ResponseWriter, statuscode int, data interface{}) {
	(*res).WriteHeader(statuscode)
	if err := json.NewEncoder(*res).Encode(data); err != nil {
		fmt.Fprintf(os.Stderr, "%s", err.Error())
	}
}

func Err(res *http.ResponseWriter, statuscode int, err error) {
	Json(res, statuscode, errToJson{err: err.Error()})
}
