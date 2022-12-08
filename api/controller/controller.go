package controller

import (
	"encoding/json"
	"log"
	"sync"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/google/uuid"
)

type Controller struct {
	*log.Logger
	*sync.Map // map[uuid.UUID][]*Result
	mqtt.Client
}

// @todo handler
func (self *Controller) AddNewCardToStorageUnitHandler(message mqtt.Message) error {
	return nil
}

// @todo invoker
func AddNewCardToStorageUnit() error {
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

func (self *Controller) PingStorageUnit(storageName, topic, clientId string) error {
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
