package controller

import (
	"encoding/json"
	"log"
	"sync"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/google/uuid"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

type Controller struct {
	*log.Logger
	*sync.Map // map[uuid.UUID][]*Result
	mqtt.Client
}

func (self *Controller) SuccessHandler(message mqtt.Message) error {
	p := SerializablePingMessage{}
	if err := json.Unmarshal(message.Payload(), &p); err != nil {
		return err
	}
	self.Printf("ping: %+v\n", p)
	return nil
}

func (self *Controller) FailureHandler(message mqtt.Message) error {
	p := SerializablePingMessage{}
	if err := json.Unmarshal(message.Payload(), &p); err != nil {
		return err
	}
	self.Printf("ping: %+v\n", p)
	return nil
}

func (self *Controller) PingStorageUnitHandler(message mqtt.Message) error {
	p := SerializablePingMessage{}
	if err := json.Unmarshal(message.Payload(), &p); err != nil {
		return err
	}
	self.Printf("ping: %+v\n", p)
	return nil
}

func (self *Controller) PingStorageUnitInvoker(storageName, topic, clientId string) error {
	id := uuid.Must(uuid.NewRandom()).String()
	kickoff := NewSerializablePingMessage(
		Header{Id: id, ClientId: clientId, Action: ActionStorageUnitPing, TimeToLive: HeaderTimeToLiveInitial},
		Ping{StorageName: storageName})

	self.Store(id, []SerializablePingMessage{kickoff})

	buf, err := json.Marshal(kickoff)
	if err != nil {
		return err
	}

	<-self.Publish(topic, 1, false, buf).Done()

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
	return util.ErrNotImplemented
}
