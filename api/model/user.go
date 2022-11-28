package model

import (
	"encoding/json"
	"fmt"
)

const (
	UserIdUnset         int    = -1
	UserEmailUnset      string = "<invalid:email>"
	UserReaderDataUnset string = "<invalid:readerdata>"
)

type User struct {
	Id         int    `json:"id,omitempty"`
	Email      string `json:"email"`
	ReaderData string `json:"readerdata"`
	*Model
}

func NewUser(model *Model, id int, email string, readerData string) *User {
	return &User{
		Id:         id,
		Email:      email,
		ReaderData: readerData,
		Model:      model,
	}
}

func ShallowCopyUser(user *User) *User {
	return NewUser(user.Model, user.Id, user.Email, user.ReaderData)
}

// Correctly convert UNIX Timestamp into Go's time.Time type
func (self *User) UnmarshalJSON(data []byte) error /* implements json.Unmarshaler */ {
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

	user := d.(map[string]interface{})

	var (
		idIsPresent         = false
		emailIsPresent      = false
		readerDataIsPresent = false
	)

	for k, v := range user {
		switch k {
		case "id":
			if _, ok := v.(float64); !ok {
				return fmt.Errorf("error: converting attribute 'id' from interface{} to float64")
			}
			self.Id = int(v.(float64))
			idIsPresent = true
		case "email":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'email' from interface{} to string")
			}
			self.Email = v.(string)
			emailIsPresent = true
		case "readerdata":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'readerdata' from interface{} to string")
			}
			self.ReaderData = v.(string)
			readerDataIsPresent = true
		default:
			return fmt.Errorf("Error during parsing: unknown key '%s'", k)
		}
	}

	if !idIsPresent {
		self.Id = UserIdUnset
	}
	if !emailIsPresent {
		self.Email = UserEmailUnset
	}
	if !readerDataIsPresent {
		self.ReaderData = UserReaderDataUnset
	}

	return nil
}

func (self *User) MarshalJSON() ([]byte, error) /* implements json.Marshaler */ {
	type Alias User
	return json.Marshal(&struct {
		*Alias
	}{
		Alias: (*Alias)(self),
	})
}

func (self *User) String() string {
	return fmt.Sprintf("model.User(model=\"\",id=%d,email=%s,readerdata=%s)", self.Id, self.Email, self.ReaderData)
}

func (self *User) SelectById() error {
	row := self.QueryRow("SELECT id, email, readerdata FROM Users WHERE id = ?", self.Id)

	if err := row.Err(); err != nil {
		self.Println(err)
		return err
	}

	if err := row.Scan(&self.Id, &self.Email, &self.ReaderData); err != nil {
		self.Println(err)
		return err
	}
	return nil
}

func (self *User) SelectByEmail() error {
	row := self.QueryRow("SELECT id, email, readerdata FROM Users WHERE email = ?", self.Email)

	if err := row.Err(); err != nil {
		self.Println(err)
		return err
	}

	if err := row.Scan(&self.Id, &self.Email, &self.ReaderData); err != nil {
		// self.Println(err)
		return err
	}
	return nil
}

func (self *User) SelectByReaderData() error {
	row := self.QueryRow("SELECT id, email, readerdata FROM Users WHERE readerdata = ?", self.ReaderData)

	if err := row.Err(); err != nil {
		self.Println(err)
		return err
	}

	if err := row.Scan(&self.Id, &self.Email, &self.ReaderData); err != nil {
		// self.Println(err)
		return err
	}
	return nil
}

func (self *User) SelectAll() ([]User, error) {
	rows, err := self.Query("SELECT id, email, readerdata FROM Users")

	if err != nil {
		return nil, err
	}

	users := make([]User, 0)

	for rows.Next() {
		u := User{}

		if err := rows.Scan(&u.Id, &u.Email, &u.ReaderData); err != nil {
			self.Println(err)
			return nil, err
		}
		users = append(users, u)
	}
	return users, nil
}

func (self *User) Insert() error {
	_, err := self.Exec("INSERT INTO Users (email, readerdata) VALUES (?,?)", self.Email, self.ReaderData)
	return err
}

func (self *User) Update() error {
	return nil
}

func (self *User) Delete() error {
	return nil
}
