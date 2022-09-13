from aiohttp import web

from utils.common import multidict_to_dict


class TextImageActionHandler(web.View):
    async def post(self):
        request_data = await self.request.post()
        print(request_data)
        request_body_data = multidict_to_dict(request_data)
        for key in request_body_data:
            print(f'{key}: {request_body_data[key]}')
        return web.json_response(data=[1, 2, 3], status=201)
