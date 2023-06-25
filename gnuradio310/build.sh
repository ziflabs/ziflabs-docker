#!/bin/bash

docker build \
    -t gnuradio310 \
    --build-arg USER=$USER \
    .