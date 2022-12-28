package controller

type Header struct {
	Id       string `json:"message-id"`
	ClientId string `json:"client-id"`
	Action   Action `json:"action"`
}
