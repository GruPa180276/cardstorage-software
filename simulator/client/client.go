package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"time"

	ws "github.com/gorilla/websocket"
)

const apiurl = "https://localhost:7171/api"
const wsurl = "wss://localhost:7171/api"

const usage = `
-1...StorageUnit: Ping
-2...StorageUnit: Focus
-4...StorageUnit: GetUnfocused
0...StorageUnit: Update
1...StorageUnit: New
2...StorageUnit: Delete
3...StorageUnit: GetAll
4...StorageUnit: GetByName
5...Card: New
6...Card: Delete
7...Card: GetAll
8...Card: GetByName
9...Card: Update
-3...Card: Fetch
10...User: New
11...User: Update
12...User: GetAll
13...User: GetByName
14...User: Delete
15...Reservation: GetAll
16...Reservation: GetByCardName
17...Reservation: GetByUserEmail
18...Reservation: New
19...Reservation: Delete
20...Reservation: Update
`

var l = log.New(os.Stderr, "client-simulator: ", log.LstdFlags)

var opts = map[int]func(){
	1: func() {
		location := ""
		name := ""
		addr := ""
		var addrptr *string
		capacity := int(0)
		var capptr *int
		fmt.Print("Location Name Address Capacity: ")
		fmt.Scanln(&location, &name, &addr, &capacity)
		if addr != "" {
			addrptr = &addr
		}
		if capacity != 0 {
			capptr = &capacity
		}
		req := must(http.NewRequest(http.MethodPost, apiurl+"/storages", bytes.NewBuffer(must(json.Marshal(&struct {
			Name      string  `json:"name"`
			Location  string  `json:"location"`
			IpAddress *string `json:"address"`
			Capacity  *int    `json:"capacity"`
		}{
			Location:  location,
			Name:      name,
			IpAddress: addrptr,
			Capacity:  capptr,
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		l.Println(string(must(io.ReadAll(res.Body)).([]byte)))
	},
	7: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	8: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	5: func() {
		name := ""
		storage := ""
		fmt.Print("Name Storage: ")
		fmt.Scanln(&name, &storage)
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/storages/cards", apiurl), bytes.NewBuffer(must(json.Marshal(&struct {
			Name    string `json:"name"`
			Storage string `json:"storage"`
		}{
			Name:    name,
			Storage: storage,
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	3: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	4: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	9: func() {
		type Updater struct {
			Name        *string `json:"name"`
			Position    *int    `json:"position"`
			ReaderData  *string `json:"reader"`
			AccessCount *int    `json:"accessed"`
			Available   *bool   `json:"available"`
		}
		updateCard := ""
		fmt.Print("CardName: ")
		fmt.Scanln(&updateCard)
		name := ""
		pos := ""
		reader := ""
		access := ""
		available := ""
		fmt.Print("(type '$' to leave field unchanged) *Name *Position *Reader *AccessCount *Available: ")
		if _, err := fmt.Scanln(&name, &pos, &reader, &access, &available); err != nil {
			panic(err)
		}
		u := &Updater{}
		if name != "$" {
			u.Name = &name
		}
		if pos != "$" {
			posptr := must(strconv.Atoi(pos)).(int)
			u.Position = &posptr
		}
		if reader != "$" {
			u.ReaderData = &reader
		}
		if access != "$" {
			accptr := must(strconv.Atoi(access)).(int)
			u.AccessCount = &accptr
		}
		if available != "$" {
			availableptr := must(strconv.ParseBool(available)).(bool)
			u.Available = &availableptr
		}
		buf := bytes.NewBuffer(must(json.Marshal(u)).([]byte))
		l.Println(buf.String())
		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/cards/name/%s", apiurl, updateCard), buf)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	0: func() {
		type Updater struct {
			Name     *string `json:"name"`
			Location *string `json:"location"`
			Address  *string `json:"address"`
			Capacity *int    `json:"capacity"`
		}
		updateStorage := ""
		fmt.Print("StorageName: ")
		fmt.Scanln(&updateStorage)
		name := ""
		loc := ""
		addr := ""
		cap := ""
		fmt.Print("(type '$' to leave field unchanged) *Name *Location *Address *Capacity: ")
		if _, err := fmt.Scanln(&name, &loc, &addr, &cap); err != nil {
			panic(err)
		}
		u := &Updater{}
		if name != "$" {
			u.Name = &name
		}
		if loc != "$" {
			u.Location = &loc
		}
		if addr != "$" {
			u.Address = &addr
		}
		if cap != "$" {
			capptr := must(strconv.Atoi(cap)).(int)
			u.Capacity = &capptr
		}
		buf := bytes.NewBuffer(must(json.Marshal(u)).([]byte))
		l.Println(buf.String())
		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/name/%s", apiurl, updateStorage), buf)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	2: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	6: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/cards/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	10: func() {
		email := ""
		storageName := ""
		priv := "$"
		fmt.Print("(type '$' to leave field unchanged) Email Storage *Privileged: ")
		fmt.Scanln(&email, &storageName, &priv)
		var pptr *bool = nil
		if priv != "$" {
			privbool, _ := strconv.ParseBool(priv)
			pptr = &privbool
		}
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/users", apiurl), bytes.NewBuffer(must(json.Marshal(&struct {
			Email      string `json:"email"`
			Storage    string `json:"storage"`
			Privileged *bool  `json:"privileged"`
		}{
			Email:      email,
			Storage:    storageName,
			Privileged: pptr,
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	11: func() {
		type Updater struct {
			Email      *string `json:"email"`
			ReaderData *string `json:"reader"`
			Privilege  *bool   `json:"privileged"`
		}
		updateEmail := ""
		fmt.Print("Email: ")
		fmt.Scanln(&updateEmail)
		email := ""
		reader := ""
		priv := ""
		fmt.Print("(type '$' to leave field unchanged) *Email *Reader *Privileged: ")
		if _, err := fmt.Scanln(&email, &reader, &priv); err != nil {
			panic(err)
		}
		u := &Updater{}
		if email != "$" {
			u.Email = &email
		}
		if reader != "$" {
			u.ReaderData = &reader
		}
		if priv != "$" {
			privptr := must(strconv.ParseBool(priv)).(bool)
			u.Privilege = &privptr
		}
		buf := bytes.NewBuffer(must(json.Marshal(u)).([]byte))
		l.Println(buf.String())
		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/users/email/%s", apiurl, updateEmail), buf)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	12: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	13: func() {
		email := ""
		fmt.Print("Email: ")
		fmt.Scanln(&email)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users/email/%s", apiurl, email), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	14: func() {
		email := ""
		fmt.Print("Email: ")
		fmt.Scanln(&email)
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/users/email/%s", apiurl, email), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	-1: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/ping/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	-2: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/focus/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	15: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/reservations", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	16: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/reservations/card/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	17: func() {
		email := ""
		fmt.Print("Email: ")
		fmt.Scanln(&email)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users/reservations/email/%s", apiurl, email), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	18: func() {
		type Creator struct {
			CardName      string `json:"card"`
			Since         int64  `json:"since"`
			Until         *int64 `json:"until"`
			IsReservation *bool  `json:"is-reservation"`
		}
		email := ""
		cardName := ""
		since := ""
		until := ""
		isReservation := ""
		fmt.Print("(type '%(+offset)' for 'Since' and 'Until' e.g '%+10' in 10min, '%' ... now\ntype '$' to use default value for field)\nEmail CardName Since *Until *IsReservation: ")
		fmt.Scanln(&email, &cardName, &since, &until, &isReservation)
		c := Creator{CardName: cardName}
		var sinceTime time.Time
		var untilTime time.Time
		if since[0] == '%' {
			sinceTime = time.Now()
			if len(since) > 1 {
				if since[1] == '+' {
					sinceTime = sinceTime.Add(must(time.ParseDuration(since[2:] + "m")).(time.Duration))
				}
			}
		} else {
			sinceTime = time.Unix(int64(must(strconv.Atoi(since)).(int)), 0)
		}
		c.Since = sinceTime.Unix()
		if until != "$" {
			if until[0] == '%' {
				untilTime = time.Now()
				if len(until) > 1 {
					if until[1] == '+' {
						untilTime = untilTime.Add(must(time.ParseDuration(until[2:] + "m")).(time.Duration))
					}
				}
			} else {
				untilTime = time.Unix(int64(must(strconv.Atoi(until)).(int)), 0)
			}
			untilptr := untilTime.Unix()
			c.Until = &untilptr
		}
		if isReservation != "$" {
			reservarionFlagPtr := must(strconv.ParseBool(isReservation)).(bool)
			c.IsReservation = &reservarionFlagPtr
		}
		buf := bytes.NewBuffer(must(json.Marshal(c)).([]byte))
		fmt.Println("DEBUG:", buf.String())
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/users/reservations/email/%s", apiurl, email), buf)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	19: func() {
		id := ""
		fmt.Print("Id: ")
		fmt.Scanln(&id)
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/cards/reservations/id/%s", apiurl, id), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	20: func() {
		type Updater struct {
			Until      *int64 `json:"until"`
			ReturnedAt *int64 `json:"returned-at"`
		}

		id := ""
		until := ""
		returnedAt := ""
		fmt.Print("(type '%(+offset)' for 'Since' and 'Until' e.g '%+10' in 10min, '%' ... now)\n(type '$' to leave field unchanged)\nId *Until *ReturnedAt: ")
		fmt.Scanln(&id, &until, &returnedAt)

		u := Updater{}
		if until == "$" && returnedAt == "$" {
			return
		}

		var untilTime time.Time
		var returnedAtTime time.Time
		if until != "$" {
			if until[0] == '%' {
				untilTime = time.Now()
				if len(until) > 1 {
					if until[1] == '+' {
						untilTime = untilTime.Add(must(time.ParseDuration(until[2:] + "m")).(time.Duration))
					}
				}
			} else {
				untilTime = time.Unix(int64(must(strconv.Atoi(until)).(int)), 0)
			}
			untilptr := untilTime.Unix()
			u.Until = &untilptr
		}
		if returnedAt != "$" {
			if returnedAt[0] == '%' {
				returnedAtTime = time.Now()
				if len(returnedAt) > 1 {
					if returnedAt[1] == '+' {
						returnedAtTime = untilTime.Add(must(time.ParseDuration(returnedAt[2:] + "m")).(time.Duration))
					}
				}
			} else {
				returnedAtTime = time.Unix(int64(must(strconv.Atoi(returnedAt)).(int)), 0)
			}
			returnptr := returnedAtTime.Unix()
			u.ReturnedAt = &returnptr
		}

		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/cards/reservations/id/%s", apiurl, id), bytes.NewBuffer(must(json.Marshal(u)).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	-3: func() {
		cardname := ""
		email := "$"
		fmt.Print("(type '$' for 'Email' to simulate card fetch for unknown user)\nCardName *Email: ")
		fmt.Scanln(&cardname, &email)
		urlPath := fmt.Sprintf("%s/storages/cards/name/%s/fetch", apiurl, cardname)
		if email != "$" {
			urlPath += fmt.Sprintf("/user/email/%s", email)
		}
		req := must(http.NewRequest(http.MethodPut, urlPath, nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	-4: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/focus", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
}

func listenOnLoggingWebsockets() {
	logs := []string{
		wsurl + "/controller/log",
		wsurl + "/storages/log",
		wsurl + "/storages/cards/log",
		wsurl + "/reservations/log",
		wsurl + "/users/log",
	}

	done := make([]chan struct{}, len(logs))
	connections := make([]*ws.Conn, 0)

	// allow self-signed ssl certificate
	dialer := *ws.DefaultDialer
	dialer.TLSClientConfig = &tls.Config{InsecureSkipVerify: true}

	for i, url := range logs {
		log.Println("listening for logs on:", url)
		conn, resp, err := dialer.Dial(url, nil)
		if err != nil {
			log.Printf("handshake #%d failed with status %d", i, resp.StatusCode)
			panic(err)
		}

		connections = append(connections, conn)

		go func() {
			defer close(done[i])
			for {
				_, message, err := conn.ReadMessage()
				if err != nil {
					log.Println("ERROR ~> ", err)
					return
				}
				log.Printf("~> %s\n", message)
			}
		}()
	}

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)

	go func() {
		c0done, c1done, c2done, c3done, c4done := false, false, false, false, false
		for !c0done && !c1done && !c2done && !c3done && !c4done {
			select {
			case <-done[0]:
				c0done = true
			case <-done[1]:
				c1done = true
			case <-done[2]:
				c2done = true
			case <-done[3]:
				c3done = true
			case <-done[4]:
				c4done = true
			case <-interrupt:
				for _, conn := range connections {
					must(nil, conn.WriteMessage(ws.CloseMessage, ws.FormatCloseMessage(ws.CloseNormalClosure, "")))
				}
				os.Exit(1)
			}
		}
	}()
}

func main() {
	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}

	listenOnLoggingWebsockets()

	fmt.Print(usage)

	for {
		fmt.Fprint(os.Stderr, `>>> `)
		choice := ""
		fmt.Scanln(&choice)

		id, err := strconv.Atoi(choice)
		if err != nil {
			fmt.Println(usage)
			continue
		}
		if _, ok := opts[id]; !ok {
			continue
		}
		opts[id]()
	}
}

func must(value any, err error) any {
	if err != nil {
		panic(err)
	}
	return value
}
