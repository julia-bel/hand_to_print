# Hand To Print
The note-taking mobile application with the function of translating handwritten text into printable format.

## Relevance
**Problem**:
1. To date, there are few public services for transcribing Russian handwritten text.
2. Applications for taking notes on a phone or tablet are relevant, they are used both in educational or professional activities, and in everyday life. However, handwritten notes are difficult to share with colleagues and friends.

**Solution**:
1. To solve certain problems, it was proposed to develop a service for transcribing Russian handwritten text. The key feature of this service should be support for detecting recognizing text in a photo.
2. The proposed approach can be either a stand-alone note-domain-oriented mobile application or a functional extension for other services.

## Stack
1. Pytorch
2. FastAPI
3. Flutter
4. Docker
5. Firebase

## Functionality
- Adding a picture
- Drawing
- Saving the history of the picture
- Adding new pages
- Converting the text part of the image to a PDF file
- Response caching using the realtime database

## Installation Instruction
**Server**: in the ./mobile_backend use `docker-compose up --build -d`   
**Client**: download and install the [application](./mobile_frontend/build/app/outputs/flutter-apk/app-debug.apk) on your Android device.

## User Instruction
1. To use the **mobile_backed** directly you need to upload [here](http://127.0.0.1:5648:80/upload.html) the PNG image in RGBA format (the backend was developed to be compatible with the main client application).
2. To use the **mobile_frontend** just write something in the note and push the download button, if you want to upload an image to the note, you need to use any PNG image.

**Attention: now not all letter sizes are supported, it is better to look at the testing section.**

## User Interface
<p align="center">
    <img src="assets\ui.svg"/>
</p>

## Modeling
Transfer Learning with use of [HKR Dataset](https://github.com/abdoelsayed2016/HKR_Dataset).  
Models were scripted with [jit](mobile_backend/src/models).  
The algorithm for sorting boxes was [implemented](mobile_backend/src/utils.py).

## Testing
<p align="center">
    <img src="assets\test.svg"/>
</p>

1. In the first case, the answer is completely correct: "2023 Здесь описание текста".
2. In the second case, the answer is incorrect: "123 123".
According to the detection results, it is clear that the first inscription was not recognized, since the text has too large scale.
3. In the first case, the answer is completely correct: "12 12 12".

Android application [package](./mobile_frontend/build/app/outputs/flutter-apk/app-debug.apk)
