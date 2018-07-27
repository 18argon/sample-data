# I:
#   define docker image vars
#   define docker run vars
#   implement the setup target
#   implement the clean_local target
#
include ../common.mk

# Common functionality depends on defining the following
# IMAGE_VER should match the base percona docker image version in Dockerfile
IMAGE_VER := 2.3.5
IMAGE_NAME := rethink-sample-data
IMAGE := stevetarver/$(IMAGE_NAME):$(IMAGE_VER)
RUN_ARGS := -p 8080:8080 -p 28015:28015 -p 29015:29015

TMP_CTNR := rethink-temp

# I am a pre-req to 'clean' and perform non-docker cleanup
clean_local:
	@rm -rf data get-pip* seed-data.json
	@if [ -n "$$(docker ps -aq --filter name=$(TMP_CTNR) 2> /dev/null)" ]; then \
		echo "===> Removing temp container $(TMP_CTNR)"; \
		docker rm -f -v $(TMP_CTNR); \
	fi;

seed-data.json: ../../contacts/us-500.json
	@cp $< seed-data.json

# I am a pre-req to 'build' and perform all pre-build operations
# I will create a temp rethink container, install packages to import data,
# import that data, stop and remove that container. All of this creates a
# seeded data dir that we copy into the docker image during build
setup_local: seed-data.json
	@echo "===> Creating temp rethink container '$(TMP_CTNR)'"
	@rm -rf data
	@mkdir data
	@docker run -d --name $(TMP_CTNR)   \
		-v $$(pwd)/data:/data           \
		-v $$(pwd):/tmp                 \
		rethinkdb:2.3.5

	@echo "===> Waiting 20s for container to initialize"
	@sleep 20

	@# install packages in temp container and import data
	@echo "===> Importing data"
	@docker exec $(TMP_CTNR) /tmp/import-contacts.sh

	@# stop & remove the temp container
	@docker rm -f $(TMP_CTNR)

	@# groom data dir: remove data dir log file and tmp dir
	@rm -rf data/rethinkdb_data/tmp data/rethinkdb_data/log_file

# I am a pre-req to 'test' and perform all testing on a running container
test_local:
