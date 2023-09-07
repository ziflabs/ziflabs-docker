#!/bin/bash

if [[ -z "${DOCKER_USER}" ]]; then
    echo "Please set DOCKER_USER environment variable!"
    exit -1
fi

docker build \
    -t gnuradio310 \
    --build-arg USER=$DOCKER_USER \
    .