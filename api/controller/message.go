package controller

type Message struct {
	MessageJson string
	Received    chan bool
}

type Result struct {
	Data                *Message
	MqttMessageReceived chan bool
}

const HeaderTimeToLiveInitial = 5

type Header struct {
	Id         string `json:"message-id"`
	ClientId   string `json:"client-id"`
	TimeToLive int    `json:"ttl"`
	Action     Action `json:"action"`
}

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
