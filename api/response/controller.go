package response

type Message struct {
	MessageJson string
	Received    chan bool
}
