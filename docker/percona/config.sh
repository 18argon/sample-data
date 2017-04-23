#!/usr/bin/env bash

IMAGE_NAME='percona-sample-data:5.7'
CONTAINER_NAME='percona-sample-data'
BUILD_SETUP_CMD='cat test-schema.sql ../../contacts/us-500.mysql.sql > seed-data.sql'
BUILD_CLEANUP_CMD='rm seed-data.sql'
DOCKER_RUN_CMD='docker run --name $CONTAINER_NAME -p 3306:3306 --restart=always -e MYSQL_ROOT_PASSWORD=root -d $IMAGE_NAME'
