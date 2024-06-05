FROM python:3.9

WORKDIR /code/app/

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY . /code/app
WORKDIR /code/app

CMD ["uvicorn", "src.server.main:app", "--host", "0.0.0.0", "--port", "80", "--proxy-headers"]