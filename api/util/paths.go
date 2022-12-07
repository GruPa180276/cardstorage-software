package util

const (
	API_BASE_PATH                   = `/api`
	API_STORAGEUNITS                = API_BASE_PATH + `/storage-units`
	API_STORAGEUNITS_FILTER_ID      = API_BASE_PATH + `/storage-units/id/{id:[0-9]{1,10}}`
	API_STORAGEUNITS_FILTER_NAME    = API_BASE_PATH + `/storage-units/name/{name:[a-zA-Z0-9-_]{3,100}}`
	API_STORAGEUNITS_PING_FILTER_ID = API_BASE_PATH + `/storage-units/ping/id/{id:[0-9]{1,10}}`
	API_CARDS                       = API_BASE_PATH + `/cards`
	API_CARDS_FILTER_ID             = API_BASE_PATH + `/cards/id/{id:[0-9]{1,10}}`
	API_CARDS_FILTER_NAME           = API_BASE_PATH + `/cards/name/{name:[a-zA-Z0-9-_]{3,100}}`
	API_CARDS_STATUS                = API_BASE_PATH + `/cards/status`
	API_CARDS_STATUS_FILTER_ID      = API_BASE_PATH + `/cards/status/id/{id:[0-9]{1,10}}`
	API_USERS                       = API_BASE_PATH + `/users`
	API_USERS_SIGN_UP               = API_BASE_PATH + `/users/sign-up`
	API_USERS_FILTER_ID             = API_BASE_PATH + `/users/id/{id:[0-9]{1,10}}`
	API_USERS_FILTER_EMAIL          = API_BASE_PATH + `/users/email/{email:[a-zA-Z0-9.@-_]{5,100}}`
	API_USERS_FILTER_READER         = API_BASE_PATH + `/users/reader/{reader:[a-zA-Z0-9-_]{5,100}}`
	API_LOCATIONS                   = API_BASE_PATH + `/locations`
	API_LOCATIONS_FILTER_ID         = API_BASE_PATH + `/locations/id/{id:[0-9]{1,10}}`
	API_LOCATIONS_FILTER_NAME       = API_BASE_PATH + `/locations/name/{name:[a-zA-Z0-9-_]{3,100}}`
)
