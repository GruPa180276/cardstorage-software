package controller

type Ping struct {
	StorageName string `json:"storage-name"`
	IsAvailable bool   `json:"is-available"`
}

type SerializablePingMessage struct {
	Header
	Ping `json:"ping"`
}

func NewSerializablePingMessage(h Header, p Ping) (message SerializablePingMessage) {
	message.Header = h
	message.Ping = p
	return
}
