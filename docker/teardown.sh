#!/usr/bin/env bash

# Stop running container and remove container/image

ECHO_PREFIX='===>'

# Arg validation
if [[ $1 == "" ]]; then
    echo "Use: ./teardown.sh [mongo | percona]"
    exit 1
fi

# Change docker context to build directory
cd $1

. config.sh

# Stop any existing containers
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)

if [ "$RUNNING" == "true" ]; then
    echo "$ECHO_PREFIX Stopping '$CONTAINER_NAME' container"
    docker stop $CONTAINER_NAME
else
    echo "$ECHO_PREFIX '$CONTAINER_NAME' container is not running"
fi

# Delete any existing containers and volumes
if [[ "$(docker ps -aq --filter name=$CONTAINER_NAME 2> /dev/null)" != "" ]]; then
    echo "$ECHO_PREFIX Removing '$CONTAINER_NAME' container"
    docker rm -v $CONTAINER_NAME
else
    echo "$ECHO_PREFIX '$CONTAINER_NAME' container does not exist"
fi

# Delete any existing images
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" != "" ]]; then
    echo "$ECHO_PREFIX Removing '$IMAGE_NAME' image"
    docker rmi $IMAGE_NAME
else
    echo "$ECHO_PREFIX '$IMAGE_NAME' image does not exist"
fi
