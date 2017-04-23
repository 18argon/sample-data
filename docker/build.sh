#!/usr/bin/env bash

# Build the docker image

ECHO_PREFIX='===>'

# Arg validation
if [[ $1 == "" ]]; then
    echo "Use: ./build.sh [mongo | percona]"
    exit 1
fi

# Change docker context to build directory
cd $1

# Import local config
. config.sh

echo "$ECHO_PREFIX Creating data import file"
eval $BUILD_SETUP_CMD

echo "$ECHO_PREFIX Building '$IMAGE_NAME'"
docker build -t $IMAGE_NAME .

echo "$ECHO_PREFIX Removing temporary build files"
eval $BUILD_CLEANUP_CMD
