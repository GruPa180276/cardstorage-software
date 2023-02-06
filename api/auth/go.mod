module auth

go 1.18

require (
	github.com/golang-jwt/jwt/v4 v4.4.3
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian v0.0.0-00010101000000-000000000000
)

require (
	github.com/eclipse/paho.mqtt.golang v1.4.2 // indirect
	github.com/gorilla/mux v1.8.0 // indirect
	github.com/gorilla/websocket v1.4.2 // indirect
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util v0.0.0-00010101000000-000000000000 // indirect
	golang.org/x/net v0.0.0-20200425230154-ff2c4b7c35a0 // indirect
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c // indirect
)

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util => ../util

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian => ../meridian
