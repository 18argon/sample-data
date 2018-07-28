# I:
#   define docker image vars
#   define docker run vars
#   implement the setup target
#   implement the clean_local target
#
# NOTE: mariadb, mysql, and percona makefiles should be kept in sync
#
include ../common.mk

# Common functionality depends on defining the following
# IMAGE_VER should match the base percona docker image version in Dockerfile
IMAGE_VER := 8.0.11
IMAGE_NAME := mysql-sample-data
IMAGE := stevetarver/$(IMAGE_NAME):$(IMAGE_VER)
RUN_ARGS := -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root

# I am a pre-req to 'clean' and perform non-docker cleanup
.PHONY: clean_local
clean_local:
	@rm -f seed-data.sql

seed-data.sql: ../../contacts/us-500.mysql.sql
	@cp $< seed-data.sql
	@chmod 644 seed-data.sql

# I am a pre-req to 'build' and perform all pre-build operations
setup_local: seed-data.sql

# I am a pre-req to 'test' and perform all testing on the provided, running container
.PHONY: test_local
test_local:
	@echo "===> Testing data row count is correct"
	$(eval ROW_COUNT := $(shell docker exec -it $(IMAGE_NAME) mysql -uroot -proot -Dtest -s --skip-column-names -e 'SELECT COUNT(*) from test.contacts;'))

	@# mysql prints a warning so our output looks like:
	@#  mysql: [Warning] Using a password on the command line interface can be insecure. 500
	@# we will sort the response and take the first word to capture row count
	$(eval ROW_COUNT := $(word 1, $(sort $(ROW_COUNT))))

	@if [ "$(ROW_COUNT)" == "500" ]; then \
		echo "     $(IMAGE_NAME) has the correct row count ($(ROW_COUNT))"; \
	else \
		echo "===> ERROR: $(IMAGE_NAME) does not have the correct row count. Expected: '500', Actual: '$(ROW_COUNT)'"; \
		exit 2; \
	fi

	@echo "===> Testing 'test' account access"
	$(eval ROW_COUNT := $(shell docker exec -it $(IMAGE_NAME) mysql -utest -ptest -D test -s --skip-column-names -e 'SELECT COUNT(*) from test.contacts;'))
	$(eval ROW_COUNT := $(word 1, $(sort $(ROW_COUNT))))

	@if [ "$(ROW_COUNT)" == "500" ]; then \
		echo "     $(IMAGE_NAME) allows 'test' account access to 'test' database"; \
	else \
		echo "===> ERROR: $(IMAGE_NAME) does not allows 'test' account access to 'test' database"; \
		exit 2; \
	fi
