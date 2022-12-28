package model

import (
	"database/sql"
	"encoding/json"

	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type User struct {
	UserID     uint           `json:"-"            gorm:"primaryKey"`
	Email      string         `json:"email"        gorm:"not null;unique;type:varchar(64);column:email"`
	ReaderData sql.NullString `json:"reader"       gorm:"default:null"`
	Privileged bool           `json:"privileged"   gorm:"not null;default:false"`
}

func (self *User) MarshalJSON() ([]byte, error) {
	type Alias User
	return json.Marshal(&struct {
		ReaderData any `json:"reader"`
		*Alias
	}{
		ReaderData: util.MarshalNullableString(self.ReaderData),
		Alias:      (*Alias)(self),
	})
}

func (self *User) UnmarshalJSON(data []byte) error {
	type Alias User
	aux := &struct {
		ReaderData any `json:"reader"`
		*Alias
	}{
		Alias: (*Alias)(self),
	}
	if err := json.Unmarshal(data, aux); err != nil {
		return err
	}
	self.ReaderData = util.UnmarshalNullableString(aux.ReaderData)
	return nil
}
