FROM python:3


RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN pip install -r /usr/src/app/requirements_dev.txt

ENTRYPOINT ["nosetests"]

CMD ["--verbosity=2", "aioamqp"]
