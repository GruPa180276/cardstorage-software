package model

import (
	"encoding/json"
	"time"
)

type Reservation struct {
	ReservationID uint      `json:"-" gorm:"primaryKey"`
	UserID        uint      `gorm:"constraint:OnDelete:CASCADE;"`
	User          User      `json:"user"           gorm:"constraint:OnDelete:CASCADE"`
	Since         time.Time `json:"since"          gorm:"not null"`
	Until         time.Time `json:"until"          gorm:"default:null"`
	ReturnedAt    time.Time `json:"returned-at"    gorm:"default:null"`
	IsReservation bool      `json:"is-reservation" gorm:"default:false"`
	Active        bool      `json:"active"         gorm:"default:false"`
	//DeletedAt     gorm.DeletedAt `json:"-"              gorm:"index"`
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
