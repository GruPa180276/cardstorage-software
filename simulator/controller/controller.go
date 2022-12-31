package main

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/joho/godotenv"
)

var actions = map[string]func(mqtt.Client, mqtt.Message, map[string]any){
	"storage-unit-ping":                       pingHandler,
	"storage-unit-new-card":                   newCardHandler,
	"storage-unit-delete-card":                deleteCardHandler,
	"storage-unit-fetch-card-source-mobile":   fetchCardMobileHandler,
	"storage-unit-fetch-card-source-terminal": fetchCardTerminalHandler,
	"storage-unit-deposit-card":               depositCardHandler,
	"user-signup":                             userSignupHandler,
}

var (
	clientId        string
	broker          string
	broker_username string
	broker_passwd   string
	topic           string
)

func init() {
	must(nil, godotenv.Load("../../.env"))
	clientId = os.Getenv("SIM_CONTROLLER_CLIENT_ID")
	broker = "tcp://" + os.Getenv("BROKER_HOSTNAME") + ":" + os.Getenv("BROKER_PORT")
	broker_username = os.Getenv("BROKER_USERNAME")
	broker_passwd = os.Getenv("BROKER_PASSWD")
	topic = os.Getenv("SIM_CONTROLLER_TOPIC")
	fmt.Println(topic)
}

func main() {
	client := mqtt.NewClient(mqtt.NewClientOptions().
		AddBroker(broker).
		SetClientID(clientId).
		SetUsername(broker_username).
		SetPassword(broker_passwd).
		SetOrderMatters(true))

	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}

	mqtt.CRITICAL = log.New(os.Stderr, "[CRITICAL]: ", log.LstdFlags)
	mqtt.ERROR = log.New(os.Stderr, "[CRITICAL]: ", log.LstdFlags)
	mqtt.WARN = log.New(os.Stderr, "[WARN]: ", log.LstdFlags)
	// mqtt.DEBUG = log.New(os.Stderr, "[DEBUG]: ", log.LstdFlags)

	if token := client.Connect(); token.Wait() && token.Error() != nil {
		panic(token.Error())
	}
	log.Println("connected...")

	token := client.Subscribe(topic, 2, func(c mqtt.Client, msg mqtt.Message) {
		// log.Println(string(msg.Payload()))
		m := make(map[string]any)
		if err := json.Unmarshal(msg.Payload(), &m); err != nil {
			log.Fatalln(err)
		}
		if m["client-id"] == clientId {
			return
		}
		// call action handler in its own goroutine
		// as described in mqtt.Client.Subscribe to avoid
		// timing problems and random socket
		// disconnects with the broker
		go actions[m["action"].(string)](c, msg, m)
	})
	if token.Wait() && token.Error() != nil {
		panic(token.Error())
	}

	select {}
}

func pingHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	fmt.Println("~>", string(m.Payload()))

	msg["client-id"] = clientId
	(msg["ping"].(map[string]any))["is-available"] = true

	buf, err := json.Marshal(msg)
	if err != nil {
		log.Fatalln(err)
	}

	fmt.Println("<~", string(buf))

	if tok := c.Publish(topic, 2, true, buf); tok.Wait() && tok.Error() != nil {
		log.Fatalln(err)
	}
}

func newCardHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {

}

func deleteCardHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {

}

func fetchCardMobileHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {

}

func fetchCardTerminalHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {

}

func depositCardHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {

}

func userSignupHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {

}

func must(value any, err error) any {
	if err != nil {
		log.Fatalln(err)
	}
	return value
}
