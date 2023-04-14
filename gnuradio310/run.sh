HOST_DIRECTORY=/home/$USER/Downloads

docker rm gnuradio310

docker run \
    --name gnuradio310 \
    -it \
    --user $USER \
    --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --add-host=host.docker.internal:host-gateway \
    -v $HOST_DIRECTORY:/home/$USER/Downloads \
    gnuradio310 \
    bash
