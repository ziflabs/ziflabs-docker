#!/bin/bash

docker rm sdrs
docker rmi sdrs
docker image prune -f

docker build \
    -t sdrs \
    --no-cache \
    --build-arg USER=$USER \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    --build-arg TZ=$(cat /etc/timezone) \
    .