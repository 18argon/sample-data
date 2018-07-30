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
IMAGE_VER := 10.3.8-bionic
IMAGE_NAME := mariadb-sample-data
IMAGE := stevetarver/$(IMAGE_NAME):$(IMAGE_VER)
RUN_ARGS := -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root

# This grep expression matches the container log entry indicating the db is ready
CTNR_READY_LOG_ENTRY := '^Version: .*3306'

# execute select count(*) from contacts
# NOTE: we use MYSQL_PWD to avoid parsing results that include:
#   mysql: [Warning] Using a password on the command line interface can be insecure. 500
# pass account/pass as first arg
define get_row_count
$(shell docker exec -it $(IMAGE_NAME) sh -c "export MYSQL_PWD=$(1) && mysql -u$(1) -Dtest -s --skip-column-names -e 'SELECT COUNT(*) from test.contacts;'")
endef

# I am a pre-req to 'clean' and perform non-docker cleanup
.PHONY: clean_local
clean_local:
	@rm -f seed-data.sql

seed-data.sql: ../../contacts/us-500.mysql.sql
	@cp $< seed-data.sql

# I am a pre-req to 'build' and perform all pre-build operations
setup_local: seed-data.sql

# I am a pre-req to 'test' and perform all testing on the provided, running container
.PHONY: test_local
test_local:
	$(call wait_till_container_log_contains,$(CTNR_READY_LOG_ENTRY))

	@echo "===> Testing data row count is correct"
	@if [ "$(call get_row_count,root)" != "500" ]; then \
		echo "===> ERROR: $(IMAGE_NAME) does not have the correct row count. SQL query returns:"; \
		echo "     $(call get_row_count,root)"; \
		exit 2; \
	fi

	@echo "===> Testing 'test' account access"
	@if [ "$(call get_row_count,test)" != "500" ]; then \
		echo "===> ERROR: $(IMAGE_NAME) does not allows 'test' account access to 'test' database. SQL query returns:"; \
		echo "     $(call get_row_count,test)"; \
		exit 2; \
	fi
