package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
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
9...Location: New
10...Location: Delete
11...Location: GetAll
12...Location: GetByName
`

var l = log.New(os.Stderr, "client-simulator: ", log.LstdFlags)

var opts = map[int]func(){
	1: func() {
		locid := int(0)
		name := ""
		ipaddr := ""
		capacity := int(0)
		fmt.Print("LocationId Name IpAddress Capacity: ")
		fmt.Scanln(&locid, &name, &ipaddr, &capacity)
		req := must(http.NewRequest(http.MethodPost, url+"/storage-units", bytes.NewBuffer(must(json.Marshal(&struct {
			LocationId int    `json:"location-id"`
			Name       string `json:"name"`
			IpAddress  string `json:"ip-address"`
			Capacity   int    `json:"capacity"`
		}{
			LocationId: locid,
			Name:       name,
			IpAddress:  ipaddr,
			Capacity:   capacity,
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		l.Println(string(must(io.ReadAll(res.Body)).([]byte)))
	},
	9: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodPost, url+"/locations", bytes.NewBuffer(must(json.Marshal(&struct {
			Location string `json:"location"`
		}{
			Location: name,
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		l.Println(strings.Trim(string(must(io.ReadAll(res.Body)).([]byte)), "\r\n "))
	},
	11: func() {
		req := must(http.NewRequest(http.MethodGet, url+"/locations", nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		buf := bytes.NewBuffer(make([]byte, 0))
		json.Indent(buf, must(io.ReadAll(res.Body)).([]byte), "", "  ")
		l.Println(strings.TrimRight(buf.String(), "\r\n "))
	},
	12: func() {

	},
}

func main() {
	i := int(0)

	for {
		fmt.Fprint(os.Stderr, usage, `>> `)
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
