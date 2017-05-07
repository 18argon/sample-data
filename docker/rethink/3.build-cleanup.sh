#!/usr/bin/env bash
#
# Clean temp container and data files used during build
#

. 0.build-config.sh

echo "$ECHO_PREFIX Removing temp files"
rm -rf data get-pip* seed-data.json

# Stop running containers
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

