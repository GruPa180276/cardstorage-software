package controller

type Card struct {
	Position  int    `json:"position"`
	StorageId int    `json:"storage-id"`
	Name      string `json:"storage-name"`
}

type SerializableCardMessage struct {
	Header
	Card `json:"card"`
}

func NewSerializableCardMessage(h Header, c Card) (message SerializableCardMessage) {
	message.Header = h
	message.Card = c
	return
}
