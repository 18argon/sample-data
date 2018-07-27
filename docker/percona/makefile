# I:
#   define docker image vars
#   define docker run vars
#   implement the setup target
#   implement the clean_local target
#
include ../common.mk

# Common functionality depends on defining the following
# IMAGE_VER should match the base percona docker image version in Dockerfile
IMAGE_VER := 5.7
IMAGE_NAME := percona-sample-data
IMAGE := stevetarver/$(IMAGE_NAME):$(IMAGE_VER)
RUN_ARGS := -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root

# I am a pre-req to 'clean' and complete non-docker cleanup
clean_local:
	@rm -f seed-data.sql

seed-data.sql: ../../contacts/us-500.mysql.sql
	## Prepend our test schema to the contacts schema
	@cat test-schema.sql $< > seed-data.sql

# I am a pre-req to 'build' and complete all pre-build operations
setup: seed-data.sql

