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
	wg := &sync.WaitGroup{}
	lock := &sync.Mutex{}

	message := "A"
	connections := 0

	http.HandleFunc("/ws", func(res http.ResponseWriter, req *http.Request) {
		socket := Must(upgrader.Upgrade(res, req, nil)).(*websocket.Conn)
		lock.Lock()
		connections++
		lock.Unlock()

		go func() { // break if the there was an error while reading or if the client closed the connection
			wg.Add(1)
			for {
				if _, _, err := socket.ReadMessage(); err != nil {
					lock.Lock()
					connections--
					lock.Unlock()
					return
				}
			}
		}()

		for { // break if there was an error while writing
			cond.L.Lock()
			cond.Wait()
			err := socket.WriteMessage(websocket.TextMessage, []byte("message: "+message))
			if err != nil {
				websocket.IsCloseError(err)
				cond.L.Unlock()
				wg.Done()
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
			fmt.Println(connections)
		}
	}()

	Must(nil, http.ListenAndServe(":7173", handlers.LoggingHandler(os.Stderr, http.DefaultServeMux)))
}
