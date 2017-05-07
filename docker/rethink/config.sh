#!/usr/bin/env bash

IMAGE_NAME='rethink-sample-data:2.3.5'
CONTAINER_NAME='rethink-sample-data'
BUILD_SETUP_CMD='./1.build-setup.sh'
BUILD_CLEANUP_CMD='./3.build-cleanup.sh'
DOCKER_RUN_CMD='docker run --name $CONTAINER_NAME -p 8080:8080 -p 28015:28015 -p 29015:29015 --restart=always -d $IMAGE_NAME'

