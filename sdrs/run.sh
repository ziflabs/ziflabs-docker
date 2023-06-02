docker rm sdrs

docker run \
    --name sdrs \
    -it \
    --user $USER \
    --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --add-host=host.docker.internal:host-gateway \
    sdrs \
    bash
