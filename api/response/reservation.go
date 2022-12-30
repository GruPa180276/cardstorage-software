package response

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
)

type ReservationHandler struct {
	*controller.Controller
	ReservationLogChannel chan string
}

func (self *ReservationHandler) RegisterHandlers(router *mux.Router) {
	s := meridian.StaticReporter{ErrorHandlerFactory(self.Logger), SuccessHandlerFactory(self.Logger)}

	router.HandleFunc(paths.API_RESERVATIONS, s.Reporter(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_RESERVATIONS_FILTER_CARD, s.Reporter(self.GetByCardHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS_RESERVATIONS_FILTER_USER, s.Reporter(self.GetByUserHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS_RESERVATIONS_FILTER_USER, s.Reporter(self.CreateHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_RESERVATIONS_FILTER_ID, s.Reporter(self.DeleteHandler)).Methods(http.MethodDelete)
	router.HandleFunc(paths.API_RESERVATIONS_FILTER_ID, s.Reporter(self.UpdateHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_RESERVATIONS_WS_LOG, controller.LoggerChannelHandlerFactory(self.ReservationLogChannel, self.Logger, self.Upgrader)).Methods(http.MethodGet)
}

func (self *ReservationHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) error {
	reservations := make([]*model.Reservation, 0)

	if err := self.DB.Preload("User").Find(&reservations).Error; err != nil {
		return err
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(reservations); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *ReservationHandler) GetByCardHandler(res http.ResponseWriter, req *http.Request) error {
	name := mux.Vars(req)["name"]
	card := &model.Card{}

	result := self.DB.Preload("Reservations").Where("name = ?", name).First(card)
	if name != card.Name || result.RowsAffected == 0 || result.Error != nil {
		return fmt.Errorf("card '%s' does not exists", name)
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(card.Reservations); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *ReservationHandler) GetByUserHandler(res http.ResponseWriter, req *http.Request) error {
	email := mux.Vars(req)["email"]
	allReservations := make([]model.Reservation, 0)

	result := self.DB.Preload("User").Find(allReservations)
	if len(allReservations) == 0 || result.RowsAffected == 0 || result.Error != nil {
		return fmt.Errorf("user '%s' does not exists", email)
	}

	reservations := make([]model.Reservation, 0)
	for _, r := range reservations {
		if r.User.Email == email {
			reservations = append(reservations, r)
		}
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(reservations); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}

func (self *ReservationHandler) CreateHandler(res http.ResponseWriter, req *http.Request) error {
	email := mux.Vars(req)["email"]

	// check if user exists
	user := &model.User{}
	result := self.DB.Where("email = ?", email).First(user)
	if email != user.Email || result.RowsAffected == 0 || result.Error != nil {
		return fmt.Errorf("user '%s' does not exists", email)
	}

	// check if user has valid readerData
	if !user.ReaderData.Valid {
		return fmt.Errorf("attempting to create reservation using invalid reader from user '%s'", user.Email)
	}

	reservation := &model.Reservation{User: *user}

	type Creator struct {
		CardName      string `json:"card"`
		Since         int64  `json:"since"`
		Until         *int64 `json:"until"`
		IsReservation *bool  `json:"is-reservation"`
	}

	creator := Creator{}
	if err := json.NewDecoder(req.Body).Decode(&creator); err != nil {
		return err
	}

	// check if card exists
	card := &model.Card{}
	result = self.DB.Where("name = ?", creator.CardName).First(card)
	if creator.CardName != card.Name || result.RowsAffected == 0 || result.Error != nil {
		return fmt.Errorf("card '%s' does not exists", creator.CardName)
	}

	reservation.Since = time.Unix(creator.Since, 0)

	if creator.IsReservation != nil {
		reservation.IsReservation = *creator.IsReservation
		if *creator.IsReservation {
			if creator.Until == nil {
				return fmt.Errorf("attempting to reserve card '%s' with invalid return-time!", card.Name)
			}
			reservation.Until = time.Unix(*creator.Until, 0)
		} else {
			// if it's not a reservation check if card currently available to borrow right now
			if !card.CurrentlyAvailable {
				return fmt.Errorf("attempting to immediatly borrow currently unavailable card '%s'", card.Name)
			}

			// card is now unavailable
			card.CurrentlyAvailable = false
			card.AccessCount++
		}
	}

	if result := self.DB.Save(card); result.Error != nil || result.RowsAffected == 0 {
		err := "0 rows affected; "
		if result.Error != nil {
			err += result.Error.Error()
		}
		return fmt.Errorf("unable to update card: %s", err)
	}

	err := self.DB.
		Where("name = ?", card.Name).
		Preload("Reservations").
		Association("Reservations").
		Append(reservation)

	if err != nil {
		return err
	}

	return nil
}

func (self *ReservationHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) error {
	id, _ := strconv.Atoi(mux.Vars(req)["id"])
	result := self.DB.Where("id = ?", id).Delete(&model.Reservation{})
	if result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("reservation '%d' does not exists", id)
	}

	return meridian.Ok
}

func (self *ReservationHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) error {
	type Updater struct {
		Until      *int64 `json:"until"`
		ReturnedAt *int64 `json:"returned-at"`
	}

	id, _ := strconv.Atoi(mux.Vars(req)["id"])
	reservation := &model.Reservation{}
	result := self.DB.Where("id = ?", id).First(reservation)
	if reservation.ReservationID != uint(id) || result.RowsAffected == 0 || result.Error != nil {
		return fmt.Errorf("reservation '%d' does not exists", id)
	}

	updateReturnTime, updateReturnedAt := false, false

	u := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err
	}

	if u.Until != nil {
		updateReturnTime = true
		reservation.Until = time.Unix(*u.Until, 0)
		self.Logger.Println("update Until", reservation.Until)
	}
	if u.ReturnedAt != nil {
		updateReturnedAt = true
		reservation.ReturnedAt = time.Unix(*u.ReturnedAt, 0)
		self.Logger.Println("update ReturnedAt", reservation.ReturnedAt)
	}

	if updateReturnTime || updateReturnedAt {
		if err := self.DB.Save(reservation).Error; err != nil {
			return err
		}
	}

	buf := bytes.NewBufferString("")
	if err := json.NewEncoder(buf).Encode(reservation); err != nil {
		return err
	}

	if _, err := res.Write(buf.Bytes()); err != nil {
		self.Logger.Println(err)
		return nil
	}

	return nil
}
