module sandbox

go 1.18

require github.com/google/uuid v1.3.0

replace github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util => ./../api/util

require (
	github.com/golang-jwt/jwt/v4 v4.4.3
	github.com/joho/godotenv v1.4.0
	github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util v0.0.0-00010101000000-000000000000
)

require (
	github.com/go-sql-driver/mysql v1.7.0 // indirect
	github.com/gorilla/mux v1.8.0
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.5 // indirect
	gorm.io/driver/mysql v1.4.4
	gorm.io/gorm v1.24.2
)
