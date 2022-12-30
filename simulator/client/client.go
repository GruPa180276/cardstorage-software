package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

const url = "http://127.0.0.1:7171/api"

const usage = `
-1...StorageUnit: Ping
-2...StorageUnit: Focus
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
		ipaddr := ""
		capacity := int(0)
		fmt.Print("Location Name Address Capacity: ")
		fmt.Scanln(&location, &name, &ipaddr, &capacity)
		req := must(http.NewRequest(http.MethodPost, url+"/storages", bytes.NewBuffer(must(json.Marshal(&struct {
			Name      string `json:"name"`
			Location  string `json:"location"`
			IpAddress string `json:"address"`
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
	7: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards", url), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/name/%s", url, name), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/storages/cards", url), bytes.NewBuffer(must(json.Marshal(&struct {
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
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages", url), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/name/%s", url, name), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/cards/name/%s", url, updateCard), buf)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/name/%s", url, updateStorage), buf)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/name/%s", url, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	6: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/cards/name/%s", url, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	10: func() {
		email := ""
		fmt.Print("Email: ")
		fmt.Scanln(&email)
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/users", url), bytes.NewBuffer(must(json.Marshal(&struct {
			Email string `json:"email"`
		}{
			Email: email,
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
			Privilege  *bool   `json:"privilege"`
		}
		updateEmail := ""
		fmt.Print("Email: ")
		fmt.Scanln(&updateEmail)
		email := ""
		reader := ""
		priv := ""
		fmt.Print("(type '$' to leave field unchanged) *Email *Reader *Privilege: ")
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
		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/users/email/%s", url, updateEmail), buf)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	12: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users", url), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users/email/%s", url, email), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/users/email/%s", url, email), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	-1: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/ping/name/%s", url, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	-2: func() {
		name := ""
		fmt.Print("Name: ")
		fmt.Scanln(&name)
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/focus/name/%s", url, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	15: func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/reservations`", url), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/reservations/name/%s`", url, name), nil)).(*http.Request)
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
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users/reservations/name/%s`", url, email), nil)).(*http.Request)
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
		} else if since[1] == '+' {
			sinceTime = sinceTime.Add(must(time.ParseDuration(since[2:] + "m")).(time.Duration))
		} else {
			sinceTime = time.Unix(int64(must(strconv.Atoi(since)).(int)), 0)
		}
		c.Since = sinceTime.Unix()
		if until != "$" {
			if until[0] == '%' {
				untilTime = time.Now()
			} else if until[1] == '+' {
				untilTime = untilTime.Add(must(time.ParseDuration(until[2:] + "m")).(time.Duration))
			} else {
				untilTime = time.Unix(int64(must(strconv.Atoi(until)).(int)), 0)
			}
			*c.Until = untilTime.Unix()
		}
		if isReservation != "$" {
			*c.IsReservation = must(strconv.ParseBool(isReservation)).(bool)
		}
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/users/reservations/name/%s`", url, email), bytes.NewBuffer(must(json.Marshal(c)).([]byte)))).(*http.Request)
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
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/cards/reservations/id/%s", url, id), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
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
			} else if until[1] == '+' {
				untilTime = untilTime.Add(must(time.ParseDuration(until[2:] + "m")).(time.Duration))
			} else {
				untilTime = time.Unix(int64(must(strconv.Atoi(until)).(int)), 0)
			}
			*u.Until = untilTime.Unix()
		}
		if returnedAt != "$" {
			if returnedAt[0] == '%' {
				returnedAtTime = time.Now()
			} else if returnedAt[1] == '+' {
				returnedAtTime = untilTime.Add(must(time.ParseDuration(returnedAt[2:] + "m")).(time.Duration))
			} else {
				returnedAtTime = time.Unix(int64(must(strconv.Atoi(returnedAt)).(int)), 0)
			}
			*u.ReturnedAt = returnedAtTime.Unix()
		}

		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/cards/reservations/id/%s", url, id), bytes.NewBuffer(must(json.Marshal(u)).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
}

func main() {

	fmt.Println(usage)

	for {
		fmt.Fprint(os.Stderr, ` >>> `)
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
