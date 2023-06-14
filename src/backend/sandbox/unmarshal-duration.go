package main

import (
	"encoding/json"
	"fmt"
	"time"
)

type CardQueueEntry struct {
	Id       int       `json:"id,omitempty"`
	Userid   int       `json:"user-id"`
	Since    time.Time `json:"since"`
	Until    time.Time `json:"until"`
	Returned bool      `json:"returned"`
	Reserved bool      `json:"reserved"`
}

func (u *CardQueueEntry) MarshalJSON() ([]byte, error) {
	type Alias CardQueueEntry
	return json.Marshal(&struct {
		Since int64 `json:"since"`
		Until int64 `json:"until"`
		*Alias
	}{
		Since: u.Since.Unix(),
		Until: u.Until.Unix(),
		Alias: (*Alias)(u),
	})
}

// http://choly.ca/post/go-json-marshalling/
func (u *CardQueueEntry) UnmarshalJSON(data []byte) error {
	type Alias CardQueueEntry
	aux := &struct {
		Since int64 `json:"since"`
		Until int64 `json:"until"`
		*Alias
	}{
		Alias: (*Alias)(u),
	}
	if err := json.Unmarshal(data, aux); err != nil {
		return err
	}
	u.Since = time.Unix(aux.Since, 0)
	u.Until = time.Unix(aux.Until, 0)

	return nil
}

func main() {
	e := &CardQueueEntry{Since: time.Now(), Until: time.Now().Add(10 * time.Minute)}
	f := &CardQueueEntry{}

	buf, err := json.Marshal(e)
	if err != nil {
		panic(err)
	}

	fmt.Println(string(buf))

	err = json.Unmarshal(buf, f)
	if err != nil {
		panic(err)
	}

	fmt.Printf("%+v\n", f)
}
