# I:
#   define docker image vars
#   define docker run vars
#   implement the setup target
#   implement the clean_local target
#
include ../common.mk

# Common functionality depends on defining the following
# IMAGE_VER should match the base percona docker image version in Dockerfile
IMAGE_VER := 5.4
IMAGE_NAME := elasticsearch-sample-data
IMAGE := stevetarver/$(IMAGE_NAME):$(IMAGE_VER)
RUN_ARGS := -p 9200:9200 -p 9300:9300 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1"

# I am a pre-req to 'clean' and perform non-docker cleanup
clean_local:

# I am a pre-req to 'build' and perform all pre-build operations
setup_local:

# I am a pre-req to 'test' and perform all testing on the provided, running container
test_local:
	@echo "===> Testing data row count is correct"
	$(eval ROW_COUNT := $(shell curl -s elastic:changeme@localhost:9200/_cat/count/contacts))

	@# ROW_COUNT is the third word in the result
	$(eval ROW_COUNT := $(word 3, $(ROW_COUNT)))

	@if [ "$(ROW_COUNT)" == "500" ]; then \
		echo "     $(IMAGE_NAME) has the correct row count ($(ROW_COUNT))"; \
	else \
		echo "===> ERROR: $(IMAGE_NAME) does not have the correct row count. Expected: '500', Actual: '$(ROW_COUNT)'"; \
		exit 2; \
	fi
