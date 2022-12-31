package controller

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
	"sync"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
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
	ClientId             string
	ControllerLogChannel chan string
}

func LoggerChannelHandlerFactory(channel chan string, logger *log.Logger, upgrader *websocket.Upgrader) http.HandlerFunc {
	return func(res http.ResponseWriter, req *http.Request) {
		socket, err := upgrader.Upgrade(res, req, nil)
		if err != nil {
			logger.Println(err)
			return
		}
		listen := true
		for listen {
			select {
			case message, ok := <-channel:
				if ok {
					if err = socket.WriteMessage(websocket.TextMessage, []byte(message)); err != nil {
						logger.Println(err)
					}
				} else {
					listen = false
				}
			}
		}
	}
}

func (self *Controller) RegisterHandlers(router *mux.Router) {
	router.HandleFunc(paths.API_CONTROLLER_WS_LOG, LoggerChannelHandlerFactory(self.ControllerLogChannel, self.Logger, self.Upgrader)).Methods(http.MethodGet)
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) PingStorageUnitHandler(message mqtt.Message) error {
	self.ControllerLogChannel <- string(message.Payload())
	self.Logger.Println(string(message.Payload()))

	header := Header{}
	if err := json.Unmarshal(message.Payload(), &header); err != nil {
		return err
	}
	self.Map.LoadAndDelete(header.Id)

	return nil
}

func (self *Controller) PingStorageUnitDispatcher(storageName, location string) error {
	id := uuid.New().String()
	kickoff := NewSerializablePingMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitPing},
		Ping{StorageName: storageName})

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

func (self *Controller) StorageUnitAddCardHandler(message mqtt.Message) error {
	m := SerializableCardMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err
	}

	card := model.Card{Name: m.Name, Position: m.Position, CurrentlyAvailable: true, AccessCount: 0}
	storageName, _, _ := util.DisassembleBaseStorageTopic(message.Topic())
	storage := model.Storage{}
	if err := self.DB.Where("name = ?", storageName).First(&storage).Error; err != nil {
		return err
	}

	if err := self.DB.Model(storage).Preload("Cards").Association("Cards").Append(&card); err != nil {
		self.Logger.Println(err.Error())

		if strings.Contains(err.Error(), "Error 1452") {
			return fmt.Errorf("possible duplicate card '%s'", card.Name)
		}
		return err
	}

	self.Map.LoadAndDelete(m.Id)
	return nil
}

func (self *Controller) StorageUnitAddCardDispatcher(storageName, location, cardName string, position uint) error {
	id := uuid.New().String()
	m := NewSerializableCardMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitNewCard},
		Card{Position: position, Name: cardName})

	buf, err := json.Marshal(m)
	if err != nil {
		return err
	}

	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)
	self.Map.Store(m.Id, m)

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) DeleteCardHandler(message mqtt.Message) error {
	m := SerializableCardDeletionMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err
	}
	storage, location, _ := util.DisassembleBaseStorageTopic(message.Topic())
	if !m.DeletionSuccessful {
		return fmt.Errorf("failed to delete card '%d' in storage-unit '%s' at '%s': %s", m.Position, storage, location, m.IfNotWhy)
	}

	if err := self.DB.Where("name = ?", m.Name).Delete(&model.Card{}).Error; err != nil {
		return err
	}

	self.Map.LoadAndDelete(m.Id)
	return nil
}

func (self *Controller) DeleteCardDispatcher(storageName, location, cardName string, position uint) error {
	id := uuid.New().String()

	kickoff := NewSerializableCardDeletionMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitDeleteCard},
		Card{Position: position, Name: cardName},
		CardDeleter{})

	self.Map.Store(id, kickoff)

	buf, err := json.Marshal(kickoff)
	if err != nil {
		return err
	}

	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) SignUpUserHandler(message mqtt.Message) error {
	m := SerializableUserMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err
	}

	_, ok := self.Map.Load(m.Id)
	if !ok {
		return fmt.Errorf("got unknown message-id '%s' for action '%s'", m.Id, m.Action)
	}
	// entry.(SerializableUserMessage).User.ReaderData = m.User.ReaderData
	// self.Map.Store(m.Id, entry)

	if err := self.DB.Model(&model.User{}).Where("email = ?", m.Email).Update("reader_data", m.ReaderData).Error; err != nil {
		return err
	}

	strmsg := string(util.Must(json.Marshal(&struct {
		Action string `json:"action"`
		Email  string `json:"email"`
		Reader string `json:"reader"`
	}{
		Action: m.Action.String(),
		Email:  *m.Email,
		Reader: *m.ReaderData,
	})).([]byte))

	self.Println(strmsg)
	self.ControllerLogChannel <- strmsg

	return nil
}

func (self *Controller) SignUpUserDispatcher(storageName, location, email string) error {
	id := uuid.New().String()

	kickoff := NewSerializableUserMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionUserSignup},
		User{Email: &email})

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

func (self *Controller) FetchCardUnknownUserHandler(message mqtt.Message) error {
	msg := &SerializableUserCardMessage{}
	if err := json.NewDecoder(bytes.NewBuffer(message.Payload())).Decode(msg); err != nil {
		return err
	}
	user := &model.User{}
	if result := self.DB.Where("reader_data = ?", msg.User.ReaderData).First(user); result.Error != nil {
		if result.Error == gorm.ErrRecordNotFound {
			// user does not exist, abort transaction
			msg.ClientId = self.ClientId
			msg.User = User{ReaderData: nil, Email: nil, Exists: false}
			buf, err := json.Marshal(msg)
			if err != nil {
				return err
			}
			self.Publish(message.Topic(), 2, false, buf)
			self.Map.Delete(msg.Id)
			return nil
		}
		return result.Error
	}
	msg.ClientId = self.ClientId
	msg.User = User{ReaderData: &user.ReaderData.String, Email: &user.Email, Exists: true}
	buf, err := json.Marshal(msg)
	if err != nil {
		return err
	}
	self.Publish(message.Topic(), 2, false, buf)
	self.ControllerLogChannel <- string(buf)
	return nil
}

func (self *Controller) FetchCardUnknownUserDispatcher(storageName, location, userWantsCardName string, userWantsCardPosition uint) error {
	id := uuid.New().String()
	m := NewSerializableUserCardMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitFetchCardSourceTerminal},
		User{},
		Card{Name: userWantsCardName, Position: userWantsCardPosition})
	buf, err := json.Marshal(m)
	if err != nil {
		return err
	}
	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)

	self.Map.Store(m.Id, m)

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) DepositCardHandler(message mqtt.Message) error {
	m := SerializableCardMessage{}
	if err := json.Unmarshal(message.Payload(), &m); err != nil {
		return err
	}
	storageName, _, _ := util.DisassembleBaseStorageTopic(message.Topic())
	storage := model.Storage{}
	if err := self.DB.Preload("Cards").Where("name = ?", storageName).First(&storage).Error; err != nil {
		return err
	}
	var card *model.Card = nil
	for _, c := range storage.Cards {
		if c.Position == m.Position {
			card = &c
			break
		}
	}
	if card == nil {
		return fmt.Errorf("card at position %d doesn't seem to belong to storage '%s'", m.Card.Position, storage.Name)
	}

	card.CurrentlyAvailable = true
	if err := self.DB.Save(card).Error; err != nil {
		return err
	}

	self.ControllerLogChannel <- fmt.Sprintf("deposited card %s in %s at position %s on %d")

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func (self *Controller) FetchCardKnownUserHandler(message mqtt.Message) error {
	// nothing to do here, really
	self.ControllerLogChannel <- string(message.Payload())
	return nil
}

func (self *Controller) FetchCardKnownUserDispatcher(storageName, location string, position uint) error {
	id := uuid.New().String()

	kickoff := NewSerializableCardMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitFetchCardSourceMobile},
		Card{Position: position})

	self.Store(id, kickoff)

	buf, err := json.Marshal(kickoff)
	if err != nil {
		return err
	}

	self.Client.Publish(util.AssembleBaseStorageTopic(storageName, location), 2, false, buf)

	return nil
}
