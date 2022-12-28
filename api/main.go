package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"net/url"
	"os"
	"sync"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/observer"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/response"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func init() {
	rand.Seed(time.Now().Unix())
}

func main() {
	router := mux.NewRouter().
		PathPrefix("/api").
		HeadersRegexp("Content-Type", "(application|text)/json").
		Subrouter()

	logger := log.New(os.Stderr, "API: ", log.LstdFlags|log.Lshortfile)

	connstring := fmt.Sprintf("tcp://%s:%s", os.Getenv("BROKER_HOSTNAME"), os.Getenv("BROKER_PORT"))
	mqc := mqtt.NewClient(mqtt.NewClientOptions().
		SetClientID(fmt.Sprintf("CSMC-%d", time.Now().Unix())).
		AddBroker(connstring))
	connect_token := mqc.Connect()
	<-connect_token.Done()
	util.Must(nil, connect_token.Error())

	connstring = fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWD"),
		os.Getenv("DB_HOSTNAME"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"))
	db := util.Must(gorm.Open(mysql.Open(connstring), &gorm.Config{})).(*gorm.DB)
	util.Must(nil, db.AutoMigrate(&model.Card{}, &model.Reservation{}, &model.Storage{}, &model.User{}))

	infoChannel := make(chan string)
	upgrader := &websocket.Upgrader{CheckOrigin: func(r *http.Request) bool { return true }}

	util.Must(nil, (&observer.Observer{Client: mqc, Logger: logger, DB: db, Map: &sync.Map{}, ControllerInfoChannel: infoChannel}).Observe())
	(&controller.Controller{Logger: logger, Upgrader: upgrader, ControllerInfoChannel: infoChannel}).RegisterHandlers(router)

	store := &response.DataStore{Logger: logger, DB: db}

	(*response.CardDataStore)(store).RegisterHandlers(router)
	(*response.StorageDataStore)(store).RegisterHandlers(router)
	(*response.UserDataStore)(store).RegisterHandlers(router)
	(*response.ReservationDataStore)(store).RegisterHandlers(router)

	go func() {
		routes := make([]mux.Route, 0)
		util.Must(nil, router.Walk(func(route *mux.Route, router *mux.Router, ancestors []*mux.Route) error {
			routes = append(routes, *route)
			return nil
		}))
		sitemap := make(map[string][]string)
		sitemap[http.MethodGet] = []string{}
		sitemap[http.MethodPut] = []string{}
		sitemap[http.MethodPost] = []string{}
		sitemap[http.MethodDelete] = []string{}
		for _, r := range routes {
			url := util.Must(r.URL("name", "NAME", "email", "USER@PROVIDER.COM", "id", "000")).(*url.URL)
			methods := util.Must(r.GetMethods()).([]string)
			for _, m := range methods {
				sitemap[m] = append(sitemap[m], url.String())
			}
		}
		util.Must(nil, ioutil.WriteFile("sitemap.json", util.Must(json.MarshalIndent(sitemap, "", "\t")).([]byte), 0777))
	}()

	go func() {
		buffer := util.Must(json.MarshalIndent(json.RawMessage(util.Must(controller.ActionsToJSON()).([]byte)), "", "\t")).([]byte)
		file := util.Must(os.Create("actions.json")).(*os.File)
		util.Must(file.Write(buffer))
		util.Must(nil, file.Close())
	}()

	logger.Println("Initialization done...")

	headersOk := handlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type", "Authorization"})
	originsOk := handlers.AllowedOrigins([]string{"*"})
	methodsOk := handlers.AllowedMethods([]string{"GET", "HEAD", "POST", "PUT"})
	logger.Println(http.ListenAndServe(fmt.Sprintf(":%s", os.Getenv("REST_PORT")),
		handlers.LoggingHandler(logger.Writer(),
			handlers.CORS(originsOk, headersOk, methodsOk)(router))))
}
