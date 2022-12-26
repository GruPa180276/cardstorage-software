from enum import Enum

# class syntax

class Storage(Enum):
    LOCATION="3-51"
    TOPIC="1117"
    
    PING="storage-unit-ping"
    DELETE="storage-unit-delete-card"
    NEW_STORAGE="storage-unit-new"
    NEW_CARD="storage-unit-new-card"
    GET_CARD_MOBILE="storage-unit-fetch-card-source-mobile"
    GET_CARD_TERMINAL="storage-unit-fetch-card-source-terminal"
    USER_SIGNUP="user-signup"
    USER_CHECK_EXISTS="user-check-exists"
    SUCCESS="success"
    FAILURE="failure"