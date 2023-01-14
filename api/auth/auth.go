package auth

import (
	"time"

	jwt "github.com/golang-jwt/jwt/v4"
)

func NewToken(email string, validForHours uint, secret string) (string, error) {
	claims := jwt.MapClaims{}
	now := time.Now()
	claims["authorized"] = true
	claims["userEmail"] = email
	claims["validFor"] = validForHours
	claims["validUntil"] = now.Add(time.Duration(validForHours) * time.Hour).Unix()
	var token = jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(secret))
}

func Validate(token string) bool {
	return true
}
