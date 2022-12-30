package controller

type Card struct {
	Position uint `json:"position"`
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
