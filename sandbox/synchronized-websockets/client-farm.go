package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"sync"

	"github.com/gorilla/websocket"
)

const CLIENTS int = 1 << 9

func main() {
	wg := &sync.WaitGroup{}
	sigchan := make(chan os.Signal)
	signal.Notify(sigchan, os.Interrupt)
	connections := make([]*websocket.Conn, 0)
	readerChans := make([]chan struct{}, 0)
	for i := 0; i < CLIENTS; i++ {
		logger := log.New(os.Stderr, fmt.Sprintf("client-%03d: ", i), 0x00)
		wg.Add(1)
		c := make(chan struct{})
		readerChans = append(readerChans, c)
		go func(l *log.Logger, keepReading chan struct{}) {
			wg.Add(1)
			socket, _, err := websocket.DefaultDialer.Dial("ws://localhost:7173/ws", nil)
			if err != nil {
				panic(err)
			}
			connections = append(connections, socket)

			for {
				_, buf, err2 := socket.ReadMessage()
				if err2 != nil {
					// if connection is already closed (most likely) by hitting 'CTRL+C' and subsequently triggering the signal below
					// return
					if _, ok := err2.(*net.OpError); ok {
						wg.Done()
						return
					}
					panic(err2)
				}
				l.Println(string(buf))
			}

		}(logger, c)
	}

	go func() {
		wg.Add(1)
		select {
		case <-sigchan:
			// close connections
			for _, c := range connections {
				c.WriteMessage(websocket.CloseMessage, nil)
				c.Close()
			}
			wg.Done()
			os.Exit(0)
		}
	}()

	wg.Wait()
}
