package model

import (
	"encoding/json"
	"fmt"
)

const (
	CardIdUnset         int    = -1
	CardNameUnset       string = "<invalid:cardname>"
	CardPositionUnset   int    = -1
	CardReaderDataUnset string = "<invalid:readerdata>"
)

type Card struct {
	Id         int    `json:"id,omitempty"`
	StorageId  int    `json:"storageid"`
	Name       string `json:"name"`
	Position   int    `json:"position"`
	ReaderData string `json:"readerdata"`
	*Model
}

func NewCard(model *Model, id int, storageId int, name string, position int, readerdata string) *Card {
	return &Card{
		Id:         id,
		StorageId:  storageId,
		Name:       name,
		Position:   position,
		Model:      model,
		ReaderData: readerdata,
	}
}

func CopyCard(card *Card) *Card {
	return NewCard(card.Model, card.Id, card.StorageId, card.Name, card.Position, card.ReaderData)
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
		self.Printf("Error parsing JSON: '%s'\n", string(data[:max_bytes_to_log]))
		return err
	}

	card := d.(map[string]interface{})

	var (
		idIsPresent         = false
		storageIdIsPresent  = false
		nameIsPresent       = false
		positionIsPresent   = false
		readerdataIsPresent = false
	)

	for k, v := range card {
		switch k {
		case "id":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'id' from interface{} to float64")
			}
			self.Id = int(v.(float64))
			idIsPresent = true
		case "storageid":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'storageid' from interface{} to float64")
			}
			self.StorageId = int(v.(float64))
			storageIdIsPresent = true
		case "name":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'name' from interface{} to string")
			}
			self.Name = v.(string)
			nameIsPresent = true
		case "position":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'position' from interface{} to string")
			}
			self.Position = int(v.(float64))
			positionIsPresent = true
		case "readerdata":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'readerdata' from interface{} to string")
			}
			self.ReaderData = v.(string)
			readerdataIsPresent = true
		default:
			return fmt.Errorf("Error during parsing: unknown key '%s'", k)
		}
	}

	if !idIsPresent {
		self.Id = CardIdUnset
	}
	if !storageIdIsPresent {
		self.StorageId = StorageUnitIdUnset
	}
	if !nameIsPresent {
		self.Name = CardNameUnset
	}
	if !positionIsPresent {
		self.Position = CardPositionUnset
	}
	if !readerdataIsPresent {
		self.ReaderData = CardReaderDataUnset
	}

	return nil
}

func (self *Card) MarshalJSON() ([]byte, error) /* implements json.Marshaler */ {
	type Alias Card
	return json.Marshal(&struct {
		*Alias
	}{
		Alias: (*Alias)(self),
	})
}

func (self *Card) String() string {
	return fmt.Sprintf("model.Card(model=\"\",id=%d,storageId=%d,name=%s,position=%d,readerdata=%s)", self.Id, self.StorageId, self.Name, self.Position, self.ReaderData)
}

func (self *Card) SelectAll() ([]Card, error) {
	rows, err := self.Query("SELECT id, fk_storageid, cardname, position, readerdata FROM Cards")

	if err != nil {
		return nil, err
	}

	cards := make([]Card, 0)

	for rows.Next() {
		c := Card{}

		if err := rows.Scan(&c.Id, &c.StorageId, &c.Name, &c.Position, &c.ReaderData); err != nil {
			return nil, err
		}

		cards = append(cards, c)
	}

	return cards, nil
}

func (self *Card) SelectById() error {
	row := self.QueryRow("SELECT fk_storageid, cardname, position, readerdata FROM Cards WHERE id = ?", self.Id)

	if err := row.Scan(&self.StorageId, &self.Name, &self.Position, &self.ReaderData); err != nil {
		return err
	}
	return nil
}

func (self *Card) SelectByName() error {
	row := self.QueryRow("SELECT id, fk_storageid, position, readerdata FROM Cards WHERE cardname = ?", self.Name)

	if err := row.Scan(&self.Id, &self.StorageId, &self.Position, &self.ReaderData); err != nil {
		return err
	}
	return nil
}

func (self *Card) Insert() error {
	_, err := self.Exec("INSERT INTO Cards (fk_storageid, position, cardname, readerdata) VALUES (?,?,?,?)", self.StorageId, self.Position, self.Name, self.ReaderData)
	return err
}
