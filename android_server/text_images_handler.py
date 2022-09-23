import io

from aiohttp import web

from utils.common import multidict_to_dict
from PIL import Image


class TextImageActionHandler(web.View):
    def __init__(self, request):
        super().__init__(request)
        self.logger = request.action_logger if hasattr(request, 'action_logger') else request.app.base_logger

    async def post(self):
        request_data = await self.request.post()
        request_body_data = multidict_to_dict(request_data)
        if request_body_data.get('text_image'):
            self.logger.info(f'TextImageActionHandler succesfully load images')
            for image in request_body_data['text_image']:
                self.logger.info(f'Start getting text from {request_body_data["text_image"].index(image)+1} image')
                img = Image.open(io.BytesIO(image))
                img.show()

        self.logger.info('All images successfully proccessed')
        return web.json_response(data=[1, 2, 3], status=201)
