FROM python:3.8-slim

ARG project_name=zookeep

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y postgresql-client
RUN apt-get install -y gcc libc-dev netcat

RUN pip install --upgrade pip setuptools wheel
RUN pip install pipenv


COPY Pipfile* /tmp/
RUN cd /tmp && pipenv install && pipenv requirements > requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN apt-get clean
RUN rm -f /var/lib/apt/list/*

RUN useradd -ms /bin/bash $project_name
USER $project_name

RUN mkdir /home/$project_name/src
WORKDIR /home/$project_name/src
COPY ./src /home/$project_name/src


RUN mkdir -p /home/$project_name/src/media
RUN mkdir -p /home/$project_name/src/static
RUN mkdir -p /home/$project_name/log
