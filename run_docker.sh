#!/bin/bash

# If .env does not exist, exit with error
if [ ! -f .env ]; then
    echo "You need to create a .env file in the project root directory. See env.example for an example."
    exit 1
fi

source .env
if [ ! -d ctsm ]; then
    echo "Cloning ctsm repository from $CTSM_REPO"
    git clone $CTSM_REPO ctsm

    cd ctsm
    echo "Checking out branch $CTSM_BRANCH"
    git switch $CTSM_TAG

    echo "Checking out ctsm externals"
    ./manage_externals/checkout_externals

    cd ..
fi

docker run \
    --rm \
    -it \
    --entrypoint /ctsm-api/docker/entrypoint_api.sh \
    -e HOST_USER=${USER} \
    -e HOST_UID=${UID} \
    -e HOST_GID=${GID} \
    -v $(pwd)/docker/entrypoint_api.sh:/ctsm-api/docker/entrypoint_api.sh \
    -v $(pwd)/docker/dotcime:/ctsm-api/resources/dotcime \
    -v $(pwd)/.env:/ctsm-api/.env \
    -v $(pwd)/ctsm:/ctsm-api/resources/ctsm \
    -v $(pwd)/cases:/ctsm-api/resources/cases \
    -v $(pwd)/data:/ctsm-api/resources/data \
    ghcr.io/noresmhub/ctsm-api:latest
