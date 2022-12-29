module response

go 1.18

replace (
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller => ../controller
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian => ../meridian
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model => ../model
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/observer => ../observer
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths => ../paths
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util => ../util
)

require (
	github.com/gorilla/mux v1.8.0
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller v0.0.0-00010101000000-000000000000
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian v0.0.0-00010101000000-000000000000
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model v0.0.0-00010101000000-000000000000
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/observer v0.0.0-00010101000000-000000000000
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths v0.0.0-00010101000000-000000000000
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util v0.0.0-00010101000000-000000000000
	gorm.io/gorm v1.24.2
)

require (
	github.com/google/uuid v1.3.0 // indirect
	github.com/gorilla/websocket v1.4.2 // indirect
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.4 // indirect
	golang.org/x/net v0.0.0-20200425230154-ff2c4b7c35a0 // indirect
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c // indirect
)
