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
	Id         int    `json:"id,omitempty"`
	LocationId int    `json:"locationid"`
	Name       string `json:"name"`
	IpAddress  string `json:"ipaddress"`
	Capacity   int    `json:"capacity"`
	*Model
}

func NewStorage(model *Model, id int, locationid int, name string, ipaddress string, capacity int) *StorageUnit {
	return &StorageUnit{
		Id:         id,
		LocationId: locationid,
		Name:       name,
		IpAddress:  ipaddress,
		Capacity:   capacity,
		Model:      model,
	}
}

func CopyStorageUnit(storage *StorageUnit) *StorageUnit {
	return NewStorage(storage.Model, storage.Id, storage.LocationId, storage.Name, storage.IpAddress, storage.Capacity)
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
		case "locationid":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'locationid' from interface{} to float64")
			}
			self.LocationId = int(v.(float64))
			locationIdIsPresent = true
		case "name":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'name' from interface{} to string")
			}
			self.Name = v.(string)
			nameIsPresent = true
		case "ipaddress":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'ipaddress' from interface{} to string")
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
		self.LocationId = LocationIdUnset
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
	return fmt.Sprintf("model.StorageUnit(model=\"\",id=%d,locationid=%d,name=%s,ipaddress=%s,capacity=%d)", self.Id, self.LocationId, self.Name, self.IpAddress, self.Capacity)
}

func (self *StorageUnit) SelectById() error {
	row := self.QueryRow("SELECT fk_locid, storagename, ipaddr, capacity FROM Storages WHERE id = ?", self.Id)

	if err := row.Scan(&self.LocationId, &self.Name, &self.IpAddress, &self.Capacity); err != nil {
		return err
	}

	return nil
}

func (self *StorageUnit) SelectByName() error {
	row := self.QueryRow("SELECT id, fk_locid, ipaddr, capacity FROM Storages WHERE storagename = ?", self.Name)

	if err := row.Scan(&self.Id, &self.LocationId, &self.IpAddress, &self.Capacity); err != nil {
		return err
	}

	return nil
}

func (self *StorageUnit) SelectAll() ([]StorageUnit, error) {
	rows, err := self.Query("SELECT id, storagename, fk_locid, ipaddr, capacity FROM Storages")

	if err != nil {
		return nil, err
	}

	storages := make([]StorageUnit, 0)

	for rows.Next() {
		s := StorageUnit{}

		if err := rows.Scan(&s.Id, &s.Name, &s.LocationId, &s.IpAddress, &s.Capacity); err != nil {
			self.Println(err)
			return nil, err
		}
		storages = append(storages, s)
	}
	return storages, nil
}

func (self *StorageUnit) Insert() error {
	_, err := self.Exec("INSERT INTO Storages (fk_locid, storagename, ipaddr, capacity) VALUES (?,?,?,?)", self.LocationId, self.Name, self.IpAddress, self.Capacity)
	return err
}
