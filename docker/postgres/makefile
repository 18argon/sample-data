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

# I am a pre-req to 'test' and perform all testing on the provided, running container
test_local:
	@echo "===> Testing data row count is correct"
	$(eval ROW_COUNT := $(shell docker exec -it $(IMAGE_NAME) psql postgres://postgres@localhost/test -t -c 'SELECT COUNT(*) FROM test.contacts;'))

	@if [ "$(ROW_COUNT)" == "500" ]; then \
		echo "     $(IMAGE_NAME) has the correct row count ($(ROW_COUNT))"; \
	else \
		echo "===> ERROR: $(IMAGE_NAME) does not have the correct row count. Expected: '500', Actual: '$(ROW_COUNT)'"; \
		exit 2; \
	fi

	@echo "===> Testing 'test' account access"
	$(eval ROW_COUNT := $(shell docker exec -it $(IMAGE_NAME) psql postgres://test:dGVzdA==@localhost/test -t -c 'SELECT COUNT(*) FROM test.contacts;'))

	@if [ "$(ROW_COUNT)" == "500" ]; then \
		echo "     $(IMAGE_NAME) allows 'test' account access to 'test' database"; \
	else \
		echo "===> ERROR: $(IMAGE_NAME) does not allows 'test' account access to 'test' database"; \
		exit 2; \
	fi
