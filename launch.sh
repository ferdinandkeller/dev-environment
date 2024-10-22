#!/bin/bash

# build the image
# run the container only if the build succeeds
docker build -t dev-env:latest . && docker run --rm -it --privileged dev-env:latest