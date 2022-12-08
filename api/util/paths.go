package util

const (
	API_BASE_PATH                   = `/`
	API_STORAGEUNITS                = `/storage-units`
	API_STORAGEUNITS_FILTER_ID      = `/storage-units/id/{id:[0-9]{1,10}}`
	API_STORAGEUNITS_FILTER_NAME    = `/storage-units/name/{name:[a-zA-Z0-9-_]{3,100}}`
	API_STORAGEUNITS_PING_FILTER_ID = `/storage-units/ping/id/{id:[0-9]{1,10}}`
	API_CARDS                       = `/cards`
	API_CARDS_FILTER_ID             = `/cards/id/{id:[0-9]{1,10}}`
	API_CARDS_FILTER_NAME           = `/cards/name/{name:[a-zA-Z0-9-_]{3,100}}`
	API_CARDS_STATUS                = `/cards/status`
	API_CARDS_STATUS_FILTER_ID      = `/cards/status/id/{id:[0-9]{1,10}}`
	API_USERS                       = `/users`
	API_USERS_SIGN_UP               = `/users/sign-up`
	API_USERS_FILTER_ID             = `/users/id/{id:[0-9]{1,10}}`
	API_USERS_FILTER_EMAIL          = `/users/email/{email:[a-zA-Z0-9.@-_]{5,100}}`
	API_USERS_FILTER_READER         = `/users/reader/{reader:[a-zA-Z0-9-_]{5,100}}`
	API_LOCATIONS                   = `/locations`
	API_LOCATIONS_FILTER_ID         = `/locations/id/{id:[0-9]{1,10}}`
	API_LOCATIONS_FILTER_NAME       = `/locations/name/{name:[a-zA-Z0-9-_]{3,100}}`
)