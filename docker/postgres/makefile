# I:
#   define docker image vars
#   define docker run vars
#   implement the setup target
#   implement the clean_local target
#
include ../common.mk

# Common functionality depends on defining the following
# IMAGE_VER should match the base percona docker image version in Dockerfile
IMAGE_VER := 10.4-alpine
IMAGE_NAME := postgres-sample-data
IMAGE := stevetarver/$(IMAGE_NAME):$(IMAGE_VER)
RUN_ARGS := -p 5432:5432 -e POSTGRES_PASSWORD=postgres

# I am a pre-req to 'clean' and perform non-docker cleanup
clean_local:

# I am a pre-req to 'build' and perform all pre-build operations
setup_local:

# I am a pre-req to 'test' and perform all testing on a running container
test_local:
	$(eval ROW_COUNT := $(shell docker exec -it $(IMAGE_NAME) psql -t -U postgres -d test -c 'SELECT COUNT(*) FROM contacts;'))
	@if [ "$(ROW_COUNT)" == "500" ]; then \
		echo "===> $(IMAGE_NAME) has the correct row count ($(ROW_COUNT))"; \
	else \
		echo "===> $(IMAGE_NAME) does not have the correct row count ($(ROW_COUNT))"; \
		exit 2; \
	fi
