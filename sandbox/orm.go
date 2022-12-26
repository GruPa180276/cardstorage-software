package main

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"fmt"
	"time"
)

func MarshalNullableString(s sql.NullString) any {
	if !s.Valid {
		return nil
	}
	return s.String
}

func UnmarshalNullableString(v any) sql.NullString {
	if v == nil {
		return sql.NullString{}
	}
	return sql.NullString{Valid: true, String: v.(string)}
}

func NullableString(v string) sql.NullString {
	if v == "" {
		return sql.NullString{}
	}
	return sql.NullString{Valid: true, String: v}
}

type Storage struct {
	StorageId uint   `json:"id"       gorm:"primaryKey"`
	Name      string `json:"name"     gorm:"not null;unique;type:varchar(32)"`
	Location  string `json:"location" gorm:"not null;type:varchar(32)"`
	Address   string `json:"address"  gorm:"not null;unique;type:varchar(32)"`
	Capacity  uint   `json:"capacity" gorm:"not null;default:10"`
}

type User struct {
	UserId     uint           `json:"id"       gorm:"primaryKey"`
	Email      string         `json:"email"    gorm:"not null;unique;type:varchar(64)"`
	ReaderData sql.NullString `json:"reader"   gorm:"default:null;serializer:json"`
	Privileged bool           `json:"privileged" gorm:"not null;default:false"`
}

func (self *User) MarshalJSON() ([]byte, error) {
	type Alias User
	return json.Marshal(&struct {
		ReaderData any `json:"reader"`
		*Alias
	}{
		ReaderData: MarshalNullableString(self.ReaderData),
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
	self.ReaderData = UnmarshalNullableString(aux.ReaderData)
	return nil
}

type Card struct {
	Home               Storage        `json:"home"         gorm:"foreignKey:StorageId;serializer:json"`
	Name               string         `json:"name"         gorm:"not null;unique;type:varchar(32)"`
	Position           uint           `json:"position"     gorm:"not null"`
	ReaderData         sql.NullString `json:"reader"       gorm:"default:null;type:varchar(64);serializer:json"`
	AccessCount        uint           `json:"accessed"     gorm:"not null;default:0"`
	CurrentlyAvailable bool           `json:"available"    gorm:"not null;default:true"`
	Reservations       []Reservation  `json:"reservations" gorm:"foreignKey:ReservationId;serializer:json"`
}

func (self *Card) MarshalJSON() ([]byte, error) {
	type Alias Card
	return json.Marshal(&struct {
		ReaderData any `json:"reader"`
		*Alias
	}{
		ReaderData: MarshalNullableString(self.ReaderData),
		Alias:      (*Alias)(self),
	})
}

func (self *Card) UnmarshalJSON(data []byte) error {
	type Alias Card
	aux := &struct {
		*Alias
	}{
		Alias: (*Alias)(self),
	}
	if err := json.Unmarshal(data, aux); err != nil {
		return err
	}
	self.ReaderData = UnmarshalNullableString(aux.ReaderData)
	return nil
}

type Reservation struct {
	ReservationId uint      `json:"id"             gorm:"primaryKey"`
	Target        User      `json:"target"         gorm:"foreignKey:UserId;serializer:json"`
	Since         time.Time `json:"since"          gorm:"not null;serializer:json"`
	Until         time.Time `json:"until"          gorm:"default:null;serializer:json"`
	ReturnedAt    time.Time `json:"returned-at"    gorm:"default:null;serializer:json"`
	Returned      bool      `json:"returned"       gorm:"default:false"`
	IsReservation bool      `json:"is-reservation" gorm:"default:false"`
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

func main() {
	//ioutil.WriteFile("CardStorageManagement.db", []byte{}, 0666)
	//db, err := gorm.Open(mysql.Open("root:root@tcp(127.0.0.1:3306)/CardStorageManagement"), new(gorm.Config))
	//if err != nil {
	//	panic(err)
	//}
	//
	//err = db.AutoMigrate(new(Storage), new(User), new(Card), new(Reservation))
	//
	//if err != nil {
	//	panic(err)
	//}
	//
	//db.Create(&Storage{Name: "abcd1", Location: "def", Address: "xyz12:71"})
	//db.Create(&User{
	//	Email:      "abcde@litec.ac.at",
	//	ReaderData: sql.NullString{Valid: true, String: base64.URLEncoding.EncodeToString([]byte("<data_on_reader>"))}})
	//
	//
	//s := Storage{}
	//db.First(&s, "name = ?", "abcd1")
	//db.Delete(&s, "name = ?", "abcd1")

	//u := &User{ReaderData: sql.NullString{Valid: true, String: base64.URLEncoding.EncodeToString([]byte("abcdef"))}}
	//
	//s := bytes.NewBufferString("")
	//json.NewEncoder(s).Encode(u)
	//
	//fmt.Printf("%s, %+v\n", s, u)
	//
	//u2 := &User{}
	//json.NewDecoder(s).Decode(u2)
	//
	//fmt.Printf("%+v\n", u2)

	//r := &Reservation{Since: time.Now(), Until: time.Now(), ReturnedAt: time.Now()}
	//s := bytes.NewBufferString("")
	//json.NewEncoder(s).Encode(r)
	//fmt.Println(s)

	c := &Card{Reservations: []Reservation{{Target: User{ReaderData: NullableString("hello!")}}, {}}}
	s := bytes.NewBufferString("")
	json.NewEncoder(s).Encode(c)
	o := bytes.NewBufferString("")
	json.Indent(o, s.Bytes(), "", "  ")
	fmt.Println(o.String())
	
}
