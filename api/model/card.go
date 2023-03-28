package model

import (
	"database/sql"
	"encoding/json"

	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Card struct {
	CardID             uint           `json:"-"            gorm:"primaryKey;column:card_id"`
	Name               string         `json:"name"         gorm:"not null;unique;type:varchar(32);column:name"`
	Position           uint           `json:"position"     gorm:"not null"`
	ReaderData         sql.NullString `json:"reader"       gorm:"default:null;type:varchar(64);column:reader_data"`
	AccessCount        uint           `json:"accessed"     gorm:"not null;default:0"`
	CurrentlyAvailable bool           `json:"available"    gorm:"not null;default:true"`
	StorageID          uint           `json:"-"            gorm:"foreignKey:StorageID"`
	Storage            Storage        `json:"-"`
	Reservations       []Reservation  `json:"reservations"`
}

func (self *Card) MarshalJSON() ([]byte, error) {
	type Alias Card
	return json.Marshal(&struct {
		ReaderData string `json:"reader"`
		*Alias
	}{
		ReaderData: util.MarshalNullableString(self.ReaderData),
		Alias:      (*Alias)(self),
	})
}

func (self *Card) UnmarshalJSON(data []byte) error {
	type Alias Card
	aux := &struct {
		ReaderData sql.NullString `json:"reader"`
		*Alias
	}{
		Alias: (*Alias)(self),
	}
	if err := json.Unmarshal(data, aux); err != nil {
		return err
	}
	self.ReaderData = util.UnmarshalNullableString(aux.ReaderData.String)
	return nil
}
