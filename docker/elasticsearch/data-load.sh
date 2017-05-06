#!/usr/bin/env bash

# Give es some time to start
sleep 60

# only load data if the contacts index does not exist
if [[ "$(curl elastic:changeme@localhost:9200/_cat/indices 2>/dev/null | grep contacts)" == "" ]]; then
    echo "Loading data from /seed-data/seed-data.json"
    curl -s -H "Content-Type: application/x-ndjson" -XPOST "elastic:changeme@localhost:9200/_bulk" --data-binary "@/seed-data/seed-data.json"
fi

