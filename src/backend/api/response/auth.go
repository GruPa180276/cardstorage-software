package response

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"sync"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/auth"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"gorm.io/gorm"
)

type AuthenticationHandler struct {
	*log.Logger
	*gorm.DB
	AuthLogChannel chan string
	Tokens         *sync.Map
}

/*
func (self *AuthenticationHandler) RegisterHandlers(router *mux.Router) {
	ignored := make(chan string)
	r := meridian.StaticHttpReporter{ErrorHandler: ErrorHandlerFactory(self.Logger, ignored), SuccessHandler: SuccessHandlerFactory(self.Logger, ignored)}
	router.HandleFunc(paths.API_AUTHENTICATE_USER, r.Reporter(self.AuthHandler)).Methods("POST")
}

func (self *AuthenticationHandler) AuthHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]
	if err := self.DB.
		Where("email = ?", email).
		First(&model.User{}).Error; err != nil {
		return fmt.Errorf("attempting to authenticate non-existent user '%s': %s", email, err.Error()), nil
	}

	if existingToken, ok := self.Tokens.Load(email); ok {
		auth.Validate(req.Header.Get("Authorization"))
	}

	tok := auth.NewToken(email,
		util.Must(strconv.Atoi(os.Getenv("API_AUTH_TOKEN_VALID_FOR_HOURS"))).(uint),
		os.Getenv("API_AUTH_TOKEN_SECRET"))
	
	return nil, nil
}
*/
