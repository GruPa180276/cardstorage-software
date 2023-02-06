package response

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"

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
}

func (self *AuthenticationHandler) RegisterHandlers(router *mux.Router, _ string) {
	ignored := make(chan string)
	r := meridian.StaticHttpReporter{ErrorHandler: ErrorHandlerFactory(self.Logger, ignored), SuccessHandler: SuccessHandlerFactory(self.Logger)}
	router.HandleFunc(paths.API_AUTHENTICATE_USER, r.Reporter(self.AuthHandler)).Methods(http.MethodGet)
}

func (self *AuthenticationHandler) AuthHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]
	user := &model.User{}

	if result := self.DB.Where("email = ?", email).First(&user); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("attempting to authenticate non-existent user '%s': %s", email, result.Error.Error()), nil
	}

	tok, err := auth.NewToken(os.Getenv("API_AUTH_TOKEN_SECRET"), os.Getenv("API_AUTH_TOKEN_ISSUER"),
		email, uint(util.Must(strconv.Atoi(os.Getenv("API_AUTH_TOKEN_VALID_FOR_HOURS"))).(int)), user.Privileged)

	if err != nil {
		return err, nil
	}

	return nil, meridian.Okay(tok).Jsonify(false)
}
