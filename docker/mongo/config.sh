#!/usr/bin/env bash

# NOTE: Data is inserted into the 'test' database by default. You can change the target db by
#       adding MONGO_INITDB_DATABASE env var to the run command:
#       -e MONGO_INITDB_DATABASE=application
#       Alternatively, one could create and use databases from the seed-data.js script

IMAGE_NAME='mongo-sample-data:3.4'
CONTAINER_NAME='mongo-sample-data'
BUILD_SETUP_CMD='cp ../../contacts/us-500.mongo.js ./seed-data.js'
BUILD_CLEANUP_CMD='rm seed-data.js'
DOCKER_RUN_CMD='docker run --name $CONTAINER_NAME -p 27017:27017 --restart=always -d $IMAGE_NAME'
