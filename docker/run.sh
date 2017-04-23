#!/usr/bin/env bash

# Create/start a new container from the existing image

ECHO_PREFIX='===>'

# Arg validation
if [[ $1 == "" ]]; then
    echo "Use: ./run.sh [mongo | percona]"
    exit 1
fi

# Change docker context to build directory
cd $1

. config.sh

echo "$ECHO_PREFIX Creating and starting '$CONTAINER_NAME'"
eval $DOCKER_RUN_CMD
