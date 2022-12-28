module controller

go 1.18

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util => ../util

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model => ../model

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths => ../paths

require (
	golang.org/x/net v0.0.0-20200425230154-ff2c4b7c35a0 // indirect
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c // indirect
)

require (
	github.com/eclipse/paho.mqtt.golang v1.4.2
	github.com/google/uuid v1.3.0
	github.com/gorilla/mux v1.8.0
	github.com/gorilla/websocket v1.4.2
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths v0.0.0-00010101000000-000000000000
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util v0.0.0-00010101000000-000000000000
)
