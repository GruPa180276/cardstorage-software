package auth

import (
	"net/http"
	"strings"
	"time"

	jwt "github.com/golang-jwt/jwt/v4"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
)

// see https://www.rfc-editor.org/rfc/rfc7519#section-4.1
func NewToken(secret, issuer, email string, validHours uint, privileged bool) (string, error) {
	claims := jwt.MapClaims{}
	now := time.Now()
	claims["sub"] = email
	claims["priv"] = getAudience(privileged)
	claims["iss"] = issuer
	claims["exp"] = now.Add(time.Duration(validHours) * time.Hour).Unix()
	claims["iat"] = now.Unix()

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(secret))
}

// @todo validation of admin: parse token in header and check if "aud" == "Administrator"
func ValidateAdministrator(secret string) meridian.ValidatorFunc {
	return func(_ http.ResponseWriter, req *http.Request) bool {
		headerFull := strings.Join(req.Header["Authorization"], " ")
		if headerFull == "" {
			return false
		}
		headerParts := strings.Fields(headerFull)
		if len(headerParts) < 2 {
			return false
		}
		authType := headerParts[0]
		if "bearer" != strings.ToLower(authType) {
			return false
		}
		token, err := parse(headerParts[1], secret)
		if err != nil {
			println(err.Error())
			return false
		}
		if !token.Valid {
			return false
		}
		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			return false
		}
		if "Administrator" != claims["priv"] {
			return false
		}
		return true
	}
}

func ValidateUser(secret string) meridian.ValidatorFunc {
	return func(_ http.ResponseWriter, req *http.Request) bool {
		headerFull := strings.Join(req.Header["Authorization"], " ")
		if headerFull == "" {
			return false
		}
		headerParts := strings.Fields(headerFull)
		if len(headerParts) < 2 {
			return false
		}
		authType := headerParts[0]
		if "bearer" != strings.ToLower(authType) {
			return false
		}
		token, err := parse(headerParts[1], secret)
		if err != nil {
			println(err.Error())
			return false
		}
		if !token.Valid {
			return false
		}
		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			return false
		}
		if "Administrator" != claims["priv"] && "User" != claims["priv"] {
			return false
		}
		return true
	}
}

func getAudience(privileged bool) (audience string) {
	if privileged {
		audience = "Administrator"
	} else {
		audience = "User"
	}
	return
}

func fromPermission(audience string) (privileged bool) {
	if audience == "Administrator" {
		privileged = true
	} else {
		privileged = false
	}
	return
}

func parse(token, secret string) (*jwt.Token, error) {
	return jwt.Parse(token, func(parsedToken *jwt.Token) (interface{}, error) {
		return []byte(secret), nil
	})
}
