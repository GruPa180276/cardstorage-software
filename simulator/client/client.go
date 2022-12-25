package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

const url = "http://127.0.0.1:7171/api"

const usage = `
1...StorageUnit: New
2...StorageUnit: Delete
3...StorageUnit: GetAll
4...StorageUnit: GetByName
5...Card: New
6...Card: Delete
7...Card: GetAll
8...Card: GetByName
`

var l = log.New(os.Stderr, "client-simulator: ", log.LstdFlags)

var opts = map[int]func(){
	1: func() {
		location := ""
		name := ""
		ipaddr := ""
		capacity := int(0)
		fmt.Print("Location Name IpAddress Capacity: ")
		fmt.Scanln(&location, &name, &ipaddr, &capacity)
		req := must(http.NewRequest(http.MethodPost, url+"/storage-units", bytes.NewBuffer(must(json.Marshal(&struct {
			Location  string `json:"location"`
			Name      string `json:"name"`
			IpAddress string `json:"ip-address"`
			Capacity  int    `json:"capacity"`
		}{
			Location:  location,
			Name:      name,
			IpAddress: ipaddr,
			Capacity:  capacity,
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		l.Println(string(must(io.ReadAll(res.Body)).([]byte)))
	},
}

func main() {
	i := int(0)

	for {
		fmt.Fprint(os.Stderr, usage+`>>> `)
		i = 0
		fmt.Scanln(&i)

		if _, ok := opts[i]; !ok {
			continue
		}
		opts[i]()
	}
}

func must(value any, err error) any {
	if err != nil {
		panic(err)
	}
	return value
}
