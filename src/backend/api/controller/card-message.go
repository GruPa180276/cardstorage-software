package controller

type Card struct {
	Position   uint   `json:"position"`
	Name       string `json:"card-name"` // just for convenience to not have to search the database again
	ReaderData string `json:"data"`
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

type SerializableCardStatusMessage struct {
	Header
	Card   `json:"card"`
	Status `json:"status"`
}

func NewSerializableCardStatusMessage(h Header, c Card, s Status) (message SerializableCardStatusMessage) {
	message.Header = h
	message.Card = c
	message.Status = s
	return message
}
