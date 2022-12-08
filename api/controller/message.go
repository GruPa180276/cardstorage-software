package controller

type Message struct {
	MessageJson string
	Received    chan bool
}

type BaseMessage struct {
	Id     string `json:"messageid"`
	Action Action `json:"action"`
}

type Card struct {
	Position  int    `json:"position"`
	StorageId int    `json:"storageid"`
	Name      string `json:"storagename"`
}

type Ping struct {
	StorageId int `json:"storageid"`
}

func NewSerializableCardMessage(b BaseMessage, c Card) (message struct {
	BaseMessage
	Card `json:"card"`
}) {
	message.BaseMessage = b
	message.Card = c
	return
}
