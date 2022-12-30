package response

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type UserHandler struct {
	*controller.Controller
	UserLogChannel chan string
}

func (self *UserHandler) RegisterHandlers(router *mux.Router) {
	s := meridian.StaticReporter{ErrorHandler: ErrorHandlerFactory(self.Logger), SuccessHandler: SuccessHandlerFactory(self.Logger)}
	router.HandleFunc(paths.API_USERS, s.Reporter(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, s.Reporter(self.GetByEmailHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS, s.Reporter(self.CreateHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, s.Reporter(self.UpdateHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, s.Reporter(self.DeleteHandler)).Methods(http.MethodDelete)
	router.HandleFunc(paths.API_USERS_WS_LOG, controller.LoggerChannelHandlerFactory(self.UserLogChannel, self.Logger, self.Upgrader)).Methods(http.MethodGet)
}

func (self *UserHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) error {
	users := make([]*model.User, 0)

	if err := self.DB.Find(&users).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(users); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *UserHandler) GetByEmailHandler(res http.ResponseWriter, req *http.Request) error {
	email := mux.Vars(req)["email"]
	user := &model.User{}
	if err := self.DB.Where("email = ?", email).Find(user).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(user); err != nil {
		return err
	}

	res.WriteHeader(http.StatusOK)
	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *UserHandler) CreateHandler(res http.ResponseWriter, req *http.Request) error {
	type Creator struct {
		Email       string  `json:"email"`
		StorageName string  `json:"storage"`
		Privileged  *bool   `json:"privileged"`
		ReaderData  *string `json:"reader"`
	}
	c := &Creator{}

	if err := json.NewDecoder(req.Body).Decode(&c); err != nil {
		return err
	}
	if !paths.UserEmailMatcher.MatchString(c.Email) {
		return fmt.Errorf("attribute 'email' does not match required pattern: %s", c.Email)
	}

	s := &model.Storage{}
	if err := self.DB.Where("name = ?", s.Name).First(s).Error; err != nil {
		return err
	}

	u := &model.User{Email: c.Email}
	if c.Privileged != nil {
		u.Privileged = *c.Privileged
	}
	if c.ReaderData != nil {
		u.ReaderData = util.NullableString(*c.ReaderData)
	}

	if err := self.DB.Create(u).Error; err != nil {
		if strings.Contains(err.Error(), "Error 1452") {
			return fmt.Errorf("possible duplicate user '%s'", u.Email)
		}
		return err
	}

	if err := self.Controller.SignUpUserInvoker(s.Name, s.Location, u.Email); err != nil {
		return err
	}

	if err := util.HttpBasicJsonResponse(res, http.StatusOK, &struct {
		Email string `json:"email"`
	}{
		Email: u.Email,
	}); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *UserHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) error {
	type Updater struct {
		Email      *string `json:"email"`
		ReaderData *string `json:"reader"`
		Privilege  *bool   `json:"privilege"`
	}
	u := &model.User{}
	vars := mux.Vars(req)
	result := self.DB.Where("email = ?", vars["email"]).Find(u)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("user '%s' does not exist", vars["email"])
	}

	up := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err
	}

	updateEmail, updateReader, updatePriv := false, false, false

	if up.Email != nil {
		updateEmail = true
		u.Email = *up.Email
		self.Logger.Println("update Email", u.Email)
	}
	if up.ReaderData != nil {
		updateReader = true
		u.ReaderData = util.NullableString(*up.ReaderData)
		self.Logger.Println("update ReaderData", u.ReaderData)
	}
	if up.Privilege != nil {
		updatePriv = true
		u.Privileged = *up.Privilege
		self.Logger.Println("update Privileged", u.Privileged)
	}

	if updateEmail || updateReader || updatePriv {
		if err := self.DB.Save(u).Error; err != nil {
			return err
		}
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(u); err != nil {
		return err
	}

	res.WriteHeader(http.StatusOK)
	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *UserHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) error {
	email := mux.Vars(req)["email"]

	result := self.DB.Where("email = ?", email).Delete(&model.User{})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("user '%s' does not exist", email)
	}

	return meridian.Ok
}
