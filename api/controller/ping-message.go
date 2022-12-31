package controller

type Ping struct {
	StorageName string `json:"storage-name"`
	IsAvailable bool   `json:"is-available"`
}

type SerializablePingMessage struct {
	Header
	Status `json:"status"`
}

func NewSerializablePingMessage(h Header, s Status) (message SerializablePingMessage) {
	message.Header = h
	message.Status = s
	return
}
