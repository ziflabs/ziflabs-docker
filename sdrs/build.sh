#!/bin/bash

if [[ -z "${DOCKER_USER}" ]]; then
    echo "Please set DOCKER_USER environment variable!"
    exit -1
fi

docker build \
    -t sdrs \
    --build-arg USER=$DOCKER_USER \
    --build-arg UID=1000 \
    --build-arg GID=1000 \
    --build-arg TZ=$(cat /etc/timezone) \
    .