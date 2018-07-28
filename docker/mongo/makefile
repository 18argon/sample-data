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

# I am a pre-req to 'build' and perform all pre-build operations
setup_local:

# I am a pre-req to 'test' and perform all testing on the provided, running container
test_local:
	@echo "===> Testing data doc count is correct"
	$(eval ROW_COUNT := $(shell docker exec -it $(IMAGE_NAME) mongo test --quiet --eval 'db.contacts.count();'))

	@if [ "$(ROW_COUNT)" == "500" ]; then \
		echo "     $(IMAGE_NAME) has the correct row count ($(ROW_COUNT))"; \
	else \
		echo "===> ERROR: $(IMAGE_NAME) does not have the correct row count. Expected: '500', Actual: '$(ROW_COUNT)'"; \
		exit 2; \
	fi
