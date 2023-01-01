package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path"
	"reflect"
	"strconv"
	"strings"
	"time"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

const apiurl = "https://localhost:7171/api"
const wsurl = "wss://localhost:7171/api"

var l = log.New(os.Stderr, "client-simulator: ", log.LstdFlags)

var opts = map[string]interface{}{
	"POST;loc,name,ipaddr,capacity;StorageUnit: New": func(location, name, ipaddr, capacity string) {
		req := must(http.NewRequest(http.MethodPost, apiurl+"/storages", bytes.NewBuffer(must(json.Marshal(&struct {
			Name      string `json:"name"`
			Location  string `json:"location"`
			IpAddress string `json:"address"`
			Capacity  int    `json:"capacity"`
		}{
			Location:  location,
			Name:      name,
			IpAddress: ipaddr,
			Capacity:  must(strconv.Atoi(capacity)).(int),
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		l.Println(string(must(io.ReadAll(res.Body)).([]byte)))
	},
	"GET;;Card: GetAll": func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;name;Card: GetByName": func(name string) {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"POST;cardname,storagename$str;Card: New": func(cardname, storagename string) {
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/storages/cards", apiurl), bytes.NewBuffer(must(json.Marshal(&struct {
			Name    string `json:"name"`
			Storage string `json:"storage"`
		}{
			Name:    cardname,
			Storage: storagename,
		})).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;;StorageUnit: GetAll": func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;storagename;StorageUnit: GetByName": func(storagename string) {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/name/%s", apiurl, storagename), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	// "(type '$' to leave field unchanged) *Name *Position *Reader *AccessCount *Available: "
	"PUT;updateCard,*name,*pos,*reader,*access,*available;Card: Update": func(updateCard, name, pos, reader, access, available string) {
		type Updater struct {
			Name        *string `json:"name"`
			Position    *int    `json:"position"`
			ReaderData  *string `json:"reader"`
			AccessCount *int    `json:"accessed"`
			Available   *bool   `json:"available"`
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
	// "(type '$' to leave field unchanged) *Name *Location *Address *Capacity: "
	"PUT;updateStorage,*name,*loc,*addr,*cap;StorageUnit: Update": func(updateStorage, name, loc, addr, cap string) {
		type Updater struct {
			Name     *string `json:"name"`
			Location *string `json:"location"`
			Address  *string `json:"address"`
			Capacity *int    `json:"capacity"`
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
	"DELETE;storagename;StorageUnit: Delete": func(name string) {
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"DELETE;cardname;Card: Delete": func(name string) {
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/cards/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"POST;email;User: New": func(email string) {
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/users", apiurl), bytes.NewBuffer(must(json.Marshal(&struct {
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
	// "(type '$' to leave field unchanged) *Email *Reader *Privilege: "
	"PUT;updateEmail,*email,*reader,*priv;User: Update": func(updateEmail, email, reader, priv string) {
		type Updater struct {
			Email      *string `json:"email"`
			ReaderData *string `json:"reader"`
			Privilege  *bool   `json:"privilege"`
		}
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
	"GET;;User: GetAll": func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;email;User: GetByEmail": func(email string) {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users/email/%s", apiurl, email), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"DELETE;email;User: Delete": func(email string) {
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/users/email/%s", apiurl, email), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;name;StorageUnit: Ping": func(name string) {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/ping/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;name;StorageUnit: Focus": func(name string) {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/focus/name/%s", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;Reservation: GetAll": func() {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/reservations`", apiurl), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;name;Reservation: GetByCardName": func(name string) {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/storages/cards/reservations/name/%s`", apiurl, name), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"GET;email;Reservation: GetByUserEmail": func(email string) {
		req := must(http.NewRequest(http.MethodGet, fmt.Sprintf("%s/users/reservations/name/%s`", apiurl, email), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	// "(type '%(+offset)' for 'Since' and 'Until' e.g '%+10' in 10min, '%' ... now)"
	// "(type '$' to use default value for field)"
	// "Email CardName Since *Until *IsReservation: "
	"POST;email,*cardName,*since,*until,*isReservation;Reservation: New": func(email, cardName, since, until, isReservation string) {
		type Creator struct {
			CardName      string `json:"card"`
			Since         int64  `json:"since"`
			Until         *int64 `json:"until"`
			IsReservation *bool  `json:"is-reservation"`
		}
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
		req := must(http.NewRequest(http.MethodPost, fmt.Sprintf("%s/users/reservations/name/%s`", apiurl, email), bytes.NewBuffer(must(json.Marshal(c)).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	"DELETE;id;Reservation: Delete": func(id string) {
		req := must(http.NewRequest(http.MethodDelete, fmt.Sprintf("%s/storages/cards/reservations/id/%s", apiurl, id), nil)).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
	// "(type '%(+offset)' for 'Since' and 'Until' e.g '%+10' in 10min, '%' ... now)"
	// "(type '$' to leave field unchanged)" +
	// "Id *Until *ReturnedAt: "
	"PUT;id,*until,*returnedAt;Reservation: Update": func(id, until, returnedAt string) {
		type Updater struct {
			Until      *int64 `json:"until"`
			ReturnedAt *int64 `json:"returned-at"`
		}
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

		req := must(http.NewRequest(http.MethodPut, fmt.Sprintf("%s/storages/cards/reservations/id/%s", apiurl, id), bytes.NewBuffer(must(json.Marshal(u)).([]byte)))).(*http.Request)
		res := must(new(http.Client).Do(req)).(*http.Response)
		l.Println(res.Status)
		s := bytes.NewBufferString("{}")
		must(nil, json.Indent(s, must(io.ReadAll(res.Body)).([]byte), "", "  "))
		l.Println(s.String())
	},
}

func main() {
	router := mux.NewRouter()
	apirouter := router.PathPrefix("/sim/api").Subrouter()
	logger := log.New(os.Stderr, os.Getenv("SIM_CLIENT_NAME")+": ", log.LstdFlags|log.Lshortfile)

	router.HandleFunc("/", func(res http.ResponseWriter, req *http.Request) {

	})

	router.HandleFunc("/{target:.+}", func(res http.ResponseWriter, req *http.Request) {
		target := path.Join("public", mux.Vars(req)["target"])

		if _, err := os.Stat(target); err != nil {
			code := http.StatusBadRequest

			if errors.Is(err, os.ErrNotExist) {
				code = http.StatusNotFound
			}

			http.Error(res, err.Error(), code)
			logger.Println(err.Error())
			return
		}

		res.WriteHeader(http.StatusOK)
		res.Write(must(os.ReadFile(target)).([]byte))
	})

	for k, v := range opts {
		fields := strings.Split(k, ";")
		method, params, name := fields[0], fields[1], fields[2]
		nameFields := strings.Split(name, ":")
		target, operation := strings.TrimSpace(nameFields[0]), strings.TrimSpace(nameFields[1])

		var reflectKey reflect.Value
		for _, rkey := range reflect.ValueOf(opts).MapKeys() {
			if rkey.String() == k {
				reflectKey = rkey
			}
		}

		apirouter.HandleFunc(fmt.Sprintf("%s%s", target, operation), func(res http.ResponseWriter, req *http.Request) {
			paramsListKeys := strings.Split(params, ",")
			paramsListValues := make([]string, len(paramsListKeys))

			for idx, key := range paramsListKeys {
				if !req.URL.Query().Has(key) {
					paramsListValues[idx] = "$"
					continue
				}
				paramsListValues[idx] = req.URL.Query().Get(key)
			}

			reflectParamsListValues := make([]reflect.Value, len(paramsListValues))
			for idx, _ := range paramsListValues {
				reflectParamsListValues = append(reflectParamsListValues, reflect.ValueOf(paramsListValues).Slice(idx, idx))
			}

			reflect.ValueOf(opts).MapIndex(reflectKey).Call(reflectParamsListValues)

		}).Methods(method)
	}

	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}
	logger.Fatalln(http.ListenAndServeTLS(fmt.Sprintf(":%s", os.Getenv("SIM_CLIENT_PORT")),
		"localhost.crt", "localhost.key", handlers.LoggingHandler(logger.Writer(), router)))
}

func must(value any, err error) any {
	if err != nil {
		panic(err)
	}
	return value
}
