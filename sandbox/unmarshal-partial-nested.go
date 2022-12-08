package main

import (
	"encoding/json"
	"fmt"
)

type Ping struct {
	Card struct {
		StorageId int `json:"storage-id"`
	} `json:"card"`
}

func (self Ping) String() string {
	return fmt.Sprintf("Ping[Card[StorageId=%d]]", self.Card.StorageId)
}

func main() {
	msg := Ping{}
	json.Unmarshal([]byte(`
	{
		"message-id": "a1b2c3d4",
		"action": "efgh",
		"card": {
			"storage-id": 12
		}
	}
	`), &msg)

	fmt.Println(msg)
}
