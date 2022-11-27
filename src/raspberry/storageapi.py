import requests
import json

api_url = "http://192.168.0.139:7171/card"

def postNewUser(email,token):
    my_dict = json.loads(email+":"+token)
    requests.post(url=api_url,data=f'"{email}":"{token}"')


def checkUserRegisterd(email):
    return

def updateCardStatus(cardId,status):
    return

def addNewCard(cardId,status):
    return

def addNewCard():
    return

