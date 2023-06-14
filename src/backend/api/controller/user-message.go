package controller

type User struct {
	ReaderData *string `json:"token"`
	Email      *string `json:"email"`
	Exists     bool    `json:"exists"`
}

type SerializableUserMessage struct {
	Header
	User   `json:"user"`
	Status `json:"status"`
}

func NewSerializableUserMessage(h Header, u User, s Status) (message SerializableUserMessage) {
	message.Header = h
	message.User = u
	message.Status = s
	return
}

type SerializableUserCardMessage struct {
	Header
	User   `json:"user"`
	Card   `json:"card"`
	Status `json:"status"`
}

func NewSerializableUserCardMessage(h Header, u User, c Card, s Status) (message SerializableUserCardMessage) {
	message.Header = h
	message.User = u
	message.Card = c
	message.Status = s
	return
}
