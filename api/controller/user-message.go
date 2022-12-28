package controller

type User struct {
	ReaderData string `json:"token"`
	Email      string `json:"email"`
}

type SerializableUserMessage struct {
	Header
	*User `json:"user"`
}

func NewSerializableUserMessage(h Header, u User) (message SerializableUserMessage) {
	message.Header = h
	message.User = u
	return
}
