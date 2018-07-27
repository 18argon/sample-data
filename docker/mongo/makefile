# I:
#   define docker image vars
#   define docker run vars
#   implement the setup target
#   implement the clean_local target
#
# NOTE: Data is inserted into the 'test' database by default. You can change the target db by
#       adding MONGO_INITDB_DATABASE env var to the run command:
#       -e MONGO_INITDB_DATABASE=application
#       Alternatively, one could create and use databases from the seed-data.js script
include ../common.mk

# Common functionality depends on defining the following
# IMAGE_VER should match the base percona docker image version in Dockerfile
IMAGE_VER := 3.4
IMAGE_NAME := mongo-sample-data
IMAGE := stevetarver/$(IMAGE_NAME):$(IMAGE_VER)
RUN_ARGS := -p 27017:27017

# I am a pre-req to 'clean' and perform non-docker cleanup
clean_local:
	@rm -f seed-data.js

seed-data.js: ../../contacts/us-500.mongo.js
	cp $< seed-data.js

# I am a pre-req to 'build' and perform all pre-build operations
setup: seed-data.js

