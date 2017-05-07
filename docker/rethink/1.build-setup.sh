#!/usr/bin/env bash
#
# Create a temp container, install packages to import data and then import it
#

. 0.build-config.sh

echo "$ECHO_PREFIX Setting up temp files"
mkdir $(pwd)/data
cp ../../contacts/us-500.json ./seed-data.json

echo "$ECHO_PREFIX Creating temp container '$CONTAINER_NAME'"
docker run --name $CONTAINER_NAME   \
    -v $(pwd)/data:/data            \
    -v $(pwd):/tmp                  \
    -d $IMAGE_NAME

echo "$ECHO_PREFIX Waiting 20s for container to initialize"
sleep 20

# install packages in temp container and import data
echo "$ECHO_PREFIX Importing data"
docker exec $CONTAINER_NAME /tmp/2.build-import-contacts.sh

# remove data dir log file and tmp dir
rm -rf data/rethinkdb_data/tmp data/rethinkdb_data/log_file