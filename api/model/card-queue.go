package model

import (
	"encoding/json"
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

func (self *CardQueueEntry) MarshalJSON() ([]byte, error) {
	type Alias CardQueueEntry
	return json.Marshal(&struct {
		Since int64 `json:"since"`
		Until int64 `json:"until"`
		*Alias
	}{
		Since: self.Since.Unix(),
		Until: self.Until.Unix(),
		Alias: (*Alias)(self),
	})
}

func (self *CardQueueEntry) UnmarshalJSON(data []byte) error {
	type Alias CardQueueEntry
	aux := &struct {
		Since int64 `json:"since"`
		Until int64 `json:"until"`
		*Alias
	}{
		Alias: (*Alias)(self),
	}
	if err := json.Unmarshal(data, aux); err != nil {
		return err
	}
	self.Since = time.Unix(aux.Since, 0)
	self.Until = time.Unix(aux.Until, 0)
	return nil
}
