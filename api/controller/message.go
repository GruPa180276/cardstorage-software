package controller

type Header struct {
	Id       string `json:"message-id"`
	ClientId string `json:"client-id"`
	Action   Action `json:"action"`
}

type Status struct {
	ActionSuccessful bool   `json:"successful"`
	IfNotWhy         string `json:"reason-for-failure"`
}
