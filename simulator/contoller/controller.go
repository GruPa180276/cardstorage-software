package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

type Handler func(responder mqtt.Client, msg map[string]any, topic string)

const clientId = "sim0"

var client mqtt.Client
var actions map[string]Handler

func init() {
	buf, err := os.ReadFile("../actions.json")
	if err != nil {
		log.Fatalln(err)
	}

	keys := make([]string, 0)
	if err := json.Unmarshal(buf, &keys); err != nil {
		log.Fatalln(err)
	}

	defaultHandler := func(responder mqtt.Client, msg map[string]any, topic string) {
		fmt.Println(msg)
		_, _ = responder, topic
	}

	pingHandler := func(responder mqtt.Client, msg map[string]any, topic string) {
		fmt.Println("~>", msg)

		msg["client-id"] = clientId
		(msg["ping"].(map[string]any))["is-available"] = true

		fmt.Println("<~", msg)

		buf, err := json.Marshal(msg)
		if err != nil {
			log.Fatalln(err)
		}
		if tok := responder.Publish(topic, 1, false, buf); tok.Wait() && tok.Error() != nil {
			log.Fatalln(err)
		}
	}

	actions = make(map[string]Handler)
	for _, k := range keys {
		switch k {
		case "storage-unit-ping":
			actions[k] = pingHandler
		default:
			actions[k] = defaultHandler
		}
	}

	client = mqtt.NewClient(mqtt.NewClientOptions().AddBroker("tcp://localhost:1883").SetClientID(clientId))
	<-client.Connect().Done()
	<-client.Subscribe("storage-unit-1@3-28/1", 1, func(c mqtt.Client, msg mqtt.Message) {
		m := make(map[string]any)
		if err := json.Unmarshal(msg.Payload(), &m); err != nil {
			log.Fatalln(err)
		}
		if m["client-id"] == clientId {
			return
		}
		actions[m["action"].(string)](c, m, msg.Topic())
	}).Done()
}

func main() {

	//for i := 0; ; i++ {
	//	<-client.Publish("test", 1, false, []byte(fmt.Sprintf("%d", i))).Done()
	//	time.Sleep(1000 * time.Millisecond)
	//	// fmt.Println(i)
	//}

	<-make(chan struct{})
}
