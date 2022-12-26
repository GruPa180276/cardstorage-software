
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
                    #drop card funciton made by mechatronics
                    #if card drop successful send 
                    mqtt_msg=json.dumps({"msgid":Rfid.msgid, "action": "success" })
                    mc.client.publish(Storage.TOPIC.value,mqtt_msg)

                case Storage.GET_CARD_TERMINAL.value:
                    Rfid.msgid=res["msgid"]
                    Rfid.card= res["card"]
                    token=Rfid.scanCard()
                    print(Rfid.msgid)
                    mqtt_msg=json.dumps({"msgid":Rfid.msgid,"action": Storage.USER_CHECK_EXISTS.value,"token": token, "type":"request" })
                    mc.client.publish(Storage.TOPIC.value,mqtt_msg)
                    print(token)
                #--------------
                case Storage.USER_CHECK_EXISTS.value:
                    if(res["type"]=="response" and res["msgid"]==Rfid.msgid and res["successful"]):
                        print( Rfid.card["name"]) 
                        #drop card funciton made by mechatronics
                        #if card drop successful send 
                        mqtt_msg=json.dumps({"msgid":Rfid.msgid, "action": "success" })
                        mc.client.publish(Storage.TOPIC.value,mqtt_msg)
                    #print("I was here") 

                case Storage.USER_SIGNUP.value:
                    print("I was here1") 

                case Storage.PING.value:
                    print("I was here2")
                case Storage.DELETE.value:
                    print("I was here3")
                case Storage.NEW_STORAGE.value:
                    print("I was here4")
                case Storage.NEW_CARD.value:
                    print("I was here5")
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
        return "scanned" 

    


    

     