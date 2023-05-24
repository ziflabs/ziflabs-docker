docker rm gnuradio310
docker rmi gnuradio310
docker image prune -f

docker build \
    -t gnuradio310 \
    --no-cache \
    --build-arg USER=$USER \
    .