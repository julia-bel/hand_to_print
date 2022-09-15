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
        self.logger.info(f'TextImageActionHandler got request with body: {request_body_data}')
        if request_body_data.get('text_image'):
            image_bytes = request_body_data['text_image'].file
            self.logger.info(f'TextImageActionHandler succesfully load image')

            img = Image.open(io.BytesIO(image_bytes.read()))
            img.show()

        self.logger.info('Image was proccessed, ')
        return web.json_response(data=[1, 2, 3], status=201)
