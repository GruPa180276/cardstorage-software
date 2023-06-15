# RFID Card Management

## Contributors
- Patrick Grubauer (leader)
- Johannes Mayrhofer
- Benedikt Zoechmann


## Introduction
The diploma thesis explored the digitization and optimization of the card lending process, specifically focusing on improving the efficiency of school-wide printing. The previous method of borrowing a card from a folder proved to be time-consuming and presented various challenges. Difficulties arose due to the card folder's location, making it problematic for teachers to borrow or return cards if the room was not consistently occupied. In such cases, waiting times or alternative methods, such as utilizing a teacher's mailbox in the LIZ, had to be employed. As a result, the process of borrowing a card required a considerable amount of time and patience.

The thesis successfully addressed these issues by implementing backend systems, APIs, and developing a Flutter application for the frontend. Additionally, a collaborative effort was established with the Department of Mechatronics to enhance the hardware components of the project.

Concurrently, another thesis focused on constructing a secure safe specifically designed for storing the cards. The combined efforts of both theses have paved the way for future improvements, aiming to provide location- and time-independent access to printing cards, as well as automating the lending process.

This repository includes the software components:
  - User App: Allows the user to borrow and reserve cards.
  - Admin App: Is responsible for the administrative part, adding machines, creating users, creating statistics...
  - DB + API: The entire data is stored in a database and the data is accessed via the API.
  - 
## Documentation
You can find a very detailed overview of the project [here](doc/thesis_card_storage_management_docu.pdf)

## Use-Cases
### General
![System overview](/_img/complete-system.png)

### Client
![Client Use-Case](/_img/client-use-case.png)

### Admin
![Client Use-Case](/_img/admin_use_case.png)

### Display
![Client Use-Case](/_img/display-use-case.png)

### Login
![Client Use-Case](/_img/login-use-case.png)


