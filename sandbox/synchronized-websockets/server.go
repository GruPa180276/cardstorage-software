package main

import (
	"encoding/base64"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"sync"
	"time"

	"github.com/gorilla/handlers"
	"github.com/gorilla/websocket"
)

func init() {
	rand.Seed(time.Now().Unix())
}

func main() {
	upgrader := &websocket.Upgrader{}
	cond := &sync.Cond{L: &sync.Mutex{}}

	message := "A"
	connections := 0

	http.HandleFunc("/ws", func(res http.ResponseWriter, req *http.Request) {
		socket := must(upgrader.Upgrade(res, req, nil)).(*websocket.Conn)
		connections++
		fmt.Println(connections)
		socket.SetCloseHandler(func(_ int, _ string) error {
			connections--
			return nil
		})

		for { // break if ws connection is interrupted/closed!
			cond.L.Lock()
			cond.Wait()
			err := socket.WriteMessage(websocket.TextMessage, []byte("message: "+message))
			if err != nil {
				websocket.IsCloseError(err)
				cond.L.Unlock()
				break
			}
			cond.L.Unlock()
		}
	})

	go func() {
		interval := time.Second
		for range time.Tick(interval) {
			cond.L.Lock()
			buf := make([]byte, 8)
			rand.Read(buf)
			message = base64.URLEncoding.EncodeToString(buf)
			cond.L.Unlock()
			cond.Broadcast()
			interval = time.Second * time.Duration(rand.Intn(3)+1)
		}
	}()

	must(nil, http.ListenAndServe(":7173", handlers.LoggingHandler(os.Stderr, http.DefaultServeMux)))
}

func must(v any, err error) any {
	if err != nil {
		panic(err)
	}
	return v
}
