
# import RPi.GPIO as GPIO
# from mfrc522 import SimpleMFRC522
import time
import mqtt_client as mc
import json
from storage_enums import Storage


class Rfid:
    msgid="x"
    card="x"

    def manager(res):
        print(res)
        #msgid=res["msgid"]
        #print(Storage.SUCCESS.value)
        try:
            match res["action"]:
                case Storage.GET_CARD_MOBILE.value:
                    Rfid.msgid=res["msgid"]
                    Rfid.card= res["card"]
                    location=Rfid.card["position"]
                    #drop card funciton made by mechatronics
                    #if card drop successful send 
                    mqtt_msg=json.dumps({"msgid":Rfid.msgid, "action": "success" })
                    mc.client.publish(Storage.TOPIC.value,mqtt_msg)

                case Storage.GET_CARD_TERMINAL.value:
                    Rfid.msgid=res["msgid"]
                    Rfid.card= res["card"]
                    token=Rfid.scanCard()
                    mqtt_msg=json.dumps({"msgid":Rfid.msgid,"action": Storage.USER_CHECK_EXISTS.value,"token": token, "type":"request" })
                    mc.client.publish(Storage.TOPIC.value,mqtt_msg)

                case Storage.USER_CHECK_EXISTS.value:
                    if(res["type"]=="response" and res["msgid"]==Rfid.msgid and res["successful"]):
                        location=Rfid.card["position"]
                        #drop card funciton made by mechatronics
                        #if card drop successful send 
                        mqtt_msg=json.dumps({"msgid":Rfid.msgid, "action": "success" })
                        mc.client.publish(Storage.TOPIC.value,mqtt_msg)

                case Storage.USER_SIGNUP.value:
                    if(res["type"]=="request"):
                        Rfid.msgid=res["msgid"]
                        token=Rfid.scanCard()
                        mqtt_msg=json.dumps({ "msgid":Rfid.msgid, "action": Storage.USER_SIGNUP.value, "token":token, "type":"response"})
                        mc.client.publish(Storage.TOPIC.value,mqtt_msg)

                case Storage.PING.value:
                    Rfid.msgid=res["msgid"]
                    mqtt_msg=json.dumps({"msgid":Rfid.msgid, "action": "success" })
                    mc.client.publish(Storage.TOPIC.value,mqtt_msg)

                case Storage.DELETE.value:
                    Rfid.msgid=res["msgid"]
                    #drop card funciton made by mechatronics
                    #if card drop successful send 
                    mqtt_msg=json.dumps({"msgid":Rfid.msgid, "action": "success" })
                    mc.client.publish(Storage.TOPIC.value,mqtt_msg)
                case Storage.NEW_STORAGE.value:
                    print("tbc.")
                    
                case Storage.NEW_CARD.value:
                    Rfid.msgid=res["msgid"]
                    token=Rfid.scanCard()
                    #token wird an funktion von mechtroniker uebergeben und es dreht siech automatisch bis zur naechsten 
                    location=1
        except:
            print("An exception occurred") 

    def scanCard():
        t_end = time.time() + 2
        while time.time() < t_end:      
            # reader = SimpleMFRC522()

            # try:
            #         id, text = reader.read()
            #         //if it got id return value and send apidata
            #         print(id)
            #         print(text)
            # finally:
            #         GPIO.cleanup()
            print("scanning right now")
        return "111-xxx-222" 

    


    

     