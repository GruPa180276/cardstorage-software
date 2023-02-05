package controller

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"sync"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/meridian"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/paths"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
	"gorm.io/gorm"
)

type Controller struct {
	mqtt.Client
	*log.Logger
	*websocket.Upgrader
	*gorm.DB
	*sync.Map
	*sync.Cond
	ClientId             string
	ControllerLogChannel chan string
}

func LoggerChannelHandlerFactory(channel chan string, cond *sync.Cond, logger *log.Logger, upgrader *websocket.Upgrader) http.HandlerFunc {
	message := ""

	go func() {
		for {
			select {
			case msg, _ := <-channel:
				cond.L.Lock()
				message = msg
				cond.L.Unlock()
				cond.Broadcast()
			}
		}
	}()

	return func(res http.ResponseWriter, req *http.Request) {
		socket, err := upgrader.Upgrade(res, req, nil)
		if err != nil {
			logger.Println(err)
			return
		}
		go func() { // break if the there was an error while reading or if the client closed the connection
			for {
				if _, _, err := socket.ReadMessage(); err != nil {
					return
				}
			}
		}()

		for { // break if there was an error while writing
			cond.L.Lock()
			cond.Wait()
			err := socket.WriteMessage(websocket.TextMessage, []byte(message))
			if err != nil {
				websocket.IsCloseError(err)
				cond.L.Unlock()
				break
			}
			cond.L.Unlock()
		}
	}
}

type DataWrapper struct {
	Channel  chan string
	Cond     *sync.Cond
	Logger   *log.Logger
	Upgrader *websocket.Upgrader
}

func (self *DataWrapper) LoggerChannelHandlerFactory() http.HandlerFunc {
	message := ""

	go func() {
		for {
			select {
			case msg, _ := <-self.Channel:
				self.Cond.L.Lock()
				message = msg
				self.Cond.L.Unlock()
				self.Cond.Broadcast()
			}
		}
	}()

	return func(res http.ResponseWriter, req *http.Request) {
		socket, err := self.Upgrader.Upgrade(res, req, nil)
		if err != nil {
			self.Logger.Println(err)
			return
		}
		go func() { // break if the there was an error while reading or if the client closed the connection
			for {
				if _, _, err := socket.ReadMessage(); err != nil {
					return
				}
			}
		}()

		for { // break if there was an error while writing
			self.Cond.L.Lock()
			self.Cond.Wait()
			err := socket.WriteMessage(websocket.TextMessage, []byte(message))
			if err != nil {
				websocket.IsCloseError(err)
				self.Cond.L.Unlock()
				break
			}
			self.Cond.L.Unlock()
		}
	}
}

func (self *Controller) RegisterHandlers(router *mux.Router) {
	w := &DataWrapper{Channel: self.ControllerLogChannel, Cond: self.Cond, Logger: self.Logger, Upgrader: self.Upgrader}
	router.HandleFunc(paths.API_CONTROLLER_WS_LOG, w.LoggerChannelHandlerFactory()).Methods(http.MethodGet)
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) PingStorageUnitHandler(message mqtt.Message) (error, *meridian.Ok) {
	m := SerializablePingMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err, nil
	}

	self.Map.LoadAndDelete(m.Id)

	return nil, meridian.Okay(string(message.Payload()))
}

func (self *Controller) PingStorageUnitDispatcher(storageName, location string) error {
	id := uuid.New().String()
	kickoff := NewSerializablePingMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitPing},
		Status{})

	self.Store(id, kickoff)

	buf, err := json.Marshal(kickoff)
	if err != nil {
		return err
	}

	token := self.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)
	token.Wait()
	if err := token.Error(); err != nil {
		return err
	}

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) StorageUnitAddCardHandler(message mqtt.Message) (error, *meridian.Ok) {
	m := SerializableCardStatusMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err, nil
	}

	storageName, location, _ := util.DisassembleBaseStorageTopic(message.Topic())

	if !m.ActionSuccessful {
		return fmt.Errorf("failed to add card '%d' to storage-unit '%s' at '%s': %s", m.Position, storageName, location, m.IfNotWhy), nil
	}

	card := model.Card{Name: m.Name, Position: m.Position, ReaderData: util.NullableString(m.ReaderData), CurrentlyAvailable: true, AccessCount: 0}

	storage := model.Storage{}
	if err := self.DB.Where("name = ?", storageName).First(&storage).Error; err != nil {
		return err, nil
	}

	if err := self.DB.Model(&storage).Preload("Cards").Association("Cards").Append(&card); err != nil {
		return err, nil
	}

	self.Map.LoadAndDelete(m.Id)

	return nil, meridian.Okay(string(message.Payload()))
}

func (self *Controller) StorageUnitAddCardDispatcher(storageName, location, cardName string, position uint) error {
	id := uuid.New().String()
	m := NewSerializableCardStatusMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitNewCard},
		Card{Position: position, Name: cardName},
		Status{})

	buf, err := json.Marshal(m)
	if err != nil {
		return err
	}

	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)
	self.Map.Store(m.Id, m)

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) DeleteCardHandler(message mqtt.Message) (error, *meridian.Ok) {
	m := SerializableCardStatusMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err, nil
	}
	storageName, location, _ := util.DisassembleBaseStorageTopic(message.Topic())
	if !m.ActionSuccessful {
		return fmt.Errorf("failed to delete card '%d' in storage-unit '%s' at '%s': %s", m.Position, storageName, location, m.IfNotWhy), nil
	}

	if err := self.DB.Where("name = ?", m.Name).Delete(&model.Card{}).Error; err != nil {
		return err, nil
	}

	self.Map.LoadAndDelete(m.Id)
	return nil, meridian.Okay(string(message.Payload()))
}

func (self *Controller) DeleteCardDispatcher(storageName, location, cardName string, position uint) error {
	id := uuid.New().String()

	kickoff := NewSerializableCardStatusMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitDeleteCard},
		Card{Position: position, Name: cardName},
		Status{})

	self.Map.Store(id, kickoff)

	buf, err := json.Marshal(kickoff)
	if err != nil {
		return err
	}

	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) SignUpUserHandler(message mqtt.Message) (error, *meridian.Ok) {
	m := SerializableUserMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err, nil
	}

	if _, ok := self.Map.Load(m.Id); !ok {
		return fmt.Errorf("got unknown message-id '%s' for action '%s'", m.Id, m.Action), nil
	}
	// entry.(SerializableUserMessage).User.ReaderData = m.User.ReaderData
	// self.Map.Store(m.Id, entry)

	if err := self.DB.Model(&model.User{}).Where("email = ?", m.Email).Update("reader_data", m.ReaderData).Error; err != nil {
		return err, nil
	}

	return nil, meridian.Okay(string(message.Payload()))
}

func (self *Controller) SignUpUserDispatcher(storageName, location, email string) (*SerializableUserMessage, error) {
	id := uuid.New().String()

	kickoff := NewSerializableUserMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionUserSignup},
		User{Email: &email},
		Status{})

	self.Store(id, kickoff)

	buf, err := json.Marshal(kickoff)
	if err != nil {
		return nil, err
	}

	token := self.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)
	token.Wait()
	if err := token.Error(); err != nil {
		return nil, err
	}

	return &kickoff, nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// @todo
func (self *Controller) DepositCardHandler(message mqtt.Message) (error, *meridian.Ok) {
	return nil, meridian.Okay(string(message.Payload()))
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) FetchCardKnownUserHandler(message mqtt.Message) (error, *meridian.Ok) {
	m := SerializableUserCardMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err, nil
	}

	storageName, location, _ := util.DisassembleBaseStorageTopic(message.Topic())

	if !m.Status.ActionSuccessful {
		return fmt.Errorf("failed to fetch card '%s' at '%d' from storage-unit '%s' at '%s': %s", m.Card.Name, m.Card.Position, storageName, location, m.IfNotWhy), nil
	}

	self.ControllerLogChannel <- string(message.Payload())

	card := model.Card{}
	if result := self.DB.Where("name = ?", m.Card.Name).First(&card); result.Error != nil || result.RowsAffected == 0 {
		return fmt.Errorf("card '%s' doesn't exist", m.Card.Name), nil
	}

	card.CurrentlyAvailable = false
	card.AccessCount++

	if err := self.DB.Save(&card).Error; err != nil {
		self.Logger.Println(err)
	}

	// create reservation for user
	user := model.User{}
	if err := self.DB.Where("email = ?", m.User.Email).First(&user).Error; err != nil {
		return err, nil
	}

	reservation := model.Reservation{UserID: user.UserID, User: user, Since: time.Now(), IsReservation: false}
	if err := self.DB.Model(&card).Association("Reservations").Append(&reservation); err != nil {
		return err, nil
	}

	return nil, meridian.Okay(string(message.Payload()))
}

func (self *Controller) FetchCardKnownUserDispatcher(storageName, location, userWantsCardName string, userWantsCardPosition uint, userEmail string) (*SerializableUserCardMessage, error) {
	id := uuid.New().String()

	kickoff := NewSerializableUserCardMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitFetchCardSourceMobile},
		User{Email: &userEmail},
		Card{Name: userWantsCardName, Position: userWantsCardPosition},
		Status{})

	self.Store(id, kickoff)

	buf, err := json.Marshal(kickoff)
	if err != nil {
		return nil, err
	}

	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)

	return &kickoff, nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) FetchCardUnknownUserHandler(message mqtt.Message) (error, *meridian.Ok) {
	m := SerializableUserCardMessage{}
	if err := json.NewDecoder(bytes.NewBuffer(message.Payload())).Decode(&m); err != nil {
		return err, nil
	}

	storageName, location, _ := util.DisassembleBaseStorageTopic(message.Topic())

	if _, exists := self.Map.Load(m.Id); !exists {
		return fmt.Errorf("got unknown message-id: '%s'", m.Id), nil
	}

	// use the user exists flag to
	// determine the state of the
	// transaction we're in:
	// controller must not modify
	// this flag otherwise many unexpected
	// things will happen!
	if !m.User.Exists { // response to initial request
		// check if user exists
		if !m.Status.ActionSuccessful {
			// transaction failed
			self.Map.Delete(m.Id)
			err := fmt.Errorf("failed to fetch card '%s' at '%d' from storage-unit '%s' at '%s': %s", m.Card.Name, m.Card.Position, storageName, location, m.IfNotWhy)
			return err, nil
		}
		m.User.Exists = true
		user := model.User{}
		if result := self.DB.Where("reader_data = ?", m.User.ReaderData).First(&user); result.Error != nil || result.RowsAffected == 0 {
			// transaction failed
			self.Map.Delete(m.Id)
			m.User.Exists = false

			return fmt.Errorf("failed to fetch card from terminal: user with reader_data '%s' doesn't exist", *m.User.ReaderData), nil
		}
		m.ClientId = self.ClientId
		<-self.Client.Publish(message.Topic(), 2, false, util.Must(json.Marshal(m)).([]byte)).Done()
		return nil, meridian.Okay(string(message.Payload()))
	} else { // acknowledge of actual card-fetch
		if !m.Status.ActionSuccessful {
			return fmt.Errorf("failed to fetch card '%s' at '%d' from storage-unit '%s' at '%s': %s", m.Card.Name, m.Card.Position, storageName, location, m.IfNotWhy), nil
		}

		self.ControllerLogChannel <- string(message.Payload())

		c := model.Card{}
		if err := self.DB.Where("name = ?", m.Card.Name).First(&c).Error; err != nil {
			return err, nil
		}
		c.CurrentlyAvailable = false
		c.AccessCount++
		if err := self.DB.Save(&c).Error; err != nil {
			return err, nil
		}

		// create reservation for user
		user := model.User{}
		if err := self.DB.Where("email = ?", m.User.Email).First(&user).Error; err != nil {
			return err, nil
		}
		reservation := model.Reservation{UserID: user.UserID, User: user, Since: time.Now(), IsReservation: false}
		if err := self.DB.Model(&user).Association("Reservations").Append(&reservation); err != nil {
			return err, nil
		}

		self.Map.Delete(m.Id)

		return nil, meridian.Okay(string(message.Payload()))
	}
}

func (self *Controller) FetchCardUnknownUserDispatcher(storageName, location, userWantsCardName string, userWantsCardPosition uint) (*SerializableUserCardMessage, error) {
	id := uuid.New().String()
	m := NewSerializableUserCardMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitFetchCardSourceTerminal},
		User{Exists: false},
		Card{Name: userWantsCardName, Position: userWantsCardPosition},
		Status{})
	buf, err := json.Marshal(m)
	if err != nil {
		return nil, err
	}
	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)

	self.Map.Store(m.Id, m)

	return &m, nil
}
