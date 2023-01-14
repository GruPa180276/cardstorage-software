package main

import (
	"net/http"
	"sync"
	"time"

	jwt "github.com/golang-jwt/jwt/v4"
	"github.com/gorilla/mux"
)

// get from environment
const (
	validForHours uint   = 1
	secret        string = "xyz"
	privileged    bool   = false
)

func main() {
	l := &sync.Mutex{}
	users := map[string]*string{
		"abc@litec.ac.at": nil,
		"cde@litec.ac.at": nil,
		"efg@litec.ac.at": nil,
		"ghi@litec.ac.at": nil,
	}

	router := mux.NewRouter()

	router.HandleFunc("/auth/{email:[a-zA-Z0-9@._]{10,64}}", func(res http.ResponseWriter, req *http.Request) {
		email := mux.Vars(req)["email"]
		l.Lock()
		token, ok := users[email]
		l.Unlock()

		if !ok {
			http.Error(res, "attempting to authenticate non-existent user", http.StatusNotFound)
			return
		}

		// @todo check if token is still valid, if yes then just return, if not then reauthenticate
		if token != nil {
			if StillValid(*token) {
				http.Error(res, *token, http.StatusOK)
				return
			}
		}

		tok := must(NewToken(email, validForHours, secret, privileged)).(string)
		users[email] = &tok
		http.Error(res, tok, http.StatusOK)
		return
	})

	http.ListenAndServe(":7173", router)
}

func NewToken(email string, validForHours uint, secret string, privileged bool) (string, error) {
	claims := jwt.MapClaims{}
	now := time.Now()
	claims["authorized"] = true
	claims["userEmail"] = email
	claims["validFor"] = validForHours
	claims["privileged"] = privileged
	claims["validUntil"] = now.Add(time.Duration(validForHours) * time.Hour).Unix()
	var token = jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(secret))
}

func Validate(token string) bool {
	return true
}

func StillValid(token string) bool {
	return true
}

func must(v any, err error) any {
	if err != nil {
		panic(err)
	}
	return v
}
