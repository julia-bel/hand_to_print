from typing import Any
from copy import deepcopy
import cv2
import logging

import numpy as np

from src import get_detection, get_recognition, sort_boxes, crop_boxes


class OCRModel:
    def __init__(self, detector: Any, recognizer: Any):
        self.detector = detector
        self.recognizer = recognizer

    def __call__(self, image: np.ndarray) -> str:
        boxes = self.detector.predict([image])[0][0]
        try:
            sorted_boxes = sort_boxes(deepcopy(boxes))
        except Exception as err:
            logging.warning(f"Unexpected {err=}, {type(err)=}")
            sorted_boxes = [deepcopy(boxes)]

        result = []
        for boxes in sorted_boxes:
            crops = crop_boxes(image, boxes)
            if len(crops) == 0:
                continue
            predictions = self.recognizer.predict(crops)
            result.append(" ".join(predictions))
        return " ".join(result)


def get_ocr(device: str = "cpu") -> OCRModel:
    return OCRModel(get_detection(device=device), get_recognition(device=device))


if __name__ == "__main__":
    model = get_ocr()
