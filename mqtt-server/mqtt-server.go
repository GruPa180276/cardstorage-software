package main

import (
	"github.com/mochi-co/mqtt/server"
	"github.com/mochi-co/mqtt/server/listeners"
	"github.com/mochi-co/mqtt/server/listeners/auth"
	"log"
	"os"
)

func main() {
	logger := log.New(os.Stderr, "MQS: ", log.Lshortfile|log.LstdFlags)

	mqs := server.NewServer(nil)
	mqs.AddListener(listeners.NewTCP("t1", "localhost:1883"), &listeners.Config{Auth: new(auth.Allow)})

	if err := mqs.Serve(); err != nil {
		logger.Println("MQTT Error: " + err.Error())
	}

	select {}
}
