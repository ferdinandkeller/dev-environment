#!/bin/bash

# build the image
# run the container only if the build succeeds
docker build -t dev-env:latest . && docker run --rm -it dev-env:latest