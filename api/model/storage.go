package model

import (
	"encoding/json"
	"fmt"
)

const (
	StorageUnitIdUnset       int    = -1
	StorageUnitNameUnset     string = "<invalid:name>"
	StorageUnitIpAddrUnset   string = "<invalid:ipAddr>"
	StorageUnitCapacityUnset int    = -1
)

type StorageUnit struct {
	Id        int    `json:"id,omitempty"`
	Location  string `json:"location"`
	Name      string `json:"name"`
	IpAddress string `json:"ip-address"`
	Capacity  int    `json:"capacity"`
	*Model
}

func NewStorage(model *Model, id int, location string, name string, ipaddress string, capacity int) *StorageUnit {
	return &StorageUnit{
		Id:        id,
		Location:  location,
		Name:      name,
		IpAddress: ipaddress,
		Capacity:  capacity,
		Model:     model,
	}
}

func ShallowCopyStorageUnit(storage *StorageUnit) *StorageUnit {
	return NewStorage(storage.Model, storage.Id, storage.Location, storage.Name, storage.IpAddress, storage.Capacity)
}

// Correctly convert UNIX Timestamp into Go's time.Time type
func (self *StorageUnit) UnmarshalJSON(data []byte) error /* implements json.Unmarshaler */ {
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

	storage := d.(map[string]interface{})

	var (
		idIsPresent         = false
		locationIdIsPresent = false
		nameIsPresent       = false
		ipAddrIsPresent     = false
		capacityIsPresent   = false
	)

	for k, v := range storage {
		switch k {
		case "id":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'id' from interface{} to float64")
			}
			self.Id = int(v.(float64))
			idIsPresent = true
		case "location":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'location-id' from interface{} to string")
			}
			self.Location = v.(string)
			locationIdIsPresent = true
		case "name":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'name' from interface{} to string")
			}
			self.Name = v.(string)
			nameIsPresent = true
		case "ip-address":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'ip-address' from interface{} to string")
			}
			self.IpAddress = v.(string)
			ipAddrIsPresent = true
		case "capacity":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'capacity' from interface{} to float64")
			}
			self.Capacity = int(v.(float64))
			capacityIsPresent = true
		default:
			return fmt.Errorf("Error during parsing: unknown key '%s'", k)
		}
	}

	if !idIsPresent {
		self.Id = StorageUnitIdUnset
	}
	if !locationIdIsPresent {
		self.Location = LocationNameUnset
	}
	if !nameIsPresent {
		self.Name = StorageUnitNameUnset
	}
	if !ipAddrIsPresent {
		self.IpAddress = StorageUnitIpAddrUnset
	}
	if !capacityIsPresent {
		self.Capacity = StorageUnitCapacityUnset
	}

	return nil
}

func (self *StorageUnit) MarshalJSON() ([]byte, error) /* implements json.Marshaler */ {
	type Alias StorageUnit
	return json.Marshal(&struct {
		*Alias
	}{
		Alias: (*Alias)(self),
	})
}

func (self *StorageUnit) String() string {
	return fmt.Sprintf("model.StorageUnit(model=\"\",id=%d,location=%s,name=%s,ip-address=%s,capacity=%d)", self.Id, self.Location, self.Name, self.IpAddress, self.Capacity)
}

func (self *StorageUnit) SelectById() error {
	row := self.QueryRow("SELECT location, storagename, ipaddr, capacity FROM Storages WHERE id = ?", self.Id)

	if err := row.Scan(&self.Location, &self.Name, &self.IpAddress, &self.Capacity); err != nil {
		return err
	}

	return nil
}

func (self *StorageUnit) SelectByName() error {
	row := self.QueryRow("SELECT id, location, ipaddr, capacity FROM Storages WHERE storagename = ?", self.Name)

	if err := row.Scan(&self.Id, &self.Location, &self.IpAddress, &self.Capacity); err != nil {
		return err
	}

	return nil
}

func (self *StorageUnit) SelectAll() ([]StorageUnit, error) {
	rows, err := self.Query("SELECT id, storagename, location, ipaddr, capacity FROM Storages")

	if err != nil {
		return nil, err
	}

	storages := make([]StorageUnit, 0)

	for rows.Next() {
		s := StorageUnit{}

		if err := rows.Scan(&s.Id, &s.Name, &s.Location, &s.IpAddress, &s.Capacity); err != nil {
			self.Println(err)
			return nil, err
		}
		storages = append(storages, s)
	}
	return storages, nil
}

func (self *StorageUnit) Insert() error {
	_, err := self.Exec("INSERT INTO Storages (location, storagename, ipaddr, capacity) VALUES (?,?,?,?)", self.Location, self.Name, self.IpAddress, self.Capacity)
	return err
}
