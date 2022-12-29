package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

type Handler func(responder mqtt.Client, msg *map[string]any, topic string)

var actions map[string]Handler

func main() {
	pingHandler := func(responder mqtt.Client, msgptr *map[string]any, topic string) {
		msg := *msgptr
		fmt.Println("~>", msg)

		msg["client-id"] = clientId
		(msg["ping"].(map[string]any))["is-available"] = true

		fmt.Println("<~", msg)

		buf, err := json.Marshal(msg)
		if err != nil {
			log.Fatalln(err)
		}
		if tok := responder.Publish(topic, 2, true, buf); tok.Wait() && tok.Error() != nil {
			log.Fatalln(err)
		}
	}

	actions = map[string]Handler{
		"storage-unit-ping": pingHandler,
	}

	mqtt.CRITICAL = log.New(os.Stderr, "[CRITICAL]: ", log.LstdFlags)
	// mqtt.DEBUG = log.New(os.Stderr, "[DEBUG]: ", log.LstdFlags)
	mqtt.ERROR = log.New(os.Stderr, "[CRITICAL]: ", log.LstdFlags)
	mqtt.WARN = log.New(os.Stderr, "[WARN]: ", log.LstdFlags)

	for {
		client := mqtt.NewClient(mqtt.NewClientOptions().
			AddBroker(broker).
			SetClientID(clientId).
			SetDefaultPublishHandler(func(client mqtt.Client, msg mqtt.Message) {
				fmt.Printf("Received message: %s from topic: %s\n", msg.Payload(), msg.Topic())
			}))
		client.Subscribe(topic, 2, func(c mqtt.Client, msg mqtt.Message) {
			log.Println(string(msg.Payload()))
			m := make(map[string]any)
			if err := json.Unmarshal(msg.Payload(), &m); err != nil {
				log.Fatalln(err)
			}
			if m["client-id"] == clientId {
				return
			}
			actions[m["action"].(string)](client, &m, msg.Topic())
		})
		if token := client.Connect(); token.Wait() && token.Error() != nil {
			panic(token.Error())
		}
		log.Println("connected...")
		for client.IsConnected() {
		}
	}
}

func must(value any, err error) any {
	if err != nil {
		log.Fatalln(err)
	}
	return value
}
