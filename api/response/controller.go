package response

type Message struct {
	MessageJson string
	Received    chan bool
}

type ControllerCard struct {
	Position  int    `json:"position"`
	StorageId int    `json:"storageid"`
	Name      string `json:"storagename"`
}

type ControllerMessage struct {
	Id     string          `json:"messageid"`
	Action string          `json:"action"`
	Card   *ControllerCard `json:"card"`
}

const (
	ControllerMessageActionAddNewCardToStorageUnit         string = `scan-new-card-now`
	ControllerMessageActionBorrowCardFromTerminal          string = `get-card-from-terminal`
	ControllerMessageActionBorrowCardFromMobileApplication string = `get-card-from-mobile-application`
)

type ObserverResult struct {
	Data                *ControllerMessage
	MqttMessageReceived chan bool
}
