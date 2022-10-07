package auth

import (
	"time"

	jwt "github.com/golang-jwt/jwt/v4"
)

func Token(userid int, tokenValidTimeHours uint, apiSecret string) (string, error) {
	var claims = jwt.MapClaims{}
	claims["authorized"] = true
	claims["userid"] = userid
	claims["validuntil"] = time.Now().Add(time.Duration(tokenValidTimeHours) * time.Hour).Unix()
	var token = jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(apiSecret))
}
