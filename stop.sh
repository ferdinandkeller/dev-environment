#!/bin/bash

# check if there is a .container_id file
if [ -f .container_id ]; then
    # pull the container id
    CONTAINER_ID=$(cat .container_id)

    # stop the container
    docker kill $CONTAINER_ID

    # remove the container id file
    rm .container_id
fi