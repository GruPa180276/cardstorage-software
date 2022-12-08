package model

import (
	"database/sql"
	"encoding/json"
	"fmt"
)

var (
	CardStatusIdUnset              int           = -1
	CardStatusReservationIdUnset   sql.NullInt64 = sql.NullInt64{Valid: false}
	CardStatusIsAvailableFlagUnset bool          = false
	CardStatusAccessCountUnset     int           = -1
)

type CardStatus struct {
	Id              int           `json:"id,omitempty"`
	CardId          int           `json:"card-id"`
	ReservationId   sql.NullInt64 `json:"reservation-id"`
	IsCardAvailable bool          `json:"is-card-available"`
	AccessCount     int           `json:"access-count"`
	*Model
}

func NewCardStatus(model *Model, id, cardId int, reservationId sql.NullInt64, accessCount int, isCardAvailable bool) *CardStatus {
	return &CardStatus{
		Id:              id,
		CardId:          cardId,
		ReservationId:   reservationId,
		IsCardAvailable: isCardAvailable,
		AccessCount:     accessCount,
		Model:           model,
	}
}

func ShallowCopyCardStatus(cs *CardStatus) *CardStatus {
	return NewCardStatus(cs.Model, cs.Id, cs.CardId, cs.ReservationId, cs.AccessCount, cs.IsCardAvailable)
}

// Correctly convert UNIX Timestamp into Go's time.Time type
func (self *CardStatus) UnmarshalJSON(data []byte) error /* implements json.Unmarshaler */ {
	// convert byte-stream into generic adressable type
	// strongly type to make sure go's reflection knows
	var d interface{}
	err := json.Unmarshal(data, &d)

	if err != nil {
		max_bytes_to_log := 100
		if len(data) < max_bytes_to_log {
			max_bytes_to_log = len(data)
		}
		self.Printf("Error parsing JSON: '%s'\n", string(data[:max_bytes_to_log]))
		return err
	}

	cardstatus := d.(map[string]interface{})

	var (
		idIsPresent                  = false
		cardIdIsPresent              = false
		reservationIdIsPresent       = false
		isCardAvailableFlagIsPresent = false
		reservationsTotalIsPresent   = false
	)

	for k, v := range cardstatus {
		switch k {
		case "id":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'id' from interface{} to float64")
			}
			self.Id = int(v.(float64))
			idIsPresent = true
		case "card-id":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'card-id' from interface{} to float64")
			}
			self.CardId = int(v.(float64))
			cardIdIsPresent = true
		case "reservation-id":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'reservation-id' from interface{} to float64")
			}
			self.ReservationId = sql.NullInt64{int64(v.(float64)), true}
			reservationIdIsPresent = true
		case "is-card-available":
			if _, ok := v.(bool); !ok {
				return fmt.Errorf("error: converting attribute 'is-card-available' from interface{} to bool")
			}
			self.IsCardAvailable = v.(bool)
			isCardAvailableFlagIsPresent = true
		case "access-count":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'access-count' from interface{} to float64")
			}
			self.AccessCount = int(v.(float64))
			reservationsTotalIsPresent = true
		default:
			return fmt.Errorf("Error during parsing: unknown key '%s'", k)
		}
	}

	if !idIsPresent {
		self.Id = CardStatusIdUnset
	}
	if !cardIdIsPresent {
		self.CardId = CardIdUnset
	}
	if !reservationIdIsPresent {
		self.ReservationId = CardStatusReservationIdUnset
	}
	if !isCardAvailableFlagIsPresent {
		self.IsCardAvailable = CardStatusIsAvailableFlagUnset
	}
	if !reservationsTotalIsPresent {
		self.AccessCount = CardStatusAccessCountUnset
	}

	return nil
}

func (self *CardStatus) MarshalJSON() ([]byte, error) /* implements json.Marshaler */ {
	var resid interface{} = int(self.ReservationId.Int64)
	if !self.ReservationId.Valid {
		resid = nil
	}
	return json.Marshal(&struct {
		Id              int         `json:"id,omitempty"`
		CardId          int         `json:"card-id"`
		ReservationId   interface{} `json:"reservation-id"`
		IsCardAvailable bool        `json:"is-card-available"`
		AccessCount     int         `json:"access-count"`
	}{
		Id:              self.Id,
		CardId:          self.CardId,
		ReservationId:   resid,
		IsCardAvailable: self.IsCardAvailable,
		AccessCount:     self.AccessCount,
	})
}

func (self *CardStatus) String() string {
	return fmt.Sprintf("model.CardStatus(model=\"\",id=%d,card-id=%d,reservation-id=%v,is-card-available=%v,access-count=%d)", self.Id, self.CardId, self.ReservationId.Int64, self.IsCardAvailable, self.AccessCount)
}

func (self *CardStatus) SelectAll() ([]CardStatus, error) {
	rows, err := self.Query("SELECT id, fk_cardid, fk_reservationid, iscardavailable, accesscount FROM CardsStatus")
	if err != nil {
		return nil, err
	}

	cardStatuses := make([]CardStatus, 0)

	var nullableReservationId sql.NullInt64

	for rows.Next() {
		cs := CardStatus{}

		if err := rows.Scan(&cs.Id, &cs.CardId, &nullableReservationId, &cs.IsCardAvailable, &cs.AccessCount); err != nil {
			return nil, err
		}

		cardStatuses = append(cardStatuses, cs)
	}

	self.ReservationId = nullableReservationId

	return cardStatuses, nil
}

func (self *CardStatus) SelectByCardId() error {
	row := self.QueryRow("SELECT id, fk_reservationid, iscardavailable, accesscount FROM CardsStatus WHERE fk_cardid = ?", self.CardId)
	if err := row.Scan(&self.Id, &self.ReservationId, &self.IsCardAvailable, &self.AccessCount); err != nil {
		return err
	}
	return nil
}

func (self *CardStatus) InsertDefaultStatus() error {
	self.Printf("Trying to insert #%d\n", self.CardId)
	_, err := self.Exec("INSERT INTO CardsStatus (fk_cardid) VALUES (?)", self.CardId)
	return err
}

func (self *CardStatus) UpdateByCardId() error {
	_, err := self.Exec("UPDATE CardsStatus SET iscardavailable = ?, accesscount = ? WHERE fk_cardid = ?", self.IsCardAvailable, self.AccessCount, self.CardId)
	return err
}
