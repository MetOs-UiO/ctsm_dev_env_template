#!/bin/bash

set -e

CASE_NAME=ALP1

CTSM_ROOT=/ctsm-api/resources/ctsm
CASE_PATH=/ctsm-api/resources/cases/$CASE_NAME

export CESMDATAROOT=/ctsm-api/resources/data/$CASE_NAME

rm -rf $CASE_PATH

$CTSM_ROOT/cime/scripts/create_newcase \
    --case $CASE_PATH \
    --user-mods-dirs $CESMDATAROOT/user_mods \
    --compset 2000_DATM%GSWP3v1_CLM50%FATES_SICE_SOCN_MOSART_SGLC_SWAV \
    --res CLM_USRDAT \
    --driver nuopc \
    --machine container-nlp \
    --run-unsupported \
    --handle-preexisting-dirs r

cd $CASE_PATH

./xmlchange PTS_LAT=61.0243
./xmlchange PTS_LON=8.12343
./xmlchange STOP_OPTION=nyears
./xmlchange STOP_N=1

./case.setup

echo "do_harvest = .false." >> user_nl_clm

./case.build
./case.submit
