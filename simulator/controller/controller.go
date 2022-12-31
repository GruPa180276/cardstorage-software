package main

import (
	"crypto/tls"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/joho/godotenv"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/simulator/hardware"
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
	l = log.New(os.Stderr, clientId+": ", log.LstdFlags|log.Lshortfile)
}

var l *log.Logger

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
	l.Println("ACTION:", msg["action"])
	l.Println("~>", string(m.Payload()))

	msg["client-id"] = clientId
	msg["status"].(map[string]any)["successful"] = true

	buffer, err := json.Marshal(msg)
	if err != nil {
		l.Fatalln(err)
	}

	l.Println("<~", string(buffer))

	if token := c.Publish(topic, 2, true, buffer); token.Wait() && token.Error() != nil {
		l.Fatalln(token.Error())
	}
}

func newCardHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	l.Println("ACTION:", msg["action"])
	l.Println("~>", string(m.Payload()))

	msg["client-id"] = clientId

	scannedBytes, err := hardware.Scan()
	if err != nil {
		log.Println(err)
	}
	
	msg["card"].(map[string]any)["data"] = base64.URLEncoding.EncodeToString(scannedBytes)

	if err := hardware.StoreCard(msg["card"].(map[string]any)["position"].(int)); err != nil {
		msg["status"].(map[string]any)["successful"] = false
		msg["status"].(map[string]any)["reason-for-failure"] = err.Error()
		l.Println(err)
	}

	msg["status"].(map[string]any)["successful"] = true

	buffer := must(json.Marshal(msg)).([]byte)

	fmt.Println("<~", string(buffer))

	if token := c.Publish(topic, 2, false, buffer); token.Wait() && token.Error() != nil {
		log.Fatalln(token)
	}
}

func deleteCardHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	fmt.Println("ACTION:", msg["action"])
	fmt.Println("~>", string(m.Payload()))

	msg["client-id"] = clientId

	if err := hardware.GetCard(msg["card"].(map[string]any)["position"].(int)); err != nil {
		msg["status"].(map[string]any)["successful"] = false
		msg["status"].(map[string]any)["reason-for-failure"] = err.Error()
	}

	msg["status"].(map[string]any)["successful"] = true

	buffer := must(json.Marshal(msg)).([]byte)

	fmt.Println("<~", string(buffer))

	if token := c.Publish(topic, 2, false, buffer); token.Wait() && token.Error() != nil {
		log.Println(token.Error())
	}
}

func fetchCardMobileHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	fmt.Println("ACTION:", msg["action"])
	fmt.Println("~>", string(m.Payload()))

	msg["client-id"] = clientId

	if err := hardware.GetCard(msg["card"].(map[string]any)["position"].(int)); err != nil {
		msg["status"].(map[string]any)["successful"] = false
		msg["status"].(map[string]any)["reason-for-failure"] = err.Error()
	}

	msg["status"].(map[string]any)["successful"] = true

	buffer := must(json.Marshal(msg)).([]byte)

	fmt.Println("<~", string(buffer))

	if token := c.Publish(topic, 2, false, buffer); token.Wait() && token.Error() != nil {
		log.Println(token.Error())
	}
}

var index = make(map[string]struct{})

func fetchCardTerminalHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	fmt.Println("ACTION:", msg["action"])
	fmt.Println("~>", string(m.Payload()))

	if _, exists := index[msg["message-id"].(string)]; !exists {
		// check if user exists
		msg["client-id"] = clientId

		scannedBytes, err := hardware.Scan()

		if err != nil {
			l.Printf("error during scanning: %s\n", err.Error())
			msg["status"].(map[string]any)["successful"] = false
			msg["status"].(map[string]any)["reason-for-failure"] = err.Error()
		}
		msg["status"].(map[string]any)["successful"] = true
		msg["user"].(map[string]any)["token"] = base64.URLEncoding.EncodeToString(scannedBytes)

		buffer := must(json.Marshal(msg)).([]byte)

		fmt.Println("<~", string(buffer))

		if token := c.Publish(topic, 2, false, buffer); token.Wait() && token.Error() != nil {
			log.Println(token.Error())
		}

		index[msg["message-id"].(string)] = struct{}{}
	} else {
		// we now know that the user exists as this is the
		// request from the server to our initial
		// response.
		// now: fetch card
		fetchCardMobileHandler(c, m, msg)
	}
}

func depositCardHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	fmt.Println("ACTION:", msg["action"])
	fmt.Println("~>", string(m.Payload()))
}

func depositCardDispatcher() {
	// event: card is deposited into storage-unit (how do we know that card is deposited?)
	// 1. scan card
	// 2. send card token to server to check if card belongs to this unit
	// 3. if yes, deposit card; otherwise reject card and inform user
}

func userSignupHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	fmt.Println("ACTION:", msg["action"])
	fmt.Println("~>", string(m.Payload()))

	msg["client-id"] = clientId

	buffer, err := hardware.Scan()
	if err != nil {
		msg["status"].(map[string]any)["successful"] = false
		msg["status"].(map[string]any)["reason-for-failure"] = err.Error()
		l.Println(err)
	}

	msg["status"].(map[string]any)["successful"] = true
	msg["user"].(map[string]any)["token"] = base64.URLEncoding.EncodeToString(buffer)

	buffer := must(json.Marshal(msg)).([]byte)

	fmt.Println("<~", string(buffer))

	if token := c.Publish(topic, 2, false, buffer); token.Wait() && token.Error() != nil {
		log.Fatalln(token)
	}
}

func must(value any, err error) any {
	if err != nil {
		log.Fatalln(err)
	}
	return value
}
