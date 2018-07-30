# I provide common functionality for docker image builds

define get_image_id
$$(docker images -q $(IMAGE) 2> /dev/null)
endef

define get_container_id
$$(docker ps -aq --filter name=$(IMAGE_NAME) 2> /dev/null)
endef

# return the container state; empty string if container does not exist
define get_container_status
$$(docker inspect --format="{{.State.Status}}" $(IMAGE_NAME) 2> /dev/null)
endef

# return 0 if true, 1 if false
define is_container_running
$$(test "running" = "$(call get_container_status)"; echo $$?)
endef

# returns number of container log lines that match provided grep expression
# e.g.: $(call log_contains,'Version.*3306')
define log_contains
$$(docker logs $(IMAGE_NAME) 2>&1 | grep $(1) | wc -l | sed -e 's/^[[:space:]]*//')
endef

# wait for container logs to contain 1 entry matching the provided grep expression
# e.g.: $(call wait_till_container_log_contains,'Version.*3306')
define wait_till_container_log_contains
@while [ "1" '>' "$(call log_contains,$(1))" ]; do \
	echo "Waiting for log line containing $(1)"; \
	sleep 5; \
done
endef

.PHONY: all
all: build ## build the docker image

.PHONY: archive
archive: ## push the image to docker registry
	docker push $(IMAGE)

.PHONY: bash
bash: build ## start a bash shell in the container
	docker run --rm -it $(IMAGE) bash

.PHONY: build
build: setup_local ## build the docker image
	@if [ -z "$(call get_image_id)" ]; then \
		docker build -t $(IMAGE) .; \
	fi

.PHONY: clean
clean: stop clean_local ## remove all build artifacts
	@if [ -n "$(call get_container_id)" ]; then \
		echo "===> Removing container $(IMAGE_NAME)"; \
		docker rm -v $(IMAGE_NAME); \
	fi;
	@if [ -n "$(call get_image_id)" ]; then \
		echo "===> Removing image $(IMAGE)"; \
		docker rmi -f $(IMAGE); \
	fi;
	@if [ -n "$$(docker images -q -f dangling=true 2> /dev/null)" ]; then \
		echo "===> Removing dangling images"; \
		docker rmi $(docker images -q -f dangling=true); \
	fi;

.PHONY: config
config:
	@echo "IMAGE_NAME           : $(IMAGE_NAME)"
	@echo "IMAGE_VER            : $(IMAGE_VER)"
	@echo "IMAGE                : $(IMAGE)"
	@echo "RUN_ARGS             : $(RUN_ARGS)"
	@echo "get_image_id         : $(call get_image_id)"
	@echo "get_container_id     : $(call get_container_id)"
	@echo "get_container_status : $(call get_container_status)"
	@echo "is_container_running : $(call is_container_running)"

.PHONY: create
create: build ## create a docker container
	@if [ -z "$(call get_container_id)" ]; then \
		docker create --name $(IMAGE_NAME) $(RUN_ARGS) $(IMAGE); \
	fi

.PHONY: help
help:
	@echo " Expected use:"
	@echo "  version upgrade:"
	@echo "    make         - build a new image"
	@echo "    make test    - test the image"
	@echo "    make archive - push the image to the docker registry"
	@echo "    make clean   - remove build artifacts"
	@echo
	@echo "  run a local image:"
	@echo "    make rund    - build a new image and run it detached"
	@echo
	@echo "  playground - multiple starts & stops of the same container"
	@echo "    make create  - build a new image and create a container"
	@echo "    make start   - start the container"
	@echo "    # ...        - do some stuff"
	@echo "    make stop    - stop the container"
	@echo
	@echo "Use: make [target]\n\ntarget:"
	@grep -h "##" $(MAKEFILE_LIST) | grep -v "(help\|grep)" | grep -ve '^\t' | sort | sed -e "s/:.*## / - /" -e 's/^/  /'

.PHONY: logs
logs: ## show container logs
	docker logs -f $(IMAGE_NAME)

.PHONY: run
run: build ## create and start a docker container (rm on exit)
	@if [ -z "$(call get_container_id)" ]; then \
		docker run --rm --name $(IMAGE_NAME) $(RUN_ARGS) $(IMAGE); \
	fi

.PHONY: rund
rund: build ## create and start a docker container in detached mode (rm on exit)
	@if [ -z "$(call get_container_id)" ]; then \
		docker run -d --rm --name $(IMAGE_NAME) $(RUN_ARGS) $(IMAGE); \
	fi

.PHONY: start
start: create ## start an existing docker container
	@if [ -z "$$(docker ps | grep $(IMAGE_NAME))" ]; then \
		echo "===> Starting container $(IMAGE_NAME)"; \
		docker start $(IMAGE_NAME); \
	else \
		echo "===> Container $(IMAGE_NAME) is already running"; \
	fi;

.PHONY: test
test: build rund test_local ## run test scripts against container

.PHONY: stop
stop: ## stop a running container
	@if [ -n "$$(docker ps | grep $(IMAGE_NAME))" ]; then \
		echo "===> Stopping container $(IMAGE_NAME)"; \
		docker stop $(IMAGE_NAME); \
	fi;

