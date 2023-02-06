package auth

import (
	"net/http"
	"strings"
	"time"

	jwt "github.com/golang-jwt/jwt/v4"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
)

// see https://www.rfc-editor.org/rfc/rfc7519#section-4.1
func NewToken(secret, issuer, email string, validMinutes uint, privileged string) (string, error) {
	claims := jwt.MapClaims{}
	now := time.Now()
	claims["sub"] = email
	claims["priv"] = privileged
	claims["iss"] = issuer
	claims["exp"] = now.Add(time.Duration(validMinutes) * time.Minute).Unix()
	claims["iat"] = now.Unix()

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(secret))
}

// @todo validation of admin: parse token in header and check if "aud" == "Administrator"
func ValidateAdministrator(secret string) meridian.ValidatorFunc {
	return func(_ http.ResponseWriter, req *http.Request) bool {
		ok, claims := basicValidation(req.Header["Authorization"], secret)
		if !ok {
			return false
		}
		if !isAdmin((*claims)["priv"].(string)) {
			return false
		}
		return true
	}
}

func ValidateUser(secret string) meridian.ValidatorFunc {
	return func(_ http.ResponseWriter, req *http.Request) bool {
		ok, claims := basicValidation(req.Header["Authorization"], secret)
		if !ok {
			return false
		}
		if !isAdmin((*claims)["priv"].(string)) &&
			!isUser((*claims)["priv"].(string)) {
			return false
		}
		return true
	}
}

func ValidateAnonymous(secret string) meridian.ValidatorFunc {
	return func(_ http.ResponseWriter, req *http.Request) bool {
		ok, claims := basicValidation(req.Header["Authorization"], secret)
		if !ok {
			return false
		}
		if !isAnonymous((*claims)["priv"].(string)) &&
			!isAdmin((*claims)["priv"].(string)) &&
			!isUser((*claims)["priv"].(string)) {
			return false
		}
		return true
	}
}

const (
	PrivilegeAdmin     = "Administrator"
	PrivilegeUser      = "User"
	PrivilegeAnonymous = "Anonymous"
)

func basicValidation(authHeader []string, secret string) (bool, *jwt.MapClaims) {
	headerFull := strings.Join(authHeader, " ")
	if headerFull == "" {
		return false, nil
	}
	headerParts := strings.Fields(headerFull)
	if len(headerParts) < 2 {
		return false, nil
	}
	authType := headerParts[0]
	if "bearer" != strings.ToLower(authType) {
		return false, nil
	}
	token, err := parse(headerParts[1], secret)
	if err != nil {
		println(err.Error())
		return false, nil
	}
	if !token.Valid {
		return false, nil
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return false, nil
	}
	return true, &claims
}

func isAdmin(privileged string) bool {
	return PrivilegeAdmin == strings.Trim(privileged, "\n ")
}

func isUser(privileged string) bool {
	return PrivilegeUser == strings.Trim(privileged, "\n ")
}

func isAnonymous(privileged string) bool {
	return PrivilegeAnonymous == strings.Trim(privileged, "\n ")
}

func parse(token, secret string) (*jwt.Token, error) {
	return jwt.Parse(token, func(parsedToken *jwt.Token) (interface{}, error) {
		return []byte(secret), nil
	})
}
