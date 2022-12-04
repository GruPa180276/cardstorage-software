package response

import (
	"database/sql"
	"encoding/json"
	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"log"
	"net/http"
	"strconv"
)

type User struct {
	*sql.DB
	*log.Logger
}

func (self *User) SignUpHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(&user); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		return
	}

	if user.Email == model.UserEmailUnset ||
		user.ReaderData == model.UserReaderDataUnset {
		strerr := "error: at least one condition for adding new user not met"
		self.Println(strerr)
		util.HttpBasicJsonError(res, http.StatusBadRequest, strerr)
		return
	}

	userCopy := model.ShallowCopyUser(&user)
	err := userCopy.SelectByEmail()

	if err != nil && err != sql.ErrNoRows {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}

	// insert only if there is no user with the same email yet
	if err == sql.ErrNoRows {
		if err := user.Insert(); err != nil {
			self.Println(err)
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
			return
		}
		self.Println("successfully inserted " + (&user).String())
	}
}

func (self *User) GetAllUsersHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	users, err := user.SelectAll()
	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(users); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *User) GetUserByIdHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["id"])
	self.Printf("trying to get user '%s' by id", vars["id"])

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusBadRequest, err.Error())
		return
	}

	user.Id = id
	err = user.SelectById()

	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(user); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *User) GetUserByEmailHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Printf("trying to get user '%s' by email", vars["email"])

	user.Email = vars["email"]
	err := user.SelectByEmail()

	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(user); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}

func (self *User) GetUserByReaderDataHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Printf("trying to get user '%s' by reader", vars["reader"])

	user.ReaderData = vars["reader"]
	err := user.SelectByReaderData()

	if err != nil {
		self.Println(err)
		if err == sql.ErrNoRows {
			util.HttpBasicJsonError(res, http.StatusNotFound, err.Error())
		} else {
			util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		}
		return
	}

	if err := json.NewEncoder(res).Encode(user); err != nil {
		self.Println(err)
		util.HttpBasicJsonError(res, http.StatusInternalServerError, err.Error())
		return
	}
}
