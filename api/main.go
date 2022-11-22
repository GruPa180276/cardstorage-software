package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	mqttclient "github.com/eclipse/paho.mqtt.golang"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/response"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	mqttserver "github.com/mochi-co/mqtt/server"
	"github.com/mochi-co/mqtt/server/listeners"
	"github.com/mochi-co/mqtt/server/listeners/auth"
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

	sitemap := make(map[string]*mux.Route)

	logger := log.New(os.Stderr, "API: ", log.LstdFlags|log.Lshortfile)

	router := mux.NewRouter()

	mqs := mqttserver.NewServer(nil)
	mqs.AddListener(listeners.NewTCP("t1", "localhost:1883"), &listeners.Config{Auth: new(auth.Allow)})
	go func() {
		if err := mqs.Serve(); err != nil {
			logger.Println("MQTT Error: " + err.Error())
		}
	}()

	mqc := mqttclient.NewClient(mqttclient.NewClientOptions().
		SetClientID("CardStorageManagementController").
		AddBroker("tcp://localhost:1883"))
	mqc.Connect().Wait()
	// mqc.Publish("top/1", 1, true, []byte("hello from the controller!")).Wait()

	connstring := fmt.Sprintf("%s:%s@/%s", os.Getenv("DB_USER"), os.Getenv("DB_PASSWD"), os.Getenv("DB_NAME"))
	db := util.Must(sql.Open(os.Getenv("DB_DRIVER"), connstring)).(*sql.DB)

	o := response.Observer{mqc, logger, db}
	time.Sleep(1 * time.Second)
	o.Observe()

	sitemap["GET/"] = router.HandleFunc("/", func(res http.ResponseWriter, req *http.Request) {
		response.Json(&res, http.StatusOK, "Nothing to see here yet!")
	}).Methods("GET")

	sitemap["GET/api"] = router.HandleFunc("/api", func(res http.ResponseWriter, req *http.Request) {
		response.Json(&res, http.StatusOK, "Nothing to see here yet!")
	}).Methods("GET")

	u := response.User{db, logger}
	sitemap["GET/api/users"] =
		router.HandleFunc("/api/users", u.GetAllUsersHandler).Methods("GET")
	sitemap["POST/api/users/sign-up"] =
		router.HandleFunc("/api/users/sign-up", u.SignUpHandler).Methods("POST")
	sitemap["GET/api/users/id/{id:[0-9]{1,10}}"] =
		router.HandleFunc("/api/users/id/{id:[0-9]{1,10}}", u.GetUserByIdHandler).Methods("GET")
	sitemap["GET/api/users/email/{email:[a-zA-Z0-9.@-_]{5,100}}"] =
		router.HandleFunc("/api/users/email/{email:[a-zA-Z0-9.@-_]{5,100}}", u.GetUserByEmailHandler).Methods("GET")
	sitemap["GET/api/users/reader/{reader:[a-zA-Z0-9-_]{5,100}}"] =
		router.HandleFunc("/api/users/reader/{reader:[a-zA-Z0-9-_]{5,100}}", u.GetUserByReaderDataHandler).Methods("GET")

	c := response.Card{DB: db, Logger: logger, Client: mqc, Messages: make([]response.Message, 0)}
	sitemap["GET/api/cards"] =
		router.HandleFunc("/api/cards", c.GetAllCardsHandler).Methods("GET")
	sitemap["POST/api/cards"] =
		router.HandleFunc("/api/cards", c.AddNewCardHandler).Methods("POST")

	l := response.Location{db, logger}
	sitemap["GET/api/locations"] =
		router.HandleFunc("/api/locations", l.GetAllLocationsHandler).Methods("GET")
	sitemap["POST/api/locations"] =
		router.HandleFunc("/api/locations", l.AddNewLocationHandler).Methods("POST")
	sitemap["GET/api/locations/id/{id:[0-9]{1,10}}"] =
		router.HandleFunc("/api/locations/id/{id:[0-9]{1,10}}", l.GetLocationByIdHandler).Methods("GET")
	sitemap["GET/api/locations/name/{name:[a-zA-Z0-9-_]{3, 100}}"] =
		router.HandleFunc("/api/locations/name/{name:[a-zA-Z0-9-_]{3,100}}", l.GetLocationByNameHandler).Methods("GET")

	s := response.StorageUnit{db, logger}
	sitemap["GET/api/storage-units"] =
		router.HandleFunc("/api/storage-units", s.GetAllStorageUnitsHandler).Methods("GET")
	sitemap["POST/api/storage-units"] =
		router.HandleFunc("/api/storage-units", s.AddNewStorageUnitHandler).Methods("POST")
	sitemap["GET/api/storage-units/id/{id:[0-9]{1,10}}"] =
		router.HandleFunc("/api/storage-units/id/{id:[0-9]{1,10}}", s.GetStorageUnitByIdHandler).Methods("GET")
	sitemap["GET/api/storage-units/name/{name:[a-zA-Z0-9-_]{3, 100}}"] =
		router.HandleFunc("/api/storage-units/name/{name:[a-zA-Z0-9-_]{3,100}}", s.GetStorageUnitByNameHandler).Methods("GET")
	// @todo: ping storage-unit by id
	sitemap["GET/api/storage-units/ping/id/{id:[0-9]{1,10}}"] =
		router.HandleFunc("/api/storage-units/ping/id/{id:[0-9]{1,10}}", s.PingStorageUnitById).Methods("GET")

	logger.Println(connstring)

	bytes := util.Must(json.MarshalIndent(util.Keys(sitemap), "", "\t")).([]byte)
	file := util.Must(os.Create("sitemap.json")).(*os.File)
	file.Write(bytes)
	file.Close()

	if err := http.ListenAndServe("localhost:7171", router); err != nil {
		logger.Println(err)
		recover()
	}
}
