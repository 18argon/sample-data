#!/usr/bin/env bash

# Build percona-sample-data:5.7 image

. config.sh

# Prepend a 'test' schema and user create to our contacts dump
echo "$LINE_PREFIX Creating data import file"
cat test-schema.sql ../../contacts/us-500.sql > us-500.sql

echo "$LINE_PREFIX Building '$IMAGE_NAME'"
docker build -t $IMAGE_NAME .

