import mqtt_client as mc

client = mc.connect_mqtt()
mc.subscribe(client)
client.loop_forever()