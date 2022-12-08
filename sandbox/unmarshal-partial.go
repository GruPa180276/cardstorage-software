package main

import (
	"encoding/json"
	"fmt"
)

type Header struct {
	Id     string `json:"message-id"`
	Action string `json:"action"`
}

func (self Header) String() string {
	return fmt.Sprintf("Header[Id=%q Action=%q]", self.Id, self.Action)
}

func main() {
	msg := Header{}
	json.Unmarshal([]byte(`
	{
		"message-id": "a1b2c3d4",
		"action": "efgh",
		"card": {
			"name": "abc"
		}
	}
	`), &msg)

	fmt.Println(msg)
}
