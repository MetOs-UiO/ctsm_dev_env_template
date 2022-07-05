#!/bin/bash

set -e

export CTSM_ROOT=/ctsm-api/resources/ctsm
export BASELINES_ROOT=/ctsm-api/resources/tests/baselines
export TESTS_ROOT=/ctsm-api/resources/tests
export CESMDATAROOT=/inputdata

GENERATE_BASELINES=0

cd $CTSM_ROOT
BASELINE_NAME=$(git describe)

HELP() {
    echo "Usage: $0 [options]"
    echo
    echo "Baseline root is $BASELINES_ROOT."
    echo
    echo "Tests root is $TESTS_ROOT."
    echo
    echo "Options:"
    echo "      -h | --help)"
    echo "          Print this help message"
    echo "      -b | --baseline)"
    echo "          Baseline name [default: $BASELINE_NAME]"
    echo "      -g | --generate-baselines)"
    echo "          Generate baselines"
    echo "      -t | --test-suite)"
    echo "          The absolute path to the test suite file"
}

while test $# -gt 0; do
    case "$1" in
        -h | --help)
            HELP
            exit 0
            ;;
        -b | --baseline)
            BASELINE_NAME=$2
            shift
            shift
            ;;
        -g | --generate-baselines)
            GENERATE_BASELINES=1
            shift
            ;;
        -t | --test-suite)
            TEST_SUITE=$2
            shift
            shift
            ;;
        *)
            HELP
            exit 1
            ;;
    esac
done

# If TEST_SUITE is not set, exit with error
if [ -z "$TEST_SUITE" ]; then
    echo "You need to set the absolute path to the test suite file with --test-suite/-t flag."
    echo
    HELP
    exit 1
fi

if [ $GENERATE_BASELINES == 1 ] ; then
    $CTSM_ROOT/cime/scripts/create_test \
    --test-root $TESTS_ROOT/$BASELINE_NAME \
    --baseline-root $BASELINES_ROOT \
    --generate $BASELINE_NAME \
    -f $TEST_SUITE
else
    $CTSM_ROOT/cime/scripts/create_test \
    --test-root $TESTS_ROOT \
    --baseline-root $BASELINES_ROOT \
    -f $TEST_SUITE
fi
