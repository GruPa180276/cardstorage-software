package response

import (
	"database/sql"
	"encoding/json"
	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
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
		return
	}

	if user.Email == model.UserEmailUnset || user.ReaderData == model.UserReaderDataUnset {
		return
	}

	userCopy := model.ShallowCopyUser(&user)
	err := userCopy.SelectByEmail()

	if err != nil && err != sql.ErrNoRows {
		self.Println(err)
		return
	}

	// insert only if there is no user with the same email yet
	if err == sql.ErrNoRows {
		if err := user.Insert(); err != nil {
			self.Println(err)
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
		return
	}

	if err := json.NewEncoder(res).Encode(users); err != nil {
		self.Println(err)
		return
	}
}

func (self *User) GetUserByIdHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["id"])

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}

	user.Id = id
	err = user.SelectById()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(user); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}

func (self *User) GetUserByEmailHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["email"])

	user.Email = vars["email"]
	err := user.SelectByEmail()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(user); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}

func (self *User) GetUserByReaderDataHandler(res http.ResponseWriter, req *http.Request) {
	user := model.User{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	vars := mux.Vars(req)
	self.Println(vars["reader"])

	user.ReaderData = vars["reader"]
	err := user.SelectByReaderData()

	if err != nil {
		if err == sql.ErrNoRows {
			Err(&res, http.StatusNotFound, err)
		} else {
			Err(&res, http.StatusBadRequest, err)
		}
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(user); err != nil {
		Err(&res, http.StatusBadRequest, err)
		self.Println(err)
		return
	}
}
