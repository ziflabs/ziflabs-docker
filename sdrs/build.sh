#!/bin/bash

docker build \
    -t sdrs \
    --build-arg USER=$USER \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    --build-arg TZ=$(cat /etc/timezone) \
    .