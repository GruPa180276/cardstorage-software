package response

import (
	"net/http"

	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

func OptionsHandler(res http.ResponseWriter, req *http.Request) {
	util.HttpBasicJsonError(res, http.StatusNotImplemented)
}
