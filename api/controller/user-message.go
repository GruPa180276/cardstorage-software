package controller

type User struct {
	ReaderData *string `json:"token"`
	Email      *string `json:"email"`
	Exists     bool    `json:"exists"`
}

type SerializableUserMessage struct {
	Header
	User `json:"user"`
}

func NewSerializableUserMessage(h Header, u User) (message SerializableUserMessage) {
	message.Header = h
	message.User = u
	return
}

type SerializableUserCardMessage struct {
	Header
	User `json:"user"`
	Card `json:"card"`
}

func NewSerializableUserCardMessage(h Header, u User, c Card) (message SerializableUserCardMessage) {
	message.Header = h
	message.User = u
	message.Card = c
	return
}
