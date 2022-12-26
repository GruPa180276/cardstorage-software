
# import RPi.GPIO as GPIO
# from mfrc522 import SimpleMFRC522
import time
import mqtt_client as mc
import json
import storage_enums
from storage_enums import Storage


def manager(res):
    msgid=res["msgid"]

    match res["action"]:
        case Storages:
            print("pinging")

        case "storage-unit-fetch-card-source-mobile":
            #drop card funciton made by mechatronics
            #if card drop successful send 
            mqtt_msg=json.dumps({"id":msgid, "action": "success" })
            ("1117",mqtt_msg)
            mc.client.publish("1117",mqtt_msg)

        case "storage-unit-fetch-card-source-terminal":
            card= res["Card"]
            token=scanCard()
            mqtt_msg=json.dumps({"id":msgid,"action": "user-check-exists","token": token })
            mc.client.publish("1117",mqtt_msg)

            print(token)

        case _:
            print("pinging")


        # case "storage-unit-delete-card":
        # case "failure":
        # case "storage-unit-new":
        # case "storage-unit-new-card":
        # case "user-signup-source-mobile":
        # case "user-signup-source-terminal":
        # case "user-check-exists":

def scanCard():
    t_end = time.time() + 20
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

    


    

     