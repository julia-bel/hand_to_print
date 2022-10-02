import io

from aiohttp import web
from aiohttp.web_request import Request
from aiohttp.web_response import Response


class TextImageActionHandler(web.View):
    def __init__(self, request: Request):
        super().__init__(request)
        self.logger = request.action_logger if hasattr(request, 'action_logger') else request.app.base_logger

    async def post(self) -> Response:
        if self.request_body_data.get('text_image'):
            self.logger.info(f'TextImageActionHandler succesfully load images')
            images = [io.BytesIO(image) for image in self.request_body_data['text_image']]
            # text = ModelManager.preprocess(images)
        text = ""
        for i in range(200):
            text += f'{i}\n'
        self.logger.info('All images successfully proccessed')
        return web.json_response(data={'text': text}, status=201)
