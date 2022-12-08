package controller

import (
	"encoding/json"

	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

//go:generate go-enum --marshal
/* ENUM(
	invalid,
	storage-unit-ping,
	storage-unit-new,
	storage-unit-new-card,
	storage-unit-delete-card,
	storage-unit-fetch-card,
	user-signup-source-mobile,
	user-signup-source-terminal,
	user-fetch-token,
	user-existence
)
*/
type Action string

func ActionsToJSON() ([]byte, error) {
	return json.Marshal(util.Values(_ActionValue))
}
