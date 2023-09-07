#!/bin/bash

if [[ -z "${DOCKER_USER}" ]]; then
    echo "Please set DOCKER_USER environment variable!"
    exit -1
fi

mkdir -p /tmp/dockershared

docker rm gnuradio310

docker run \
    --name gnuradio310 \
    -it \
    --user $DOCKER_USER \
    --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /tmp/dockershared:/home/$DOCKER_USER/dockershared \
    gnuradio310 \
    bash
