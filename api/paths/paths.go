package paths

import (
	"regexp"
)

const (
	cardNamePattern          string = `[a-zA-Z0-9]{2,32}`
	storageNamePattern       string = `[a-zA-Z0-9]{2,32}`
	storageLocationPattern   string = `[a-zA-Z0-9]{2,32}`
	storageAddressPattern    string = `.{2,32}`
	storageCapacityPattern   string = `\d{1,2}`
	userEmailPattern         string = `[a-zA-Z0-9@._]{10,64}`
	reservationIdPattern     string = `\d{1,}`
	availabilityPattern      string = `(?:true|false)`
	applicationOriginPattern string = `(?:mobile|terminal)`
)

const (
	ApplicationOriginMobile   string = `mobile`
	ApplicationOriginTerminal string = `terminal`
)

var (
	CardNameMatcher          *regexp.Regexp = regexp.MustCompile(cardNamePattern)
	StorageNameMatcher       *regexp.Regexp = regexp.MustCompile(storageNamePattern)
	StorageLocationMatcher   *regexp.Regexp = regexp.MustCompile(storageLocationPattern)
	StorageAddressMatcher    *regexp.Regexp = regexp.MustCompile(storageAddressPattern)
	StorageCapacityMatcher   *regexp.Regexp = regexp.MustCompile(storageCapacityPattern)
	UserEmailMatcher         *regexp.Regexp = regexp.MustCompile(userEmailPattern)
	ReservationIdMatcher     *regexp.Regexp = regexp.MustCompile(reservationIdPattern)
	AvailabilityMatcher      *regexp.Regexp = regexp.MustCompile(availabilityPattern)
	ApplicationOriginMatcher *regexp.Regexp = regexp.MustCompile(applicationOriginPattern)
)

var (
	API_BASE_PATH                                     string = `/`
	API_STORAGES                                      string = `/storages`
	API_STORAGES_FILTER_NAME                          string = `/storages/name/{name:` + storageNamePattern + `}`
	API_STORAGES_PING_FILTER_NAME                     string = `/storages/ping/name/{name:` + storageNamePattern + `}`
	API_STORAGES_FOCUS_FILTER_NAME                    string = `/storages/focus/name/{name:` + storageNamePattern + `}`
	API_STORAGES_WS_LOG                               string = `/storages/log`
	API_STORAGES_CARDS                                string = `/storages/cards`
	API_STORAGES_CARDS_FILTER_NAME                    string = `/storages/cards/name/{name:` + cardNamePattern + `}`
	API_STORAGES_CARDS_FILTER_NAME_INCREMENT          string = `/storages/cards/name/{name:` + cardNamePattern + `}/increment`
	API_STORAGES_CARDS_FILTER_NAME_DECREMENT          string = `/storages/cards/name/{name:` + cardNamePattern + `}/decrement`
	API_STORAGES_CARDS_FILTER_NAME_AVAILABLE          string = `/storages/cards/name/{name:` + cardNamePattern + `}/available/{flag:` + availabilityPattern + `}`
	API_STORAGES_CARDS_FILTER_NAME_FETCH_KNOWN_USER   string = `/storages/cards/name/{name:` + cardNamePattern + `}/fetch/user/email/{email:` + userEmailPattern + `}`
	API_STORAGES_CARDS_FILTER_NAME_FETCH_UNKNOWN_USER string = `/storages/cards/name/{name:` + cardNamePattern + `}/fetch`
	API_STORAGES_CARDS_WS_LOG                         string = `/storages/cards/log`
	API_RESERVATIONS                                  string = `/storages/cards/reservations`
	API_RESERVATIONS_FILTER_CARD                      string = `/storages/cards/reservations/card/{name:` + cardNamePattern + `}`
	API_RESERVATIONS_FILTER_ID                        string = `/storages/cards/reservations/id/{id:` + reservationIdPattern + `}`
	API_RESERVATIONS_WS_LOG                           string = `/reservations/log`
	API_USERS_RESERVATIONS_FILTER_USER                string = `/users/reservations/email/{email:` + userEmailPattern + `}`
	API_USERS                                         string = `/users`
	API_USERS_FILTER_EMAIL                            string = `/users/email/{email:` + userEmailPattern + `}`
	API_USERS_WS_LOG                                  string = `/users/log`
	API_CONTROLLER_WS_LOG                             string = `/controller/log`
)
