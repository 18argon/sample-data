#!/usr/bin/env bash

IMAGE_NAME='elasticsearch-sample-data:5.4'
CONTAINER_NAME='elasticsearch-sample-data'
BUILD_SETUP_CMD='cp ../../contacts/us-500.elasticsearch ./seed-data.json'
BUILD_CLEANUP_CMD='rm seed-data.json'
DOCKER_RUN_CMD='docker run --name $CONTAINER_NAME -p 9200:9200 -p 9300:9300 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" --restart=always -d $IMAGE_NAME'
