from typing import Dict, Any
from PIL.Image import Image
import datetime
import base64
import io


def sample2json(image: Image, response: str) -> Dict[str, Any]:
    byte_arr = io.BytesIO()
    image.save(byte_arr, format="PNG")
    b64_string = base64.b64encode(byte_arr.getvalue()).decode("utf-8")
    json_value = {
        "image": b64_string,
        "response": response,
        "timestamp": str(datetime.datetime.now()),
    }
    return json_value
