package response

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"gorm.io/gorm/clause"
)

type ReservationHandler struct {
	*controller.Controller
	*sync.Cond
	ReservationLogChannel chan string
}

func (self *ReservationHandler) RegisterHandlers(router *mux.Router) {
	s := meridian.StaticHttpReporter{ErrorHandlerFactory(self.Logger, self.ReservationLogChannel), SuccessHandlerFactory(self.Logger)}

	router.HandleFunc(paths.API_RESERVATIONS, s.Reporter(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_RESERVATIONS_DETAILED, s.Reporter(self.GetDetailedReservations)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_RESERVATIONS_FILTER_CARD, s.Reporter(self.GetByCardHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS_RESERVATIONS_FILTER_USER, s.Reporter(self.GetByUserHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_USERS_RESERVATIONS_FILTER_USER, s.Reporter(self.CreateHandler)).Methods(http.MethodPost)
	router.HandleFunc(paths.API_RESERVATIONS_FILTER_ID, s.Reporter(self.DeleteHandler)).Methods(http.MethodDelete)
	router.HandleFunc(paths.API_RESERVATIONS_FILTER_ID, s.Reporter(self.UpdateHandler)).Methods(http.MethodPut)
	w := &controller.DataWrapper{self.ReservationLogChannel, self.Cond, self.Logger, self.Upgrader}
	router.HandleFunc(paths.API_RESERVATIONS_WS_LOG, w.LoggerChannelHandlerFactory()).Methods(http.MethodGet)
}

func (self *ReservationHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	reservations := make([]*model.Reservation, 0)

	if err := self.DB.Preload("User").Find(&reservations).Error; err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&reservations)
}

func (self *ReservationHandler) GetByCardHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]
	card := model.Card{}

	if result := self.DB.Preload("Reservations").Preload("Reservations.User").Where("name = ?", name).First(&card); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("card '%s' does not exists", name), nil
	}

	return nil, meridian.OkayMustJson(&card.Reservations)
}

func (self *ReservationHandler) GetByUserHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]
	reservations := make([]*model.Reservation, 0)

	user := model.User{}
	if err := self.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return err, nil
	}

	if err := self.DB.
		Model(&model.Reservation{}).
		Preload("User").
		Where("user_id = ?", user.UserID).
		Find(&reservations).Error; err != nil {
		return err, nil
	}

	// if result := self.DB.Preload("User").Find(&allReservations); result.Error != nil {
	// 		return result.Error, nil
	// }
	//
	// reservations := make([]*model.Reservation, 0)
	// for _, r := range reservations {
	// 		if r.User.Email == email {
	// 			 reservations = append(reservations, r)
	// 		}
	// }

	return nil, meridian.OkayMustJson(&reservations)
}

func (self *ReservationHandler) GetDetailedReservations(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	storages := make([]*model.Storage, 0)
	if err := self.DB.
		Preload("Cards").
		Preload("Cards.Reservations").
		Preload("Cards.Reservations.User").
		Find(&storages).Error; err != nil {
		return err, nil
	}

	type detailedReservation struct {
		Reservation *model.Reservation `json:"reservation"`
		CardName    string             `json:"cardName"`
		StorageName string             `json:"storageName"`
	}

	dreservations := make([]detailedReservation, 0)

	for _, s := range storages {
		for _, c := range s.Cards {
			for _, r := range c.Reservations {
				dreservations = append(dreservations, detailedReservation{
					StorageName: s.Name,
					CardName:    c.Name,
					Reservation: &r,
				})
			}
		}
	}

	self.Println("[DEBUG]: ", dreservations)

	return nil, meridian.OkayMustJson(dreservations)
}

func (self *ReservationHandler) CreateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	email := mux.Vars(req)["email"]

	// check if user exists
	user := &model.User{}
	if result := self.DB.Where("email = ?", email).First(user); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("user '%s' does not exists", email), nil
	}

	// check if user has valid readerData
	if !user.ReaderData.Valid {
		return fmt.Errorf("attempting to create reservation using invalid reader from user '%s'", user.Email), nil
	}

	reservation := &model.Reservation{User: *user, UserID: user.UserID, IsReservation: false, Until: time.Time{}}

	type Creator struct {
		CardName      string `json:"card"`
		Since         int64  `json:"since"`
		Until         *int64 `json:"until"`
		IsReservation *bool  `json:"is-reservation"`
	}

	creator := Creator{}
	if err := json.NewDecoder(req.Body).Decode(&creator); err != nil {
		self.Println("DECODING ERROR")
		return err, nil
	}

	// check if card exists
	card := &model.Card{}
	if result := self.DB.Where("name = ?", creator.CardName).First(card); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("card '%s' does not exists", creator.CardName), nil
	}

	reservation.Since = time.Unix(creator.Since, 0)

	if creator.IsReservation != nil {
		reservation.IsReservation = *creator.IsReservation
		if *creator.IsReservation {
			if creator.Until == nil {
				return fmt.Errorf("attempting to reserve card '%s' with invalid return time", card.Name), nil
			}
			reservation.Until = time.Unix(*creator.Until, 0)
		} else {
			// if it's not a reservation check if card currently available to borrow right now
			if !card.CurrentlyAvailable {
				return fmt.Errorf("attempting to immediatly borrow currently unavailable card '%s'", card.Name), nil
			}

			// card is now unavailable
			card.CurrentlyAvailable = false
			card.AccessCount++
		}
	}

	if result := self.DB.Save(card); result.Error != nil {
		return fmt.Errorf("unable to update card: %s", result.Error), nil
	}

	if err := self.DB.
		Model(card).
		Preload(clause.Associations).
		Preload("Reservations.User").
		Association("Reservations").
		Append(reservation); err != nil {
		self.Printf("DB ERROR! %+v, %+v\n", card, reservation)
		return err, nil
	}

	return nil, meridian.Okay()
}

func (self *ReservationHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	id, _ := strconv.Atoi(mux.Vars(req)["id"])
	if result := self.DB.Where("id = ?", id).Delete(&model.Reservation{}); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("reservation '%d' does not exist", id), nil
	}

	return nil, meridian.Okay()
}

func (self *ReservationHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type Updater struct {
		Until      *int64 `json:"until"`
		ReturnedAt *int64 `json:"returned-at"`
	}

	id := util.Must(strconv.Atoi(mux.Vars(req)["id"])).(int)
	reservation := model.Reservation{}
	if result := self.DB.Where("id = ?", id).First(&reservation); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("reservation '%d' does not exists", id), nil
	}

	updateReturnTime, updateReturnedAt := false, false

	u := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err, nil
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
		if err := self.DB.Save(&reservation).Error; err != nil {
			return err, nil
		}
	}

	return nil, meridian.OkayMustJson(&reservation)
}
