package main

import (
	"fmt"
	"io"
	"log"
	"os"
	_ "time/tzdata"

	"github.com/mochi-co/mqtt/server"
	"github.com/mochi-co/mqtt/server/events"
	"github.com/mochi-co/mqtt/server/listeners"
	"github.com/mochi-co/mqtt/server/listeners/auth"
)

func main() {
	writer := io.MultiWriter(os.Stderr)

	logger := log.New(writer, "Broker: ", log.Lshortfile|log.LstdFlags)

	addr := fmt.Sprintf("%s:%s", os.Getenv("BROKER_HOSTNAME"), os.Getenv("BROKER_PORT"))

	mqs := server.NewServer(nil)
	if err := mqs.AddListener(listeners.NewTCP("t1", addr), &listeners.Config{Auth: new(auth.Allow)}); err != nil {
		logger.Fatalln(err)
	}

	logger.Println("mqtt-server listening on", "tcp://"+addr)

	if err := mqs.Serve(); err != nil {
		logger.Println("MQTT Error: " + err.Error())
	}

	mqs.Events.OnConnect = func(c events.Client, p events.Packet) {
		logger.Printf("Connect> Client: %q", c.ID)
	}

	mqs.Events.OnDisconnect = func(c events.Client, _ error) {
		logger.Printf("Disconnect> Client: %q", c.ID)
	}

	mqs.Events.OnMessage = func(c events.Client, p events.Packet) (events.Packet, error) {
		logger.Printf("Message> Client: %q, Topic: %q, Payload: %s", c.ID, p.TopicName, string(p.Payload))
		return p, nil
	}

	mqs.Events.OnSubscribe = func(filter string, cl events.Client, qos byte) {
		logger.Printf("Subscribe> Client: %q, Topic: %q", cl.ID, filter)
	}

	for {
	}
}
