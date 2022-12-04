package tests

import "log"

const (
	API_HOST          = "http://localhost:7171"
	API_BASE_PATH     = API_HOST + "/api"
	API_STORAGE_UNITS = API_BASE_PATH + "/storage-units"
	API_CARDS         = API_BASE_PATH + "/cards"
)

func must(value interface{}, err error) interface{} {
	if err != nil {
		log.Fatalln(err.Error())
	}
	return value
}
