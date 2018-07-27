#!/usr/bin/env bash
#
# Run on rethinkdb temp container, install packages and import contacts to create a local
# data dir that we can use to seed the final image
#

echo "===> Installing packages for rethink import"
apt-get update -q && \
apt-get install -y -qq apt-utils wget python && \
cd /tmp && \
wget -q https://bootstrap.pypa.io/get-pip.py && \
python get-pip.py && \
pip install rethinkdb

# verify install succeeded
if [ $? != 0 ]; then
   echo "===> Temp container package install failed with exit code $?"
   exit $?
fi

echo "===> Importing contacts into rethink"
rethinkdb import -f /tmp/seed-data.json --table test.contacts


# no need to clean up - this is a temp container