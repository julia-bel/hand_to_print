from aiohttp import web

from middleware import basic_validation
from utils.common import set_logging
from utils.config import Config
from text_images_handler import TextImageActionHandler


async def init_app():
    middlewares = [basic_validation]
    app = web.Application(middlewares=middlewares)
    app.config = Config
    app.base_logger = set_logging('Application server')
    app.add_routes([web.route(method='POST', path='/text_recognition', handler=TextImageActionHandler)])
    app.base_logger.info(f'Start server on {Config.Api.bind_ip}:{Config.Api.bind_port}')
    return app


if __name__ == '__main__':
    web.run_app(init_app(), host=Config.Api.bind_ip, port=Config.Api.bind_port)
    print('Server was stopped')
