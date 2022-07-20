#!/bin/bash

set -e

source .env

CONTAINER=$(docker images -q -f "reference=ctsm-dev-jupyter:latest")
if [ -z "$CONTAINER" ]; then
    docker build -t ctsm-dev-jupyter:latest ./docker/jupyter
fi

docker run \
    --rm \
    -it \
    -e NB_USER=${HOST_USER:-jovyan} \
    -e NB_UID=${HOST_UID:-1000} \
    -e NB_GID=${HOST_GID:-100} \
    -e CHOWN_HOME=yes \
    -e CHOWN_HOME_OPTS=-R \
    --workdir /home/${HOST_USER:-jovyan} \
    -v $(pwd)/notebooks:/home/${HOST_USER:-jovyan}/notebooks \
    -v $(pwd)/cases:/home/${HOST_USER:-jovyan}/cases \
    -v $(pwd)/data:/home/${HOST_USER:-jovyan}/data \
    -p ${JUPYTER_PORT:-8888}:8888 \
    ctsm-dev-jupyter:latest
