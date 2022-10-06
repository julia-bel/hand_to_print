import re
import cv2
import torch
import numpy as np

from typing import Any, Dict, List, Optional
from PIL import Image


class ModelManager:
    def __init__(self, model: Any, config: Dict[str, Any]):
        self.model = torch.jit.load(model)
        self.charset = config["charset"]
        self.max_pred_lines = config["max_pred_lines"]
        self.device = config["device"]
        self.preprocess_config = config["preprocess_config"]

    def preprocess(self, images: List[Image], n=16) -> Dict[str, np.ndarray]:
        l = len(images)
        for i in range(0, l, n):
            yield self.apply_preprocessing(images[i:min(i + n, l)])

    def apply_preprocessing(self, images: List[Image]) -> Dict[str, np.ndarray]:

        def pad_image_width_right(img: np.ndarray, new_width: int, padding_value: int) -> np.ndarray:
            h, w, c = img.shape
            pad_width = max((new_width - w), 0)
            pad_right = np.ones((h, pad_width, c)) * padding_value
            img = np.concatenate([img, pad_right], axis=1)
            return img

        def pad_image_height_bottom(img: np.ndarray, new_height: int, padding_value: int) -> np.ndarray:
            h, w, c = img.shape
            pad_height = max((new_height - h), 0)
            pad_bottom = np.ones((pad_height, w, c)) * padding_value
            img = np.concatenate([img, pad_bottom], axis=0)
            return img

        samples = {
            "image": [],
            "reduced_shape": []
        }
        for i in range(len(images)):
            images[i] = np.array(images[i])
            for preprocessing in self.preprocess_config["preprocessings"]:
                if preprocessing["type"] == "dpi":
                    ratio = preprocessing["target"] / preprocessing["source"]
                    temp_img = images[i]
                    h, w, c = temp_img.shape
                    temp_img = cv2.resize(temp_img, (int(np.ceil(w * ratio)), int(np.ceil(h * ratio))))
                    if len(temp_img.shape) == 2:
                        temp_img = np.expand_dims(temp_img, axis=2)
                    images[i] = temp_img
                if preprocessing["type"] == "to_grayscaled":
                    temp_img = images[i]
                    h, w, c = temp_img.shape
                    if c == 3:
                        images[i] = np.expand_dims(0.2125*temp_img[:, :, 0] + 0.7154*temp_img[:, :, 1] + 0.0721*temp_img[:, :, 2], axis=2).astype(np.uint8)
            reduce_dims_factor = np.array([
                self.preprocess_config["height_divisor"],
                self.preprocess_config["width_divisor"], 1])
            samples["reduced_shape"].append(np.floor(images[i].shape / reduce_dims_factor).astype(int))
            if "padding" in self.preprocess_config["constraints"]:
                if images[i].shape[0] < self.preprocess_config["padding"]["min_height"]:
                    images[i] = pad_image_height_bottom(
                        images[i],
                        self.preprocess_config["padding"]["min_height"],
                        self.preprocess_config["padding_value"])
                if images[i].shape[1] < self.preprocess_config["padding"]["min_width"]:
                    images[i] = pad_image_width_right(
                        images[i],
                        self.preprocess_config["padding"]["min_width"],
                        self.preprocess_config["padding_value"])
            if "normalize" in self.params["config"]["constraints"]:
                sample["img"] = (sample["img"] - sample["img"].mean()) / sample["img"].std()
            samples["image"].append(images[i])
        samples["image"] = np.array(samples["image"])
        samples["reduced_shape"] = np.array(samples["reduced_shape"])
        return samples

    def postprocess(self, ind_x: List[torch.Tensor]) -> List[str]:

        def ind_to_str(ind: List[torch.Tensor], oov_symbol: Any = None) -> str:
            if oov_symbol is not None:
                res = []
                for i in ind:
                    if i < len(self.charset):
                        res.append(self.charset[i])
                    else:
                        res.append(oov_symbol)
            else:
                res = [self.charset[i] for i in ind]
            return "".join(res)

        def ctc_remove_successives(ind: torch.Tensor) -> List[int]:
            res = []
            for j in ind:
                for i in j:
                    if res and res[-1] == i:
                        continue
                    res.append(i)
            return res

        str_x = []
        for lines_token in ind_x:
            list_str = [ind_to_str(ctc_remove_successives(p), oov_symbol="")
                        if p is not None else "" for p in lines_token]
            str_x.append(re.sub("(\n)+", "\n", "\n".join(list_str).strip("\n")))
        return str_x

    def append_predictions(
        self,
        pg_preds: List[List[torch.Tensor]],
        line_preds: List[Optional[torch.Tensor]]
    ) -> List[List[torch.Tensor]]:
        for i, lp in enumerate(line_preds):
            if lp is not None:
                pg_preds[i].append(lp)
        return pg_preds

    def decode(self, probs, x_reduced_len) -> List[List[torch.Tensor]]:
        batch_size = len(probs)
        line_pred = [[] for _ in range(batch_size)]

        for i in range(batch_size):
            line_pred[i] = [(torch.argmax(lp, dim=0).detach().cpu())[:x_reduced_len[j]] for j, lp in enumerate(probs[i])]

        for i in range(len(line_pred)):
            line_pred[i] = [l if probs[i] != None else None for j, l in enumerate(line_pred[i])]

        preds = [[] for _ in range(batch_size)]
        preds = self.append_predictions(preds, line_pred)
        return preds

    def evaluate(self, batch) -> List[List[torch.Tensor]]:
        with torch.no_grad():
            x = torch.from_numpy(batch["image"])
            x = torch.tensor(x).float().permute(0, 3, 1, 2).to(self.device)
            x_reduced_len = [shape[1] for shape in batch["reduced_shape"]]
            x_reduced_len = torch.tensor(x_reduced_len).int().to(self.device)
            probs = self.model(x, x_reduced_len)
        preds = self.decode(probs, x_reduced_len)
        return preds

    def predict(self, images: List[Image]) -> List[str]:
        preds = [p for batch in self.preprocess(images)
                for p in self.postprocess(self.evaluate(batch))]
        return preds