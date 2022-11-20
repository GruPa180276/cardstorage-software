package model

import (
	"encoding/json"
	"fmt"
)

const (
	LocationIdUnset   int    = -1
	LocationNameUnset string = "<invalid:location>"
)

type Location struct {
	Id       int    `json:"id,omitempty"`
	Location string `json:"location"`
	*Model
}

func NewLocation(model *Model, id int, location string) *Location {
	return &Location{
		Id:       id,
		Location: location,
		Model:    model,
	}
}

func CopyLocation(location *Location) *Location {
	return NewLocation(location.Model, location.Id, location.Location)
}

func (self *Location) String() string {
	return fmt.Sprintf("model.Location{model=\"\",id=%d,location=%s}", self.Id, self.Location)
}

// Correctly convert UNIX Timestamp into Go's time.Time type
func (self *Location) UnmarshalJSON(data []byte) error /* implements json.Unmarshaler */ {
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

	location := d.(map[string]interface{})

	var (
		idIsPresent       = false
		locationIsPresent = false
	)

	for k, v := range location {
		switch k {
		case "id":
			self.Id = int(v.(float64))
			idIsPresent = true
		case "location":
			self.Location = v.(string)
			locationIsPresent = true
		default:
			return fmt.Errorf("Error during parsing: unknown key '%s'", k)
		}
	}

	if !idIsPresent {
		self.Id = LocationIdUnset
	}
	if !locationIsPresent {
		self.Location = LocationNameUnset
	}

	return nil
}

func (self *Location) MarshalJSON() ([]byte, error) /* implements json.Marshaler */ {
	type Alias Location
	return json.Marshal(&struct {
		*Alias
	}{
		Alias: (*Alias)(self),
	})
}

func (self *Location) SelectById() error {
	row := self.QueryRow("SELECT location FROM Locations WHERE id = ?", self.Id)

	if err := row.Scan(&self.Location); err != nil {
		return err
	}
	return nil
}

func (self *Location) SelectByName() error {
	row := self.QueryRow("SELECT id FROM Locations WHERE location = ?", self.Location)

	if err := row.Scan(&self.Id); err != nil {
		return err
	}
	return nil
}

func (self *Location) SelectAll() ([]Location, error) {
	rows, err := self.Query("SELECT id, location FROM Locations")

	if err != nil {
		return nil, err
	}

	locations := make([]Location, 0)

	for rows.Next() {
		l := Location{}

		if err := rows.Scan(&l.Id, &l.Location); err != nil {
			return nil, err
		}

		locations = append(locations, l)
	}

	return locations, nil
}

func (self *Location) Insert() error {
	_, err := self.Exec("INSERT INTO Locations (location) VALUES (?)", self.Location)

	if err != nil {
		return err
	}

	return nil
}
