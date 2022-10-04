package card

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"sync"
	"time"
)

type CardId_t int

type Card struct {
	Id                CardId_t
	Fk_storageid      int
	Cardname          string
	Reservationstotal int
}

func NewCard() *Card {
	return &Card{}
}

// Correctly convert UNIX Timestamp into Go's time.Time type
func (self *Card) UnmarshalJSON(data []byte) error /* implements json.Unmarshaler */ {
	// convert byte-stream into generic adressable type
	// strongly type to make sure go's reflection knows
	var d interface{}
	err := json.Unmarshal(data, &d)

	if err != nil {
		max_bytes_to_log := 100
		if len(data) < max_bytes_to_log {
			max_bytes_to_log = len(data)
		}
		L("Error parsing JSON: '%s'\n", string(data[:max_bytes_to_log]))
		return err
	}

	card := d.(map[string]interface{})

	for k, v := range card {
		switch k {
		case "id":
			self.Id = CardId_t(v.(float64)) // in JSON, numbers are by default floating point
		case "name":
			self.Name = v.(string)
		case "storageId":
			self.StorageId = StorageId_t(v.(float64))
		case "isAvailable":
			self.IsAvailable = v.(bool)
		case "isReserved":
			self.IsReserved = v.(bool)
		case "reservedSince":
			self.ReservedSince = time.Unix(int64(v.(float64)), 0)
		case "reservedUntil":
			self.ReservedUntil = time.Unix(int64(v.(float64)), 0)
		default:
			return fmt.Errorf("Error during parsing: unknown key '%s'", k)
		}
	}

	return nil
}

// Correctly convert Go's time.Time type into UNIX Timestamp
func (self *Card) MarshalJSON() ([]byte, error) /* implements json.Marshaler */ {
	type Alias Card
	return json.Marshal(&struct {
		*Alias
		ReservedSince int64 `json:"reservedSince"`
		ReservedUntil int64 `json:"reservedUntil"`
	}{
		Alias:         (*Alias)(self),
		ReservedSince: self.ReservedSince.Unix(),
		ReservedUntil: self.ReservedUntil.Unix(),
	})
}

func (self *Card) String() string /* implements fmt.Stringer */ {
	return fmt.Sprintf("Card@%p{Id:%v, Name:%v, StorageId:%v, IsAvailable:%v, IsReserved:%v, ReservedSince:%v, ReservedUntil:%v}",
		self,
		self.Id,
		self.Name,
		self.StorageId,
		self.IsAvailable,
		self.IsReserved,
		self.ReservedSince,
		self.ReservedUntil,
	)
}

type CardDatastore struct {
	*sql.DB
	*sync.RWMutex
}

// ctor
func NewCardDatastore(db *sql.DB, guard *sync.RWMutex) *CardDatastore {
	return &CardDatastore{DB: db, RWMutex: guard}
}

type CardHandler struct {
	Datastore *CardDatastore
}

// ctor
func NewCardHandler(datastore *CardDatastore) *CardHandler {
	return &CardHandler{Datastore: datastore}
}

func (self *CardDatastore) Select(id int) (*Card, error) {
	c := Card{}

	var reservedSince, reservedUntil int64

	self.RLock()
	err := self.QueryRow(`SELECT id, cardName, storageId, isAvailable, isReserved, reservedSince, reservedUntil FROM Cards WHERE id = ?`, id).Scan(
		&c.Id,
		&c.Name,
		&c.StorageId,
		&c.IsAvailable,
		&c.IsReserved,
		&reservedSince,
		&reservedUntil,
	)
	self.RUnlock()

	c.ReservedSince = time.Unix(reservedSince, 0)
	c.ReservedUntil = time.Unix(reservedUntil, 0)

	if err != nil {
		return nil, err
	}

	return &c, nil
}

func (self *CardDatastore) SelectAll() ([]Card, error) {
	self.RLock()
	rows, err := self.Query(`SELECT id, cardName, storageId, isAvailable, isReserved, reservedSince, reservedUntil FROM Cards`)
	self.RUnlock()

	if err != nil {
		return nil, err
	}

	var cards []Card = make([]Card, 0)
	var reservedSince, reservedUntil int64

	for rows.Next() {
		c := Card{}

		err := rows.Scan(&c.Id, &c.Name, &c.StorageId, &c.IsAvailable, &c.IsReserved, &reservedSince, &reservedUntil)
		if err != nil {
			return nil, err
		}

		c.ReservedSince = time.Unix(reservedSince, 0)
		c.ReservedUntil = time.Unix(reservedUntil, 0)

		cards = append(cards, c)
	}

	return cards, nil
}

func (self *CardDatastore) Insert(card *Card) (result sql.Result, err error) {
	if card == nil {
		return nil, NullReferenceError
	}

	self.Lock()
	result, err = self.Exec(`INSERT INTO Cards (id, cardName, storageId, isAvailable, isReserved, reservedSince, reservedUntil) VALUES (?,?,?,?,?,?,?);`,
		card.Id,
		card.Name,
		card.StorageId,
		card.IsAvailable,
		card.IsReserved,
		card.ReservedSince.Unix(),
		card.ReservedUntil.Unix(),
	)
	self.Unlock()

	return
}

func (self *CardDatastore) Update(card *Card) (result sql.Result, err error) {
	if card == nil {
		return nil, NullReferenceError
	}

	self.Lock()
	result, err = self.Exec(`
	UPDATE Cards SET 
	cardName = ?, 
	storageId = ?, 
	isAvailable = ?, 
	isReserved = ?, 
	reservedSince = ?, 
	reservedUntil = ?
	WHERE id = ?; 
	`,
		card.Name,
		card.StorageId,
		card.IsAvailable,
		card.IsReserved,
		card.ReservedSince.Unix(),
		card.ReservedUntil.Unix(),
		card.Id,
	)
	self.Unlock()

	return
}

func (self *CardDatastore) Delete(id int) (result sql.Result, err error) {
	self.Lock()
	result, err = self.Exec(`DELETE FROM Cards WHERE id = ?`, id)
	self.Unlock()
	return
}
