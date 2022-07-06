#!/bin/bash

set -e

# If .env does not exist, exit with error
if [ ! -f .env ]; then
    echo "You need to create a .env file in the project root directory. See env.example for an example."
    exit 1
fi

source .env

# If INPUTDATA var is not set, exit with error
if [ -z "$INPUTDATA" ]; then
    echo "You need to set the INPUTDATA variable in your .env file."
    exit 1
fi

if [ ! -d ctsm ]; then
    echo "Cloning ctsm repository from $CTSM_REPO"
    git clone $CTSM_REPO ctsm

    cd ctsm
    echo "Checking out branch $CTSM_BRANCH"
    git checkout $CTSM_TAG

    echo "Checking out ctsm externals"
    ./manage_externals/checkout_externals

    cd ..
fi

docker run \
    --rm \
    -it \
    --entrypoint /ctsm-api/docker/entrypoint.sh \
    -e HOST_USER=${USER} \
    -e HOST_UID=${UID} \
    -e HOST_GID=${GID} \
    -v $(pwd)/docker/entrypoint.sh:/ctsm-api/docker/entrypoint.sh \
    -v $(pwd)/docker/dotcime:/ctsm-api/resources/dotcime \
    -v $(pwd)/ctsm:/ctsm-api/resources/ctsm \
    -v $(pwd)/scripts:/ctsm-api/scripts \
    -v $(pwd)/cases:/ctsm-api/resources/cases \
    -v $(pwd)/data:/ctsm-api/resources/data \
    -v $(pwd)/tests:/ctsm-api/resources/tests \
    -v $INPUTDATA:/inputdata \
    ghcr.io/noresmhub/ctsm-api:latest
