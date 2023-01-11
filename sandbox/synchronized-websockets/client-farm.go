package main

import (
	"fmt"
	"log"
	"os"
	"sync"

	ws "github.com/gorilla/websocket"
)

const CLIENTS int = 100

func main() {
	wg := &sync.WaitGroup{}
	subcounter := 0
	for i := 0; i < CLIENTS; i++ {
		id := ""
		if 'A'+i > 'Z' {
			subcounter++
			id = fmt.Sprintf("A%d", subcounter)
		}
		logger := log.New(os.Stderr, fmt.Sprintf("client-%s: ", id), 0x00)
		wg.Add(1)
		go func(l *log.Logger) {
			socket, _, err := ws.DefaultDialer.Dial("ws://localhost:7173/ws", nil)
			if err != nil {
				panic(err)
			}
			for {
				_, buf, err2 := socket.ReadMessage()
				if err2 != nil {
					panic(err2)
				}
				l.Println(string(buf))
			}
			wg.Done()
		}(logger)
	}

	wg.Wait()
}
