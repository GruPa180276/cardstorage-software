import paho.mqtt.client as mqtt
import json
import logging

clientId = "sim0"
broker = "tcp://localhost:1883"

class Handlers:
    def __init__(self, client, logger):
        self.responder = client
        self.logger = logger

    def getHandler(self, action):
        return {
            "storage-unit-ping": self.pingHandler
        }[action]

    def handlers(self, topic, message):
        if len(message) > (1 << 10):
            return
        if message["client-id"] == clientId:
            return

        self.getHandler(message["action"])(topic, message)

    def pingHandler(self, topic, m):
        print("~> " + str(m))

        m["client-id"] = clientId
        m["ping"]["is-available"] = True

        print("<~ " + str(m))
        if (err := self.responder.publish(topic, payload=json.dumps(m), qos=2).rc) != mqtt.MQTT_ERR_SUCCESS:
            self.logger.error(err)

def main(args):
    client = mqtt.Client(client_id=clientId)
    client.on_connect = lambda _, __, ___, ____: client.subscribe(args[1], qos=2)
    h = Handlers(client, logging.getLogger("simulator: "))
    client.on_message = lambda c, _, message: h.handlers(message.topic, json.loads(message.payload))
    client.connect("127.0.0.1", 1883, 60)
    client.loop_forever()

if __name__ == "__main__":
    import sys
    main(sys.argv)