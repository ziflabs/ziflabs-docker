#!/bin/bash

if [[ -z "${DOCKER_USER}" ]]; then
    echo "Please set DOCKER_USER environment variable!"
    exit -1
fi

docker rm sdrs
docker rmi sdrs
docker image prune -f

docker build \
    -t sdrs \
    --no-cache \
    --build-arg USER=$DOCKER_USER \
    --build-arg UID=1000 \
    --build-arg GID=1000 \
    --build-arg TZ=$(cat /etc/timezone) \
    .