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

type CardDeleter struct {
	DeletionSuccessful bool   `json:"successful"`
	IfNotWhy           string `json:"reason-for-failure"`
}

type SerializableCardDeletionMessage struct {
	Header
	Card        `json:"card"`
	CardDeleter `json:"status"`
}

func NewSerializableCardDeletionMessage(h Header, c Card, d CardDeleter) (message SerializableCardDeletionMessage) {
	message.Header = h
	message.Card = c
	message.CardDeleter = d
	return message
}
