#!/bin/bash

if [[ -z "${DOCKER_USER}" ]]; then
    echo "Please set DOCKER_USER environment variable!"
    exit -1
fi

docker rm gnuradio310
docker rmi gnuradio310
docker image prune -f

docker build \
    -t gnuradio310 \
    --no-cache \
    --build-arg USER=$DOCKER_USER \
    .