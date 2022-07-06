## Protocol

### 2022-03-08T10:10-12:50  (3h)

Today we got some projectideas for a car. At first we had find some teampartners and the topic we want to do. We decided to choose the project "QrCode Follwing Car". At first we made a concept and we disscused how the structure of the project should look like. I just made so researches about the steering and qr-code algorithm where i found a good documentation which i might use

### 2022-03-08T10:10-12:50;16:20-17:20  (4h)

Today i started to code the QR-Code-Detection. I use OpenCv with the QRCodeDetection function to scan and decode the QrCode. At first jakob and me had a problem, as it was not possible to compile the created program. After some research i found out that we should use python 3.7 and opencv 4.0.0. I also created the QrCodes. After finishing the programm i started to help jakob because he had a problem with the bbox i gaver him.
Later in the afternoon i started to correct jakobs code, as there were some problems. I just reprogramed the code to draw the diagonal and get the length of width and height

### 2022-03-23T10:10-12:50 (3h)

Today I discussed the steering calaculation with Jakob. We decided to calculate the steering angle by using the height and width point of the QRCode. Then we use the atan() function to calc the angle of the mid Point of the cam to the center point of the QrCode. I made the function to calculate the midpoint of the QRCOde while jakob created the function to calc angle for it. After some code &fix everything started run well. After that I decided to code the program for the pycam.
