package model

import (
	"database/sql"
	"encoding/json"
	"fmt"
)

var (
	CardStatusIdUnset                int           = -1
	CardStatusReservationIdUnset     sql.NullInt64 = sql.NullInt64{Valid: false}
	CardStatusIsAvailableFlagUnset   bool          = false
	CardStatusReservationsTotalUnset int           = -1
)

type CardStatus struct {
	Id                int           `json:"id,omitempty"`
	CardId            int           `json:"cardid"`
	ReservationId     sql.NullInt64 `json:"reservationid"`
	IsCardAvailable   bool          `json:"isCardAvailable"`
	ReservationsTotal int           `json:"reservationsTotal"`
	*Model
}

func NewCardStatus(model *Model, id, cardId int, reservationId sql.NullInt64, reservationsTotal int, isCardAvailable bool) *CardStatus {
	return &CardStatus{
		Id:                id,
		CardId:            cardId,
		ReservationId:     reservationId,
		IsCardAvailable:   isCardAvailable,
		ReservationsTotal: reservationsTotal,
		Model:             model,
	}
}

func ShallowCopyCardStatus(cs *CardStatus) *CardStatus {
	return NewCardStatus(cs.Model, cs.Id, cs.CardId, cs.ReservationId, cs.ReservationsTotal, cs.IsCardAvailable)
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
		case "cardid":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'cardid' from interface{} to float64")
			}
			self.CardId = int(v.(float64))
			cardIdIsPresent = true
		case "reservationid":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'reservationid' from interface{} to float64")
			}
			self.ReservationId = sql.NullInt64{int64(v.(float64)), true}
			reservationIdIsPresent = true
		case "isCardAvailable":
			if _, ok := v.(bool); !ok {
				return fmt.Errorf("error: converting attribute 'isCardAvailable' from interface{} to bool")
			}
			self.IsCardAvailable = v.(bool)
			isCardAvailableFlagIsPresent = true
		case "reservationsTotal":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'reservationsTotal' from interface{} to float64")
			}
			self.ReservationsTotal = int(v.(float64))
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
		self.ReservationsTotal = CardStatusReservationsTotalUnset
	}

	return nil
}

func (self *CardStatus) MarshalJSON() ([]byte, error) /* implements json.Marshaler */ {
	var resid interface{} = int(self.ReservationId.Int64)
	if !self.ReservationId.Valid {
		resid = nil
	}
	return json.Marshal(&struct {
		Id                int         `json:"id,omitempty"`
		CardId            int         `json:"cardid"`
		ReservationId     interface{} `json:"reservationid"`
		IsCardAvailable   bool        `json:"isCardAvailable"`
		ReservationsTotal int         `json:"reservationsTotal"`
	}{
		Id:                self.Id,
		CardId:            self.CardId,
		ReservationId:     resid,
		IsCardAvailable:   self.IsCardAvailable,
		ReservationsTotal: self.ReservationsTotal,
	})
}

func (self *CardStatus) String() string {
	return fmt.Sprintf("model.CardStatus(model=\"\",id=%d,cardid=%d,reservationid=%v,isCardAvailable=%v,reservationsTotal=%d)", self.Id, self.CardId, self.ReservationId.Int64, self.IsCardAvailable, self.ReservationsTotal)
}

func (self *CardStatus) SelectAll() ([]CardStatus, error) {
	rows, err := self.Query("SELECT id, fk_cardid, fk_reservationid, iscardavailable, reservationstotal FROM CardsStatus")
	if err != nil {
		return nil, err
	}

	cardStatuses := make([]CardStatus, 0)

	var nullableReservationId sql.NullInt64

	for rows.Next() {
		cs := CardStatus{}

		if err := rows.Scan(&cs.Id, &cs.CardId, &nullableReservationId, &cs.IsCardAvailable, &cs.ReservationsTotal); err != nil {
			return nil, err
		}

		cardStatuses = append(cardStatuses, cs)
	}

	self.ReservationId = nullableReservationId

	return cardStatuses, nil
}

func (self *CardStatus) SelectByCardId() error {
	row := self.QueryRow("SELECT id, fk_reservationid, iscardavailable, reservationstotal FROM CardsStatus WHERE fk_cardid = ?", self.CardId)
	if err := row.Scan(&self.Id, &self.ReservationId, &self.IsCardAvailable, &self.ReservationsTotal); err != nil {
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
	_, err := self.Exec("UPDATE CardsStatus SET iscardavailable = ?, reservationstotal = ? WHERE fk_cardid = ?", self.IsCardAvailable, self.ReservationsTotal, self.CardId)
	return err
}
