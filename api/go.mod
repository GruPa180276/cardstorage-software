module github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api

go 1.18

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/response => ./response

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model => ./model

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util => ./util

require (
	github.com/go-sql-driver/mysql v1.6.0
	github.com/golang-jwt/jwt/v4 v4.4.2
	github.com/gorilla/mux v1.8.0
	github.com/joho/godotenv v1.4.0
	github.com/mochi-co/mqtt v1.3.2
)

require (
	github.com/gorilla/websocket v1.5.0 // indirect
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model v0.0.0-00010101000000-000000000000 // indirect
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/response v0.0.0-00010101000000-000000000000 // indirect
	github.com/rs/xid v1.4.0 // indirect
)
