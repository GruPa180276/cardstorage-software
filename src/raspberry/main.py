import mqtt_client as mc

mc.connect_mqtt()
mc.subscribe()
mc.client.loop_forever()