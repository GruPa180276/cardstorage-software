package model

import (
	"encoding/json"
	"time"
)

type Reservation struct {
	ReservationID uint      `json:"-" gorm:"primaryKey"`
	CardID        uint      `json:"-"`
	Card          Card      `json:"card"`
	Since         time.Time `json:"since"          gorm:"not null"`
	Until         time.Time `json:"until"          gorm:"default:null"`
	ReturnedAt    time.Time `json:"returned-at"    gorm:"default:null"`
	Returned      bool      `json:"returned"       gorm:"default:false"`
	IsReservation bool      `json:"is-reservation" gorm:"default:false"`
	Metric
}

func (self *Reservation) MarshalJSON() ([]byte, error) {
	type Alias Reservation
	return json.Marshal(&struct {
		Since      int64 `json:"since"`
		Until      int64 `json:"until"`
		ReturnedAt int64 `json:"returned-at"`
		*Alias
	}{
		Since:      self.Since.Unix(),
		Until:      self.Until.Unix(),
		ReturnedAt: self.ReturnedAt.Unix(),
		Alias:      (*Alias)(self),
	})
}

func (self *Reservation) UnmarshalJSON(data []byte) error {
	type Alias Reservation
	aux := &struct {
		Since      int64 `json:"since"`
		Until      int64 `json:"until"`
		ReturnedAt int64 `json:"returned-at"`
		*Alias
	}{
		Alias: (*Alias)(self),
	}
	if err := json.Unmarshal(data, aux); err != nil {
		return err
	}
	self.Since = time.Unix(aux.Since, 0)
	self.Until = time.Unix(aux.Until, 0)
	self.ReturnedAt = time.Unix(aux.ReturnedAt, 0)
	return nil
}
