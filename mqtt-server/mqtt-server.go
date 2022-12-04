package main

import (
	"github.com/mochi-co/mqtt/server"
	"github.com/mochi-co/mqtt/server/events"
	"github.com/mochi-co/mqtt/server/listeners"
	"github.com/mochi-co/mqtt/server/listeners/auth"
	"log"
	"os"
)

func main() {
	logger := log.New(os.Stderr, "MQS: ", log.Lshortfile|log.LstdFlags)

	addr := "localhost:1883"

	mqs := server.NewServer(nil)
	if err := mqs.AddListener(listeners.NewTCP("t1", addr), &listeners.Config{Auth: new(auth.Allow)}); err != nil {
		logger.Fatalln(err)
	}

	logger.Println("mqtt-server listening on", "tcp://"+addr)

	if err := mqs.Serve(); err != nil {
		logger.Println("MQTT Error: " + err.Error())
	}

	mqs.Events.OnMessage = func(c events.Client, p events.Packet) (events.Packet, error) {
		logger.Printf("Client: '%s', Topic: '%s', Payload: '%s'", c.ID, p.TopicName, string(p.Payload))
		return p, nil
	}

	<-make(chan struct{})
}
