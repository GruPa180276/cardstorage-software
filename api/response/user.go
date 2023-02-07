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

// RegisterHandlers serves all user-related endpoints
func (self *UserHandler) RegisterHandlers(router *mux.Router, secret string) {
	r := meridian.StaticHttpReporter{ErrorHandler: ErrorHandlerFactory(self.Logger, self.UserLogChannel), SuccessHandler: SuccessHandlerFactory(self.Logger)}

	authUser := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateUser(secret)}
	authAdmin := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateAdministrator(secret)}
	authAnonymous := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateAnonymous(secret)}

	router.HandleFunc(paths.API_USERS, authUser.ReporterValidator(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, authAnonymous.ReporterValidator(self.GetByEmailHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS, authAnonymous.ReporterValidator(self.CreateHandler)).Methods(http.MethodPost).HeadersRegexp("Content-Type", "(text|application)/json")
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, authUser.ReporterValidator(self.UpdateHandler)).Methods(http.MethodPut).HeadersRegexp("Content-Type", "(text|application)/json")
	router.HandleFunc(paths.API_USERS_FILTER_EMAIL, authAdmin.ReporterValidator(self.DeleteHandler)).Methods(http.MethodDelete)

	w := &controller.DataWrapper{self.UserLogChannel, self.Cond, self.Logger, self.Upgrader}
	router.HandleFunc(paths.API_USERS_WS_LOG, authAnonymous.Validator(w.LoggerChannelHandlerFactory())).Methods(http.MethodGet)
}

// GetAllHandler
// @Summary Get all users
// @Description Returns all available users in JSON array format
// @Tags Users, GET
// @Produce json
// @Success 200 {array} model.User
// @Failure 400 {object} util.ErrorStatusWrapperResponse "error while querying data"
// @Failure 401 {object} util.ErrorStatusWrapperResponse "permission denied"
// @Router /api/v1/users [GET]
// @Security BearerAuth
// @Param Authorization header string true "Bearer <token> (minimum security clearance required: User)" default(Bearer <token>)
func (self *UserHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	users := make([]model.User, 0)

	if result := self.DB.Find(&users); result.Error != nil {
		return result.Error, nil
	}

	return nil, meridian.OkayMustJson(&users)
}

// GetByEmailHandler
// @Summary Filter users by email attribute
// @Description Returns a single user whose email attribute matches the given path parameter, else empty object.
// @Tags Users, GET, Email
// @Produce json
// @Success 200 {object} model.User
// @Failure 400 {object} util.ErrorStatusWrapperResponse "error while querying data"
// @Failure 401 {object} util.ErrorStatusWrapperResponse "permission denied"
// @Param email path string true "has to match: `[a-zA-Z0-9@._]{10,64}}`"
// @Router /api/v1/users/email/{email} [GET]
// @Security BearerAuth
// @Param Authorization header string true "Bearer <token> (minimum security clearance required: Anonymous)" default(Bearer <token>)
func (self *UserHandler) GetByEmailHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]
	user := model.User{}
	if err := self.DB.Where("email = ?", email).Find(&user).Error; err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&user)
}

// CreateHandler
// @Summary Create a new user
// @Description Stores a new user with the given parameters and dispatches sign-up-event to the given storage controller to scan the new users card. Optional Fields: 'privileged' (default: false), 'reader' (default: null)"
// @Tags Users, POST
// @Produce json
// @Success 200 {object} response.CreateHandler.UserEmailResponse
// @Failure 400 {object} util.ErrorStatusWrapperResponse "error while querying data"
// @Failure 401 {object} util.ErrorStatusWrapperResponse "permission denied"
// @Param Creator body response.CreateHandler.UserCreator true "creator" validate(required)
// @Router /api/v1/users [POST]
// @Security BearerAuth
// @Param Authorization header string true "Bearer <token> (minimum security clearance required: Anonymous)" default(Bearer <token>)
func (self *UserHandler) CreateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type UserCreator struct {
		Email       string  `json:"email"`
		StorageName string  `json:"storage"`
		Privileged  *bool   `json:"privileged"`
		ReaderData  *string `json:"reader"`
	}

	type UserEmailResponse struct {
		Email string `json:"email"`
	}

	c := &UserCreator{}

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

	return nil, meridian.OkayMustJson(UserEmailResponse{Email: user.Email})
}

// UpdateHandler
// @Summary Update a user
// @Description Updates an existing user whose email attribute matches the given path parameter. Request may only contain the attributes which are to be updated, otherwise unintended fields may be updated as well.
// @Tags Users, PUT
// @Produce json
// @Success 200 {object} model.User
// @Failure 400 {object} util.ErrorStatusWrapperResponse "error while querying data"
// @Failure 401 {object} util.ErrorStatusWrapperResponse "permission denied"
// @Param Creator body response.UpdateHandler.UserUpdater true "optionals: privileged (default: false), reader (default: null)" validate(required)
// @Param email path string true "has to match: `[a-zA-Z0-9@._]{10,64}}`"
// @Router /api/v1/users/email/{email} [PUT]
// @Security BearerAuth
// @Param Authorization header string true "Bearer <token> (minimum security clearance required: User)" default(Bearer <token>)
func (self *UserHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type UserUpdater struct {
		Email      *string `json:"email"`
		ReaderData *string `json:"reader"`
		Privileged *bool   `json:"privileged"`
	}

	user := model.User{}
	vars := mux.Vars(req)
	if result := self.DB.Where("email = ?", vars["email"]).First(&user); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("user '%s' does not exist", vars["email"]), nil
	}

	u := UserUpdater{}
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

// DeleteHandler
// @Summary Delete a user
// @Description Deletes an existing user whose email attribute matches the given path parameter. User will not be deleted if they are referenced in any existing Reservations.
// @Tags Users, DELETE
// @Produce json
// @Success 200 {string} string
// @Failure 400 {object} util.ErrorStatusWrapperResponse "error while querying data"
// @Failure 401 {object} util.ErrorStatusWrapperResponse "permission denied"
// @Param email path string true "has to match: `[a-zA-Z0-9@._]{10,64}}`"
// @Router /api/v1/users/email/{email} [DELETE]
// @Security BearerAuth
// @Param Authorization header string true "Bearer <token> (minimum security clearance required: Administrator)" default(Bearer <token>)
func (self *UserHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]

	if result := self.DB.Where("email = ?", email).Delete(&model.User{}); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("unable to delete user '%s'", email), nil
	}

	return nil, meridian.Okay()
}
