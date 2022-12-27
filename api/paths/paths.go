package paths

import (
	"regexp"
)

var (
	cardNamePattern        = `[a-zA-Z0-9]{2,32}`
	storageNamePattern     = `[a-zA-Z0-9]{2,32}`
	storageLocationPattern = `[a-zA-Z0-9]{2,32}`
	storageAddressPattern  = `.{2,32}`
	storageCapacityPattern = `\d{1,2}`
	userEmailPattern       = `[a-zA-Z0-9@._]{10,64}`
)

var (
	CardNameMatcher        = regexp.MustCompile(cardNamePattern)
	StorageNameMatcher     = regexp.MustCompile(storageNamePattern)
	StorageLocationMatcher = regexp.MustCompile(storageLocationPattern)
	StorageAddressMatcher  = regexp.MustCompile(storageAddressPattern)
	StorageCapacityMatcher = regexp.MustCompile(storageCapacityPattern)
	UserEmailMatcher       = regexp.MustCompile(userEmailPattern)
)

var (
	API_BASE_PATH                  = `/`
	API_STORAGES                   = `/storages`
	API_STORAGES_FILTER_NAME       = `/storages/name/{name:` + storageNamePattern + `}`
	API_STORAGES_CARDS             = `/storages/cards`
	API_STORAGES_CARDS_FILTER_NAME = `/storages/cards/name/{name:` + cardNamePattern + `}`
	API_USERS                      = `/users`
	API_USERS_FILTER_EMAIL         = `/users/email/{email:` + userEmailPattern + `}`
)
