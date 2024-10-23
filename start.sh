#!/bin/bash

# build the image
docker build -t dev-env:latest .

# check if there is a .container_id file (and stop it)
if [ -f .container_id ]; then
    ./stop.sh
fi

# start the container
CONTAINER_ID=$(docker run --rm -d --privileged dev-env:latest)
echo "$CONTAINER_ID" > .container_id

# join the container
docker exec -it $CONTAINER_ID /usr/bin/zsh