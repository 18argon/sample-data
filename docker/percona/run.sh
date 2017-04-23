#!/usr/bin/env bash

# Create/start a new container from the existing image

. config.sh

echo "$LINE_PREFIX Creating and starting '$CONTAINER_NAME'"
docker run --name $CONTAINER_NAME   \
    -p 3306:3306                    \
    --restart=always                \
    -e MYSQL_ROOT_PASSWORD=root     \
    -d $IMAGE_NAME
