from PIL import Image
from fastapi import FastAPI, UploadFile
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
import numpy as np

from main import get_ocr
from src import sample2json, FirebaseProvider


app = FastAPI()
db = FirebaseProvider()


@app.post("/upload")
async def upload(image: UploadFile):
    model = get_ocr()

    rgba_image = Image.open(image.file)
    rgba_image.load()
    rgb_image = Image.new("RGB", rgba_image.size, (255, 255, 255))
    rgb_image.paste(rgba_image, mask=rgba_image.split()[3])
    img = np.array(rgb_image)

    result = model(img)
    db.upload(sample2json(rgb_image, result))
    return {"text": result}


@app.get("/")
async def redirect_main():
    return RedirectResponse("/upload.html")


app.mount(
    "/",
    StaticFiles(directory="src/server/static", html=True),
    name="static",
)
db.mount(
    "/",
    key_path="src/server/database/credentials.json",
    database_url="https://handtoprint-default-rtdb.firebaseio.com/",
)
