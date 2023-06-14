package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
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

type Metric struct {
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}

type Storage struct {
	StorageID uint   `json:"-"        gorm:"primaryKey"`
	Name      string `json:"name"     gorm:"not null;unique;type:varchar(32)"`
	Location  string `json:"location" gorm:"not null;type:varchar(32)"`
	Address   string `json:"address"  gorm:"not null;unique;type:varchar(32)"`
	Capacity  uint   `json:"capacity" gorm:"not null;default:10"`
	Cards     []Card `json:"cards"    gorm:"many2many:storage_cards"`
	Metric
}

type User struct {
	UserID       uint           `json:"-"            gorm:"primaryKey"`
	Email        string         `json:"email"        gorm:"not null;unique;type:varchar(64)"`
	ReaderData   sql.NullString `json:"reader"       gorm:"default:null"`
	Privileged   bool           `json:"privileged"   gorm:"not null;default:false"`
	Reservations []Reservation  `json:"reservations" gorm:"many2many:user_reservations"`
	Metric
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
	CardID             uint           `json:"-"         gorm:"primaryKey"`
	Name               string         `json:"name"      gorm:"not null;unique;type:varchar(32);column:name"`
	Position           uint           `json:"position"  gorm:"not null"`
	ReaderData         sql.NullString `json:"reader"    gorm:"default:null;type:varchar(64)"`
	AccessCount        uint           `json:"accessed"  gorm:"not null;default:0"`
	CurrentlyAvailable bool           `json:"available" gorm:"not null;default:true"`
	Metric
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
		ReaderData sql.NullString `json:"reader"`
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

func main() {
	//ioutil.WriteFile("CardStorageManagement.db", []byte{}, 0666)
	db, err := gorm.Open(mysql.Open("root:root@/CardStorageManagement?parseTime=true"), new(gorm.Config))
	if err != nil {
		panic(err)
	}

	err = db.Debug().AutoMigrate(&Card{}, &Reservation{}, &Storage{}, &User{})

	if err != nil {
		panic(err)
	}

	db.Debug().Create(&Storage{Name: "S1", Location: "L1", Address: "192.168.1.10:8081", Cards: []Card{
		{Name: "C1", Position: 0},
		{Name: "C2", Position: 1},
		{Name: "C3", Position: 2},
		{Name: "C4", Position: 3},
		{Name: "C5", Position: 4},
	}})

	c1 := &Card{}
	err = db.Debug().Model(&Card{}).First(c1, "name = ?", "C1").Error
	if err != nil {
		panic(err)
	}
	fmt.Printf("%+v\n", c1)

	c2 := &Card{}
	err = db.Debug().Model(&Card{}).First(c2, "name = ?", "C2").Error
	if err != nil {
		panic(err)
	}
	fmt.Printf("%+v\n", c2)

	c3 := &Card{}
	err = db.Debug().Model(&Card{}).First(c3, "name = ?", "C3").Error
	if err != nil {
		panic(err)
	}
	fmt.Printf("%+v\n", c3)

	s1 := &Storage{}
	err = db.Debug().Model(&Storage{}).Preload("Cards").First(s1, "name = ?", "S1").Error
	if err != nil {
		panic(err)
	}
	fmt.Printf("%+v\n", s1)

	db.Debug().Create(&User{Email: "a@litec.ac.at", Reservations: []Reservation{
		{Card: *c1, Since: time.Now()},
		{Card: *c2, Since: time.Now().Add(1 * time.Hour), IsReservation: true},
		{Card: *c3, Since: time.Now().Add(2 * time.Hour), Until: time.Now().Add(2 * time.Hour).Add(30 * time.Minute), IsReservation: true},
	}})

	//for _, v := range c {
	//	db.Debug().Create(v)
	//}

	//s1 := &Storage{Name: "S1", Location: "L1", Address: "192.168.1.10:8081"}
	//s2 := &Storage{Name: "S2", Location: "L2", Address: "192.168.1.11:8081"}
	//s3 := &Storage{Name: "S3", Location: "L3", Address: "192.168.1.12:8081"}
	//s4 := &Storage{Name: "S4", Location: "L4", Address: "192.168.1.13:8081"}
	//
	//db.Debug().Create(s1)
	//db.Debug().Create(s2)
	//db.Debug().Create(s3)
	//db.Debug().Create(s4)
	//
	//u1 := &User{Email: "a@litec.ac.at"}
	//u2 := &User{Email: "b@litec.ac.at"}
	//u3 := &User{Email: "c@litec.ac.at"}
	//u4 := &User{Email: "d@litec.ac.at"}
	//
	//db.Debug().Create(u1)
	//db.Debug().Create(u2)
	//db.Debug().Create(u3)
	//db.Debug().Create(u4)
	//db.Debug().Create(&Card{Home: *s1, Name: "C1", Position: 0, CurrentlyAvailable: true, Reservations: []Reservation{{Target: *u1}}})
	//db.Debug().Create(&Card{Home: *s1, Name: "C2", Position: 0, CurrentlyAvailable: true, Reservations: []Reservation{}})
	//db.Debug().Create(&Card{Home: *s1, Name: "C3", Position: 0, CurrentlyAvailable: true, Reservations: []Reservation{}})
	//db.Debug().Create(&Card{Home: *s2, Name: "C4", Position: 0, CurrentlyAvailable: true, Reservations: []Reservation{}})

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

	//c := &Card{Reservations: []Reservation{{Target: User{ReaderData: NullableString("hello!")}}, {}}}
	//s := bytes.NewBufferString("")
	//json.NewEncoder(s).Encode(c)
	//o := bytes.NewBufferString("")
	//json.Indent(o, s.Bytes(), "", "  ")
	//fmt.Println(o.String())

}
