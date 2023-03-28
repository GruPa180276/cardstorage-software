package main

import (
	"crypto/tls"
	"encoding/base64"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"math"
	"math/rand"
	"net/http"
	"os"
	"strings"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
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
	broker_url      string
	broker_port     string
	broker_username string
	broker_passwd   string
	topic           string
)

func init() {
	flag.StringVar(&clientId, "client-id", "sim0", "name of this simulator instance")
	flag.StringVar(&broker_url, "broker-url", "127.0.0.1", "address of mqtt broker")
	flag.StringVar(&broker_port, "broker-port", "1884", "tcp port of mqtt broker")
	flag.StringVar(&broker_username, "broker-username", "CardStorageManagement", "broker credential: username")
	flag.StringVar(&broker_passwd, "broker-passwd", "CardStorageManagement", "broker credential: passwd")
	flag.StringVar(&topic, "topic", "S4@L4/1", "topic to subscribe to")

	flag.Parse()

	fmt.Println(clientId, broker_url, broker_port, broker_username, broker_passwd, topic)

	rand.Seed(time.Now().Unix())
	//must(nil, godotenv.Load("../../.env"))
	//clientId = os.Getenv("SIM_CONTROLLER_CLIENT_ID")
	//broker = "tcp://127.0.0.1" + ":" + os.Getenv("BROKER_PORT")
	//broker_username = os.Getenv("BROKER_USERNAME")
	//broker_passwd = os.Getenv("BROKER_PASSWD")
	//topic = os.Getenv("SIM_CONTROLLER_TOPIC")
	l = log.New(os.Stderr, clientId+": ", log.LstdFlags|log.Lshortfile)
}

var l *log.Logger

func main() {
	client := mqtt.NewClient(mqtt.NewClientOptions().
		AddBroker("tcp://" + broker_url + ":" + broker_port).
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

	for {
		yes := ""
		fmt.Print("deposit? [y/n] >>> ")
		fmt.Scanln(&yes)

		if strings.ToLower(strings.Trim(yes, " \r\n")) != "y" {
			continue
		}

		cardData := ""
		fmt.Print(">>> ")
		fmt.Scanln(&cardData)

		if cardData = strings.Trim(cardData, " \r\n"); cardData == "" {
			continue
		}

		depositCardDispatcher(client, cardData)
	}
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

	if token := c.Publish(topic, 2, false, buffer); token.Wait() && token.Error() != nil {
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

	if err := hardware.StoreCard(int(msg["card"].(map[string]any)["position"].(float64))); err != nil {
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

	if err := hardware.GetCard(int(msg["card"].(map[string]any)["position"].(float64))); err != nil {
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

	if err := hardware.GetCard(int(msg["card"].(map[string]any)["position"].(float64))); err != nil {
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

	pos := int(((msg["card"].(map[string]interface{}))["position"]).(float64))
	name := ((msg["card"].(map[string]interface{}))["card-name"]).(string)
	stat := ((msg["status"].(map[string]interface{}))["successful"]).(bool)
	fail := ((msg["status"].(map[string]interface{}))["reason-for-failure"]).(string)

	if stat {
		hardware.GetCard(pos)
		fmt.Printf("successfully deposited card '%s' at position %d", name, pos)
	} else {
		fmt.Println(fail)
	}
}

func depositCardDispatcher(c mqtt.Client, encodedCardData string) {
	// event: card is deposited into storage-unit (how do we know that card is deposited?)
	// 1. scan card
	// 2. send card token to server to check if card belongs to this unit
	// 3. if yes, deposit card; otherwise reject card and inform user

	fmt.Println("ACTION: deposit")

	// buffer := fmt.Sprintf(`{
	// 	 "message-id": "",
	//   "client-id": "%s",
	//	 "action": "storage-unit-deposit-card",
	//	 "status": { "successful": false, "reason-for-failure": "" },
	//	 "card": { "position": 0, "card-name ": "C1", "data": "%s" }
	// }`, clientId, encodedCardData)

	// 5a869d62-673c-481a-900e-183b815a0974
	buffer := strings.Trim(fmt.Sprintf(`{
		"message-id": "",
		"action": "storage-unit-deposit-card",
		"client-id": "%s",
		"status": { "reason-for-failure": "", "successful": true },
		"card": { "position": %d, "card-name": "", "data": "%s" }
	}`, clientId, uint(math.MaxUint), encodedCardData), "\r\n ")

	fmt.Println("<~", buffer)

	if token := c.Publish(topic, 2, false, buffer); token.Wait() && token.Error() != nil {
		log.Fatalln(token)
	}
}

func userSignupHandler(c mqtt.Client, m mqtt.Message, msg map[string]any) {
	fmt.Println("ACTION:", msg["action"])
	fmt.Println("~>", string(m.Payload()))

	msg["client-id"] = clientId

	scannedBytes, err := hardware.Scan()
	if err != nil {
		msg["status"].(map[string]any)["successful"] = false
		msg["status"].(map[string]any)["reason-for-failure"] = err.Error()
		l.Println(err)
	}

	msg["status"].(map[string]any)["successful"] = true
	msg["user"].(map[string]any)["token"] = base64.URLEncoding.EncodeToString(scannedBytes)

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
