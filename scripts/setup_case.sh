#!/bin/bash

set -e

HELP() {
    echo
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "      -h | --help)"
    echo "          Print this help message"
    echo "      -n | --name)"
    echo "          Case name"
    echo "      -c | --compset"
    echo "          Compset to use for the case"
}

while test $# -gt 0; do
    case "$1" in
        -h | --help)
            HELP
            exit 0
            ;;
        -n | --name)
            CASE_NAME=$2
            shift
            shift
            ;;
        -c | --compset)
            COMPSET=$2
            shift
            shift
            ;;
        *)
            HELP
            exit 1
            ;;
    esac
done

# If CASE_NAME or COMPSET are not set, exit with error
if [ -z "$CASE_NAME" ] || [ -z "$COMPSET" ]; then
    echo
    echo "Both case name and compset must be set."
    HELP
    exit 1
fi

CTSM_ROOT=/ctsm-api/resources/ctsm
CASE_PATH=/ctsm-api/resources/cases/$CASE_NAME

export CESMDATAROOT=/ctsm-api/resources/data/$CASE_NAME

rm -rf $CASE_PATH

$CTSM_ROOT/cime/scripts/create_newcase \
    --case $CASE_PATH \
    --user-mods-dirs $CESMDATAROOT/user_mods \
    --compset $COMPSET \
    --res CLM_USRDAT \
    --driver nuopc \
    --machine docker \
    --run-unsupported \
    --handle-preexisting-dirs r

cd $CASE_PATH

./case.setup

echo "Case is ready in $CASE_PATH"
