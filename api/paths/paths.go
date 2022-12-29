package paths

import (
	"regexp"
)

var (
	cardNamePattern        string = `[a-zA-Z0-9]{2,32}`
	storageNamePattern     string = `[a-zA-Z0-9]{2,32}`
	storageLocationPattern string = `[a-zA-Z0-9]{2,32}`
	storageAddressPattern  string = `.{2,32}`
	storageCapacityPattern string = `\d{1,2}`
	userEmailPattern       string = `[a-zA-Z0-9@._]{10,64}`
	reservationIdPattern   string = `\d{1,}`
)

var (
	CardNameMatcher        *regexp.Regexp = regexp.MustCompile(cardNamePattern)
	StorageNameMatcher     *regexp.Regexp = regexp.MustCompile(storageNamePattern)
	StorageLocationMatcher *regexp.Regexp = regexp.MustCompile(storageLocationPattern)
	StorageAddressMatcher  *regexp.Regexp = regexp.MustCompile(storageAddressPattern)
	StorageCapacityMatcher *regexp.Regexp = regexp.MustCompile(storageCapacityPattern)
	UserEmailMatcher       *regexp.Regexp = regexp.MustCompile(userEmailPattern)
	ReservationIdMatcher   *regexp.Regexp = regexp.MustCompile(reservationIdPattern)
)

var (
	API_BASE_PATH                  string = `/`
	API_STORAGES                   string = `/storages`
	API_STORAGES_FILTER_NAME       string = `/storages/name/{name:` + storageNamePattern + `}`
	API_STORAGES_CARDS             string = `/storages/cards`
	API_STORAGES_CARDS_FILTER_NAME string = `/storages/cards/name/{name:` + cardNamePattern + `}`
	API_STORAGES_PING_FILTER_NAME  string = `/storages/ping/name/{name:` + storageNamePattern + `}`
	API_STORAGES_FOCUS_FILTER_NAME string = `/storages/focus/name/{name:` + storageNamePattern + `}`
	API_RESERVATIONS               string = `/storages/cards/reservations`
	API_RESERVATIONS_FILTER_USER   string = `/users/reservations/email/{email:` + userEmailPattern + `}`
	API_RESERVATIONS_FILTER_CARD   string = `/storages/cards/reservations/card/{name:` + cardNamePattern + `}`
	API_RESERVATIONS_FILTER_ID     string = `/storages/cards/reservations/id/{id:` + reservationIdPattern + `}`
	API_USERS                      string = `/users`
	API_USERS_FILTER_EMAIL         string = `/users/email/{email:` + userEmailPattern + `}`
	API_WS_LOG_CONTROLLER_CHANNEL  string = `/log/controller`
)
