package response

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"sync"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/auth"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type UserHandler struct {
	*controller.Controller
	*sync.Cond
	UserLogChannel chan string
}

func (self *UserHandler) RegisterHandlers(router *mux.Router, secret string) {
	r := meridian.StaticHttpReporter{ErrorHandler: ErrorHandlerFactory(self.Logger, self.UserLogChannel), SuccessHandler: SuccessHandlerFactory(self.Logger)}

	authUser := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateUser(secret)}
	authAdmin := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateAdministrator(secret)}
	authAnonymous := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateAnonymous(secret)}

	router.HandleFunc(paths.API_USERS, authUser.ReporterValidator(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, authUser.ReporterValidator(self.GetByEmailHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS, authAnonymous.ReporterValidator(self.CreateHandler)).Methods(http.MethodPost).HeadersRegexp("Content-Type", "(text|application)/json")
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, authUser.ReporterValidator(self.UpdateHandler)).Methods(http.MethodPut).HeadersRegexp("Content-Type", "(text|application)/json")
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, authAdmin.ReporterValidator(self.DeleteHandler)).Methods(http.MethodDelete)

	w := &controller.DataWrapper{self.UserLogChannel, self.Cond, self.Logger, self.Upgrader}
	router.HandleFunc(paths.API_USERS_WS_LOG, authAnonymous.Validator(w.LoggerChannelHandlerFactory())).Methods(http.MethodGet)
}

func (self *UserHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	users := make([]model.User, 0)

	if result := self.DB.Find(&users); result.Error != nil {
		return result.Error, nil
	}

	return nil, meridian.OkayMustJson(&users)
}

func (self *UserHandler) GetByEmailHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]
	user := model.User{}
	if err := self.DB.Where("email = ?", email).Find(&user).Error; err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&user)
}

func (self *UserHandler) CreateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type Creator struct {
		Email       string  `json:"email"`
		StorageName string  `json:"storage"`
		Privileged  *bool   `json:"privileged"`
		ReaderData  *string `json:"reader"`
	}
	c := &Creator{}

	if err := json.NewDecoder(req.Body).Decode(&c); err != nil {
		return err, nil
	}
	if !paths.UserEmailMatcher.MatchString(c.Email) {
		return fmt.Errorf("attribute 'email' does not match required pattern: %s", c.Email), nil
	}

	storage := model.Storage{}
	if err := self.DB.Where("name = ?", c.StorageName).First(&storage).Error; err != nil {
		return err, nil
	}

	user := model.User{Email: c.Email}
	if c.Privileged != nil {
		user.Privileged = *c.Privileged
	}
	if c.ReaderData != nil {
		user.ReaderData = util.NullableString(*c.ReaderData)
	}

	if err := self.DB.Create(&user).Error; err != nil {
		if strings.Contains(err.Error(), "Error 1452") {
			return fmt.Errorf("possible duplicate user '%s'", user.Email), nil
		}
		return err, nil
	}

	intercepted, err := self.Controller.SignUpUserDispatcher(storage.Name, storage.Location, user.Email)
	if err != nil {
		return err, nil
	}

	intercepted.ClientId = util.AssembleBaseStorageTopic(storage.Name, storage.Location)
	self.UserLogChannel <- string(util.Must(json.Marshal(intercepted)).([]byte))

	return nil, meridian.OkayMustJson(&struct {
		Email string `json:"email"`
	}{
		Email: user.Email,
	})
}

func (self *UserHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type Updater struct {
		Email      *string `json:"email"`
		ReaderData *string `json:"reader"`
		Privileged *bool   `json:"privileged"`
	}
	user := model.User{}
	vars := mux.Vars(req)
	if result := self.DB.Where("email = ?", vars["email"]).First(&user); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("user '%s' does not exist", vars["email"]), nil
	}

	u := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err, nil
	}

	updateEmail, updateReader, updatePriv := false, false, false

	if u.Email != nil {
		updateEmail = true
		user.Email = *u.Email
		self.Logger.Println("update Email", user.Email)
	}
	if u.ReaderData != nil {
		updateReader = true
		user.ReaderData = util.NullableString(*u.ReaderData)
		self.Logger.Println("update ReaderData", user.ReaderData)
	}
	if u.Privileged != nil {
		updatePriv = true
		user.Privileged = *u.Privileged
		self.Logger.Println("update Privileged", user.Privileged)
	}

	if updateEmail || updateReader || updatePriv {
		if err := self.DB.Save(&user).Error; err != nil {
			return err, nil
		}
	}

	return nil, meridian.OkayMustJson(&user)
}

func (self *UserHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]

	if result := self.DB.Where("email = ?", email).Delete(&model.User{}); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("unable to delete user '%s'", email), nil
	}

	return nil, meridian.Okay()
}
