package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	mqttclient "github.com/eclipse/paho.mqtt.golang"
	_ "github.com/go-sql-driver/mysql"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/response"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"log"
	"net/http"
	"os"
	"time"
)

func main() {
	os.Chdir("api")

	if err := godotenv.Load(); err != nil {
		log.Fatalln(err)
	}

	sitemap := &util.Sitemap{Router: mux.NewRouter(), Sitemap: make(map[*json.RawMessage]*mux.Route)}
	logger := log.New(os.Stderr, "API: ", log.LstdFlags|log.Lshortfile)

	mqc := mqttclient.NewClient(mqttclient.NewClientOptions().
		SetClientID("CSManagementController").
		AddBroker("tcp://localhost:1883"))
	mqc.Connect().Wait()

	time.Sleep(500 * time.Millisecond)

	connstring := fmt.Sprintf("%s:%s@/%s",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWD"),
		os.Getenv("DB_NAME"))

	db := util.Must(sql.Open(os.Getenv("DB_DRIVER"), connstring)).(*sql.DB)
	messages := make(map[uuid.UUID]*response.ObserverResult)

	o := response.Observer{mqc, logger, db, messages}
	o.Observe()

	u := response.User{DB: db, Logger: logger}
	c := response.Card{DB: db, Logger: logger, Client: mqc, Messages: messages}
	t := response.CardStatus{DB: db, Logger: logger}
	l := response.Location{DB: db, Logger: logger}
	s := response.StorageUnit{DB: db, Logger: logger}

	sitemap = sitemap.
		AddHandler(http.MethodGet, util.API_USERS, u.GetAllUsersHandler).
		AddHandler(http.MethodGet, util.API_USERS_FILTER_ID, u.GetUserByIdHandler).
		AddHandler(http.MethodGet, util.API_USERS_FILTER_EMAIL, u.GetUserByEmailHandler).
		AddHandler(http.MethodGet, util.API_USERS_FILTER_READER, u.GetUserByReaderDataHandler).
		AddHandler(http.MethodPost, util.API_USERS_SIGN_UP, u.SignUpHandler).
		AddHandler(http.MethodGet, util.API_CARDS, c.GetAllCardsHandler).
		AddHandler(http.MethodPost, util.API_CARDS, c.AddNewCardHandler).
		AddHandler(http.MethodGet, util.API_CARDS_FILTER_ID, c.GetCardByIdHandler). // @todo
		AddHandler(http.MethodGet, util.API_CARDS_FILTER_NAME, c.GetCardByNameHandler). // @todo
		AddHandler(http.MethodGet, util.API_CARDS_STATUS, t.GetAllCardsStatusHandler).
		AddHandler(http.MethodGet, util.API_CARDS_STATUS_FILTER_ID, t.GetCardStatusByCardIdHandler).
		AddHandler(http.MethodPut, util.API_CARDS_STATUS, t.PutCardStatusByCardIdHandler). // @todo

		AddHandler(http.MethodGet, util.API_LOCATIONS, l.GetAllLocationsHandler).
		AddHandler(http.MethodGet, util.API_LOCATIONS_FILTER_ID, l.GetLocationByIdHandler).
		AddHandler(http.MethodGet, util.API_LOCATIONS_FILTER_NAME, l.GetLocationByNameHandler).
		AddHandler(http.MethodPost, util.API_LOCATIONS, l.AddNewLocationHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS, s.GetAllStorageUnitsHandler).
		AddHandler(http.MethodPost, util.API_STORAGEUNITS, s.AddNewStorageUnitHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS_FILTER_ID, s.GetStorageUnitByIdHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS_FILTER_NAME, s.GetStorageUnitByNameHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS_PING_FILTER_ID, s.PingStorageUnitByIdHandler) // @todo

	logger.Println(connstring)

	bytes := util.Must(json.MarshalIndent(util.Keys(sitemap.Sitemap), "", "\t")).([]byte)
	file := util.Must(os.Create("sitemap.json")).(*os.File)
	file.Write(bytes)
	file.Close()

	logger.Println(http.ListenAndServe("localhost:7171", sitemap.Router))
}
