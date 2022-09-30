from aiohttp import web

from utils.common import multidict_to_dict


@web.middleware
async def basic_validation(request, handler):
    logger = request.app.base_logger
    logger.info(f'Start process request: {request.method} {request.match_info.route.resource} '
                f'{request.match_info.route.resource.canonical}')
    handler.request_query_data = multidict_to_dict(request.query)
    request_data = await request.post()
    handler.request_body_data = multidict_to_dict(request_data)
    logger.info(f'Got request body data: {handler.request_body_data},\n'
                f'request query data: {handler.request_query_data},\n'
                f'{handler} start work')
    response = await handler(request)
    logger.info(f'{handler} finished processing request')
    return response
