FROM python:3.8-slim

ARG USER_NAME=user

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y postgresql-client
RUN apt-get install -y gcc libc-dev netcat libpq-dev

RUN pip install --upgrade pip setuptools wheel
RUN pip install pipenv


COPY Pipfile* /tmp/
RUN cd /tmp && pipenv install --dev && pipenv requirements > requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN apt-get clean
RUN rm -f /var/lib/apt/list/*

RUN useradd -ms /bin/bash $USER_NAME
USER $USER_NAME

RUN mkdir /home/$USER_NAME/src
WORKDIR /home/$USER_NAME/src
COPY ./src /home/$USER_NAME/src


RUN mkdir -p /home/$USER_NAME/src/media
RUN mkdir -p /home/$USER_NAME/src/static
RUN mkdir -p /home/$USER_NAME/log
