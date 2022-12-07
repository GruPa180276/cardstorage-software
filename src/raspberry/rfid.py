
# import RPi.GPIO as GPIO
# from mfrc522 import SimpleMFRC522
import time
def manager(res):
    if(res["action"]=="get-card"):
        email=res["information"]["email"]
        id=res["information"]["id"]
        location=res["information"]["location"]
        token=scanCard()
        #check if user is already registered
        #then sen location to mechatroniker
        #setCardStatus with rest
        #else send error message back
        #push to topic that reading was successful
        
    elif(res["action"]=="register"):
        email=res["action"]["email"]
        token=scanCard()
        #send token+email to api
        #if already implemented send to topic



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

    


    

     