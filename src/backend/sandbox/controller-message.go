package main

import (
	"encoding/json"
	"fmt"
	"github.com/google/uuid"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"log"
)

const (
	ActionUnset          = iota - 1
	ActionScanNewCardNow // "action": "scan-new-card-now"
)

/*func (self *CardMessageObject) UnmarshalJSON(data []byte) error {
	// convert byte-stream into generic adressable type
	// strongly type to make sure go's reflection knows
	var d interface{}
	err := json.Unmarshal(data, &d)
	if err != nil {
		return err
	}

	card := d.(map[string]interface{})

	for k, v := range card {
		switch k {
		case "messageid":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'messageid' from interface{} to string")
			}
			self.Id = uuid.MustParse(v.(string))
			fmt.Println(self.Id)
		case "action":
			if _, ok := v.(string); !ok {
				return fmt.Errorf("error: converting attribute 'action' from interface{} to string")
			}
			switch v.(string) {
			case "scan-new-card-now":
				self.Action = ActionScanNewCardNow
			default:
				self.Action = ActionUnset
			}
			fmt.Println(self.Action)
		default:
			// handled in CardMessage.UnmarshalJSON
			if k != "card" {
				return fmt.Errorf("Error during parsing: unknown key '%s'", k)
			}
		}
	}

	return nil
}

func (self *CardMessageObject) MarshalJSON() ([]byte, error) {
	var action string
	switch self.Action {
	case ActionScanNewCardNow:
		action = "scan-new-card-now"
	default:
		action = "<invalid:action>"
	}
	return json.Marshal(&struct {
		id     string      `json:"messageid"`
		action string      `json:"action"`
		card   *CardObject `json:"card"`
	}{
		id:     self.Id.String(),
		action: action,
		card:   self.Card,
	})
}*/

type ControllerCard struct {
	Position  int    `json:"position"`
	StorageId int    `json:"storageid"`
	Name      string `json:"storagename"`
}

type ControllerMessage struct {
	Id     string          `json:"messageid"`
	Action string          `json:"action"`
	Card   *ControllerCard `json:"card"`
}

func EncodeAndDecodeControllerMessage() {
	cardmsg := new(ControllerMessage)
	cardmsg.Card = new(ControllerCard)

	err := json.Unmarshal([]byte(fmt.Sprintf(`
	{
		"messageid": "%s",
		"action": "scan-new-card-now",
		"card": {
			"position": %d,
			"storageid": %d,
			"storagename": "%s"
		}
	}`, uuid.New().String(), 3, 3, "card-3")), cardmsg)

	if err != nil {
		log.Fatalln(err)
	}

	fmt.Printf("Message: {id=%s, action=%s}, Card: {pos=%d, storageid=%d, name=%s}\n",
		cardmsg.Id,
		cardmsg.Action,
		cardmsg.Card.Position,
		cardmsg.Card.StorageId,
		cardmsg.Card.Name)

	fmt.Println(string(util.Must(json.Marshal(cardmsg)).([]byte)))
}

func main() {
	EncodeAndDecodeControllerMessage()
}
