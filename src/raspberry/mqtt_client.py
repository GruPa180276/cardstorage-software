# python 3.6

import random
import time
import json
from paho.mqtt import client as mqtt_client
import rfid

broker = '192.168.0.139'
port = 1883
topic = "test"
# generate client ID with pub prefix randomly
client_id = f'python-mqtt-{random.randint(0, 1000)}'
username = 'mqtt'
password = 'eclipse'
client = mqtt_client.Client(client_id)

def connect_mqtt():
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def subscribe():
    def on_message(client, userdata, msg):
        res = json.loads(msg.payload.decode())
        rfid.Rfid.manager(res)
    client.subscribe("1117")
    client.on_message = on_message


