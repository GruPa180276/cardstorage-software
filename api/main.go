package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/response"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func main() {
	router := mux.NewRouter().PathPrefix("/api").Subrouter()
	router.Headers(
		"Accept", "application/json",
		"Accept-Charset", "utf-8",
		"Server", fmt.Sprintf("card-management@%s", runtime.Version()))

	logger := log.New(os.Stderr, "API: ", log.LstdFlags|log.Lshortfile)

	connstring := fmt.Sprintf("tcp://%s:%s", os.Getenv("BROKER_HOSTNAME"), os.Getenv("BROKER_PORT"))
	logger.Println(connstring)
	mqc := mqtt.NewClient(mqtt.NewClientOptions().
		SetClientID(fmt.Sprintf("CSMC-%d", time.Now().Unix())).
		AddBroker(connstring))
	<-mqc.Connect().Done()

	connstring = fmt.Sprintf("%s:%s@tcp(%s:%s)/%s",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWD"),
		os.Getenv("DB_HOSTNAME"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"))
	logger.Println(connstring)
	db := util.Must(gorm.Open(mysql.Open(connstring), &gorm.Config{})).(*gorm.DB)
	util.Must(nil, db.AutoMigrate(&model.Card{}, &model.Reservation{}, &model.Storage{}, &model.User{}))

	// messages := new(sync.Map)
	// (&observer.Observer{Client: mqc, Logger: logger, DB: db, Map: messages}).Observe()

	store := &response.DataStore{Logger: logger, DB: db}

	(*response.CardDataStore)(store).RegisterHandlers(router)
	(*response.StorageDataStore)(store).RegisterHandlers(router)
	(*response.UserDataStore)(store).RegisterHandlers(router)
	(*response.ReservationDataStore)(store).RegisterHandlers(router)

	// @todo: router.Walk(...)
	//sitemap := &util.Sitemap{Router: router, Sitemap: make(map[*json.RawMessage]http.Handler)}
	//go func() {
	//	keys := util.MapSlice[*json.RawMessage, *json.RawMessage](util.Keys(sitemap.Sitemap), func(path *json.RawMessage) *json.RawMessage {
	//		p := make(map[string]any)
	//		util.Must(nil, json.Unmarshal(*path, &p))
	//		p["path"] = prefix + p["path"].(string)
	//		buf := json.RawMessage(util.Must(json.Marshal(&p)).([]byte))
	//		return &buf
	//	})
	//	buffer := util.Must(json.MarshalIndent(keys, "", "\t")).([]byte)
	//	file := util.Must(os.Create("sitemap.json")).(*os.File)
	//	util.Must(file.Write(buffer))
	//	util.Must(nil, file.Close())
	//}()

	go func() {
		buffer := util.Must(json.MarshalIndent(json.RawMessage(util.Must(controller.ActionsToJSON()).([]byte)), "", "\t")).([]byte)
		file := util.Must(os.Create("actions.json")).(*os.File)
		util.Must(file.Write(buffer))
		util.Must(nil, file.Close())
	}()

	logger.Println("Initialization done...")

	logger.Println(http.ListenAndServe(":"+os.Getenv("REST_PORT"), handlers.LoggingHandler(logger.Writer(), router)))
}
