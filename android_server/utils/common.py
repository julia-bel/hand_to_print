import logging
import sys

from utils.const import LOG_LEVELS


def set_logging(service_name):
    logger = logging.getLogger(f'{service_name}')
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger.setLevel(LOG_LEVELS['INFO'])

    handler_stdout = logging.StreamHandler(sys.stdout)
    handler_stdout.setFormatter(formatter)
    logger.addHandler(handler_stdout)

    return logger


def multidict_to_dict(multidict):
    d = {}
    for k in multidict.keys():
        v = multidict.getall(k)
        d[k] = v[0] if isinstance(v, list) and len(v) == 1 else v
    return d
