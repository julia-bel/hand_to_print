from aiohttp import web

from utils.config import Config
from text_images_handler import TextImageActionHandler


async def init_app():
    app = web.Application()
    app.config = Config
    app.add_routes([web.route(method='POST', path='/text_recognition', handler=TextImageActionHandler)])
    return app


if __name__ == '__main__':
    web.run_app(init_app(), host=Config.Api.bind_ip, port=Config.Api.bind_port)
