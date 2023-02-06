package response

import (
	"encoding/json"
	"fmt"
	"net/http"
	"sync"
	"time"

	"github.com/gorilla/mux"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/auth"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/observer"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"gorm.io/gorm/clause"
)

type StorageHandler struct {
	*controller.Controller
	Locker *sync.RWMutex
	*sync.Cond
	StorageLogChannel chan string
}

func (self *StorageHandler) RegisterHandlers(router *mux.Router, secret string) {
	r := meridian.StaticHttpReporter{ErrorHandlerFactory(self.Logger, self.StorageLogChannel), SuccessHandlerFactory(self.Logger)}
	authUser := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateUser(secret)}
	authAdmin := meridian.StaticHttpReporterValidator{StaticHttpReporter: r, ValidatorFunc: auth.ValidateAdministrator(secret)}

	router.HandleFunc(paths.API_STORAGES, authUser.ReporterValidator(self.GetAllHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_FILTER_NAME, authUser.ReporterValidator(self.GetByNameHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES, authAdmin.ReporterValidator(self.CreateHandler)).Methods(http.MethodPost).HeadersRegexp("Content-Type", "(text|application)/json")
	router.HandleFunc(paths.API_STORAGES_FILTER_NAME, authAdmin.ReporterValidator(self.UpdateHandler)).Methods(http.MethodPut).HeadersRegexp("Content-Type", "(text|application)/json")
	router.HandleFunc(paths.API_STORAGES_FILTER_NAME, authAdmin.ReporterValidator(self.DeleteHandler)).Methods(http.MethodDelete)
	router.HandleFunc(paths.API_STORAGES_PING_FILTER_NAME, authUser.ReporterValidator(self.PingHandler)).Methods(http.MethodGet)
	router.HandleFunc(paths.API_STORAGES_FOCUS_FILTER_NAME, authAdmin.ReporterValidator(self.FocusHandler)).Methods(http.MethodPut)
	router.HandleFunc(paths.API_STORAGES_FOCUS, authAdmin.ReporterValidator(self.GetAllUnfocusedStorages)).Methods(http.MethodGet)
	w := &controller.DataWrapper{self.StorageLogChannel, self.Cond, self.Logger, self.Upgrader}
	router.HandleFunc(paths.API_STORAGES_WS_LOG, authUser.Validator(w.LoggerChannelHandlerFactory())).Methods(http.MethodGet)
}

func (self *StorageHandler) GetAllHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	storages := make([]model.Storage, 0)

	if err := self.DB.Preload(clause.Associations).Preload("Cards.Reservations").Preload("Cards.Reservations.User").Find(&storages).Error; err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&storages)
}

func (self *StorageHandler) GetByNameHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]
	storage := model.Storage{}
	// https://github.com/go-gorm/gorm/issues/4027
	if err := self.DB.Preload(clause.Associations).Preload("Cards.Reservations").Preload("Cards.Reservations.User").Where("name = ?", name).First(&storage).Error; err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&storage)
}

var createdButNotSubscribedStorages = make(map[string]bool, 0)

func (self *StorageHandler) CreateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type Creator struct {
		Name     string  `json:"name"`
		Location string  `json:"location"`
		Address  *string `json:"address"`
		Capacity *uint   `json:"capacity"`
	}
	c := &Creator{}

	if err := json.NewDecoder(req.Body).Decode(&c); err != nil {
		return err, nil
	}
	if !paths.StorageNameMatcher.MatchString(c.Name) {
		return fmt.Errorf("attribute 'name' does not match required pattern: %s", c.Name), nil
	}
	if !paths.StorageLocationMatcher.MatchString(c.Location) {
		return fmt.Errorf("attribute 'location' does not match required pattern: %s", c.Location), nil
	}
	if c.Address != nil {
		if !paths.StorageAddressMatcher.MatchString(*c.Address) {
			return fmt.Errorf("attribute 'address' does not match required pattern: %s", c.Address), nil
		}
	}
	if c.Capacity != nil {
		if !paths.StorageCapacityMatcher.MatchString(fmt.Sprintf("%d", *c.Capacity)) {
			return fmt.Errorf("attribute 'capacity' does not match required pattern: %s", c.Name), nil
		}
	}

	s := model.Storage{Name: c.Name, Location: c.Location}
	if c.Capacity != nil {
		s.Capacity = *c.Capacity
	}
	if c.Address != nil {
		s.Address = *c.Address
	}

	if err := self.DB.Create(&s).Error; err != nil {
		return err, nil
	}

	createdButNotSubscribedStorages[s.Name] = true

	return nil, meridian.OkayMustJson(&s)
}

func (self *StorageHandler) UpdateHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	type Updater struct {
		Name     *string `json:"name"`
		Location *string `json:"location"`
		Address  *string `json:"address"`
		Capacity *uint   `json:"capacity"`
	}
	vars := mux.Vars(req)

	storage := model.Storage{}
	if result := self.DB.Preload("Cards").Where("name = ?", vars["name"]).First(&storage); result.Error != nil || result.RowsAffected == 0 {
		err := ""
		if result.Error != nil {
			err = result.Error.Error()
		}
		return fmt.Errorf("card '%s' does not exist; %s", vars["name"], err), nil
	}

	u := Updater{}
	if err := json.NewDecoder(req.Body).Decode(&u); err != nil {
		return err, nil
	}

	updateName, updateLocation, updateAddress, updateCapacity := false, false, false, false

	if u.Name != nil {
		updateName = true
		storage.Name = *u.Name
		self.Logger.Println("update Name", storage.Name)
	}
	if u.Location != nil {
		updateLocation = true
		storage.Location = *u.Location
		self.Logger.Println("update Location", storage.Location)
	}
	if u.Address != nil {
		updateAddress = true
		storage.Address = *u.Address
		self.Logger.Println("update Address", storage.Address)
	}
	if u.Capacity != nil {
		updateCapacity = true
		storage.Capacity = *u.Capacity
		self.Logger.Println("update Capacity", storage.Capacity)
	}

	if updateName || updateLocation || updateAddress || updateCapacity {
		if err := self.DB.Save(&storage).Error; err != nil {
			return err, nil
		}
	}

	return nil, meridian.OkayMustJson(&storage)
}

func (self *StorageHandler) DeleteHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	vars := mux.Vars(req)
	storage := model.Storage{}
	if result := self.DB.Preload("Cards").Where("name = ?", vars["name"]).First(&storage); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("unable to get card '%s'", vars["name"]), nil
	}
	if len(storage.Cards) != 0 {
		return fmt.Errorf("attempting to delete non-empty storage '%s'", storage.Name), nil
	}
	if err := self.DB.Delete(&storage).Error; err != nil {
		return err, nil
	}

	self.Unsubscribe(util.AssembleBaseStorageTopic(storage.Name, storage.Location))

	return nil, meridian.Okay()
}

func (self *StorageHandler) PingHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]
	storage := model.Storage{}
	if err := self.DB.Where("name = ?", name).First(&storage).Error; err != nil {
		return err, nil
	}
	if err := self.PingStorageUnitDispatcher(storage.Name, storage.Location); err != nil {
		return err, nil
	}

	return nil, meridian.OkayMustJson(&struct {
		Name string `json:"name"`
		Time int64  `json:"time"`
	}{
		Name: storage.Name,
		Time: time.Now().Unix(),
	})
}

func (self *StorageHandler) FocusHandler(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	name := mux.Vars(req)["name"]

	if _, ok := createdButNotSubscribedStorages[name]; !ok {
		return fmt.Errorf("attempting to re-focus on already subscribed storage-unit"), nil
	}

	storage := model.Storage{}
	if result := self.Where("name = ?", name).First(&storage); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("unable to get storage '%s'", name), nil
	}

	topic := util.AssembleBaseStorageTopic(storage.Name, storage.Location)
	self.Subscribe(topic, 2, observer.GetObserverHandler(self.Controller))

	self.Locker.Lock()
	delete(createdButNotSubscribedStorages, name)
	self.Locker.Unlock()

	return nil, meridian.Okay(fmt.Sprintf("subscribed to %q", topic))
}

func (self *StorageHandler) GetAllUnfocusedStorages(res http.ResponseWriter, req *http.Request) (error, *meridian.Ok) {
	self.Locker.Lock()
	var keys []string = util.Keys(createdButNotSubscribedStorages)
	self.Locker.Unlock()

	return nil, meridian.OkayMustJson(keys)
}
