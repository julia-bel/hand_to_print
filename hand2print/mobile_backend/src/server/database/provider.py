from typing import Any, Dict

from firebase_admin import credentials, initialize_app, db


class FirebaseProvider:
    def __init__(self):
        self.db = None

    def mount(self, root: str, key_path: str, database_url: str):
        creds = credentials.Certificate(key_path)
        initialize_app(creds, {"databaseURL": database_url})
        self.db = db.reference(root)

    def upload(self, value: Dict[str, Any]):
        self.db.push().set(value)


if __name__ == "__main__":
    from conversion import sample2json
    from PIL import Image

    provider = FirebaseProvider()
    provider.mount(
        "/",
        key_path="src/server/database/credentials.json",
        database_url="https://handtoprint-default-rtdb.firebaseio.com/",
    )
    provider.upload(
        sample2json(
            Image.open("~/HandToPrint/assets/test.jpg"),
            "Example",
        )
    )
