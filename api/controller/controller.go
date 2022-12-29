package controller

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
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
	*sync.Map
	*websocket.Upgrader
	*gorm.DB
	ClientId              string
	ControllerInfoChannel chan string
}

func (self *Controller) RegisterHandlers(router *mux.Router) {
	router.HandleFunc(paths.API_WS_LOG_CONTROLLER_CHANNEL, func(res http.ResponseWriter, req *http.Request) {
		socket, err := self.Upgrader.Upgrade(res, req, nil)
		if err != nil {
			self.Logger.Println(err)
			return
		}
		listen := true
		for listen {
			select {
			case message, ok := <-self.ControllerInfoChannel:
				if ok {
					if err = socket.WriteMessage(websocket.TextMessage, []byte(message)); err != nil {
						self.Println(err)
					}
				} else {
					listen = false
				}
			}
		}
	}).Methods(http.MethodGet)
}

func (self *Controller) SuccessHandler(message mqtt.Message) error {
	return util.ErrNotImplemented
}

func (self *Controller) FailureHandler(message mqtt.Message) error {
	return util.ErrNotImplemented
}

func (self *Controller) PingStorageUnitHandler(message mqtt.Message) error {
	self.ControllerInfoChannel <- string(message.Payload())
	self.Logger.Println(string(message.Payload()))

	header := Header{}
	if err := json.Unmarshal(message.Payload(), &header); err != nil {
		return err
	}
	self.Map.LoadAndDelete(header.Id)

	return nil
}

func (self *Controller) PingStorageUnitInvoker(storageName, location string) error {
	id := uuid.New().String()
	kickoff := NewSerializablePingMessage(
		Header{Id: id, ClientId: self.ClientId, Action: ActionStorageUnitPing},
		Ping{StorageName: storageName})

	self.Store(id, []SerializablePingMessage{kickoff})

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

func (self *Controller) AddNewCardToStorageUnitHandler(message mqtt.Message) error {
	return util.ErrNotImplemented
}

func (self *Controller) AddNewCardToStorageUnitInvoker() error {
	return util.ErrNotImplemented
}

func (self *Controller) FetchCardHandler(message mqtt.Message) error {
	return util.ErrNotImplemented
}

func (self *Controller) DeleteCardHandler(message mqtt.Message) error {
	return util.ErrNotImplemented
}

func (self *Controller) SignUpUserHandler(message mqtt.Message) error {
	return util.ErrNotImplemented
}

func (self *Controller) CheckUserExistenceHandler(message mqtt.Message) error {
	msg := &SerializableUserMessage{}
	if err := json.NewDecoder(bytes.NewBuffer(message.Payload())).Decode(msg); err != nil {
		return err
	}
	user := &model.User{}
	if result := self.DB.Where("reader_data = ?", msg.ReaderData).First(user); result.Error != nil {
		if result.Error == gorm.ErrRecordNotFound {
			msg.ClientId = self.ClientId
			msg.User = nil
			buf, err := json.Marshal(msg)
			if err != nil {
				return err
			}
			<-self.Publish(message.Topic(), 2, false, buf).Done()
			return nil
		}
		return result.Error
	}
	msg.ClientId = self.ClientId
	msg.User = &User{ReaderData: user.ReaderData.String, Email: user.Email}
	buf, err := json.Marshal(msg)
	if err != nil {
		return err
	}
	<-self.Publish(message.Topic(), 2, false, buf).Done()
	return nil
}

func (self *Controller) DepositCardHandler(message mqtt.Message) error {
	return util.ErrNotImplemented
}

func (self *Controller) idExists(id string) bool {
	_, ok := self.Map.Load(id)
	return ok
}
