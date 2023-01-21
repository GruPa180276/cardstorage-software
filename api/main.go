package main

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
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

func connectToBroker(ct *controller.Controller, hostname, port, clientId string) (mqtt.Client, chan<- bool) {
	connstring := fmt.Sprintf("tcp://%s:%s", hostname, port)
	opts := mqtt.NewClientOptions().
		SetClientID(clientId).
		AddBroker(connstring).
		SetOrderMatters(true).
		SetAutoReconnect(true).
		SetUsername(os.Getenv("BROKER_USERNAME")).
		SetPassword(os.Getenv("BROKER_PASSWD"))
	mqc := mqtt.NewClient(opts)
	if token := mqc.Connect(); token.Wait() && token.Error() != nil {
		ct.Logger.Println("error while trying to connect to broker:", token.Error())
	}

	mqtt.CRITICAL = log.New(ct.Logger.Writer(), "[mqtt.CRITICAL]: ", log.LstdFlags)
	mqtt.WARN = log.New(ct.Logger.Writer(), "[  mqtt.WARN  ]: ", log.LstdFlags)
	mqtt.ERROR = log.New(ct.Logger.Writer(), "[  mqtt.ERROR ]: ", log.LstdFlags)
	// mqtt.DEBUG = log.New(ct.Logger.Writer(), "[  mqtt.DEBUG ]: ", log.LstdFlags)

	disconnectChannel := make(chan bool)

	go func() {
		for {
			for mqc.IsConnected() {
			}
			disconnectChannel <- true
			ct.Logger.Println("lost broker: reconnecting...")
			if token := mqc.Connect(); token.Wait() && token.Error() != nil {
				ct.Logger.Println("error while connecting to broker (trying again...):", token.Error())
				continue
			}

			storages := make([]model.Storage, 0)
			if err := ct.DB.Find(storages).Error; err != nil {
				ct.Logger.Println(err)
			}
			for _, s := range storages {
				mqc.Subscribe(util.AssembleBaseStorageTopic(s.Name, s.Location), 2, observer.GetObserverHandler(ct))
			}
		}
	}()

	return mqc, disconnectChannel
}

func connectToDatabase(user, passwd, hostname, port, dbname string) *gorm.DB {
	connstring := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", user, passwd, hostname, port, dbname)
	db := util.Must(gorm.Open(mysql.Open(connstring), &gorm.Config{})).(*gorm.DB)
	util.Must(nil, db.AutoMigrate(&model.Card{}, &model.Reservation{}, &model.Storage{}, &model.User{}))
	return db
}

func createRouter() *mux.Router {
	return mux.NewRouter().
		PathPrefix("/api").
		// HeadersRegexp("Content-Type", "(application|text)/json").
		Subrouter()
}

func createSitemap(router *mux.Router) {
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
		url_ := util.Must(r.URL("name", "NAME", "email", "USER@PROVIDER.COM", "id", "000", "flag", "true", "hours", "1234")).(*url.URL)
		methods := util.Must(r.GetMethods()).([]string)
		for _, m := range methods {
			sitemap[m] = append(sitemap[m], url_.String())
		}
	}
	util.Must(nil, ioutil.WriteFile("sitemap.json", util.Must(json.MarshalIndent(sitemap, "", "\t")).([]byte), 0777))
}

func createActionIndex(filename string) {
	buffer := util.Must(json.MarshalIndent(json.RawMessage(util.Must(controller.ActionsToJSON()).([]byte)), "", "\t")).([]byte)
	file := util.Must(os.Create(filename)).(*os.File)
	util.Must(file.Write(buffer))
	util.Must(nil, file.Close())
}

func initController(clientId string, db *gorm.DB, logger *log.Logger) *controller.Controller {
	m := &sync.Map{}
	upgrader := &websocket.Upgrader{CheckOrigin: func(r *http.Request) bool { return true }}
	c := &controller.Controller{Logger: logger, Upgrader: upgrader, DB: db, Map: m, ClientId: clientId}
	mqc, _ := connectToBroker(c, os.Getenv("BROKER_HOSTNAME"), os.Getenv("BROKER_PORT"), clientId)
	c.Client = mqc
	return c
}

func initHandlers(router *mux.Router, c *controller.Controller, chans *map[string]chan string) {
	c.ControllerLogChannel = (*chans)["controller"]
	c.Cond = &sync.Cond{L: &sync.Mutex{}}
	c.RegisterHandlers(router)
	(&response.CardHandler{Controller: c, CardLogChannel: (*chans)["card"], Cond: &sync.Cond{L: &sync.Mutex{}}}).RegisterHandlers(router)
	(&response.StorageHandler{Controller: c, StorageLogChannel: (*chans)["storage"], Locker: &sync.RWMutex{}, Cond: &sync.Cond{L: &sync.Mutex{}}}).RegisterHandlers(router)
	(&response.UserHandler{Controller: c, UserLogChannel: (*chans)["user"], Cond: &sync.Cond{L: &sync.Mutex{}}}).RegisterHandlers(router)
	(&response.ReservationHandler{Controller: c, ReservationLogChannel: (*chans)["reservation"], Cond: &sync.Cond{L: &sync.Mutex{}}}).RegisterHandlers(router)
}

func initChannels() *map[string]chan string {
	chans := make(map[string]chan string)
	chans["controller"] = make(chan string)
	chans["card"] = make(chan string)
	chans["storage"] = make(chan string)
	chans["user"] = make(chan string)
	chans["reservation"] = make(chan string)
	return &chans
}

func initObserver(c *controller.Controller) {
	util.Must(nil, (&observer.Observer{c}).Observe())
}

func listenAndServeTLS(logger *log.Logger, router *mux.Router, certificateFile, keyFile string) {
	headersOk := handlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type", "Authorization"})
	originsOk := handlers.AllowedOrigins([]string{"*"})
	methodsOk := handlers.AllowedMethods([]string{"GET", "HEAD", "POST", "PUT"})
	logger.Println(http.ListenAndServeTLS(fmt.Sprintf(":%s", os.Getenv("REST_PORT")), certificateFile, keyFile,
		handlers.LoggingHandler(logger.Writer(),
			handlers.CORS(originsOk, headersOk, methodsOk)(router))))
}

func main() {
	router := createRouter()

	logger := log.New(os.Stderr, "API: ", log.LstdFlags|log.Lshortfile)

	clientId := fmt.Sprintf("CSMC-%d", time.Now().Unix())
	db := connectToDatabase(os.Getenv("DB_USER"), os.Getenv("DB_PASSWD"),
		os.Getenv("DB_HOSTNAME"), os.Getenv("DB_PORT"), os.Getenv("DB_NAME"))

	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}

	chans := initChannels()
	c := initController(clientId, db, logger)

	//go func() {
	//	i := 0
	//	for range time.Tick(5 * time.Second) {
	//		(*chans)["controller"] <- fmt.Sprintf("%d", i)
	//		i++
	//	}
	//}()

	initHandlers(router, c, chans)

	initObserver(c)

	go createSitemap(router)
	go createActionIndex("actions.json")

	logger.Println("Initialization done...")

	listenAndServeTLS(logger, router, "localhost.crt", "localhost.key")
}
