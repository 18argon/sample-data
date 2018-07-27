# I provide common functionality for docker image builds

define get_image_id
$$(docker images -q $(IMAGE) 2> /dev/null)
endef

define get_container_id
$$(docker ps -aq --filter name=$(IMAGE_NAME) 2> /dev/null)
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
	docker run --rm --name $(IMAGE_NAME) $(RUN_ARGS) $(IMAGE)

.PHONY: rund
rund: build ## create and start a docker container in detached mode (rm on exit)
	docker run -d --rm --name $(IMAGE_NAME) $(RUN_ARGS) $(IMAGE)

.PHONY: start
start: create ## start an existing docker container
	@if [ -z "$$(docker ps | grep $(IMAGE_NAME))" ]; then \
		echo "===> Starting container $(IMAGE_NAME)"; \
		docker start $(IMAGE_NAME); \
	else \
		echo "===> Container $(IMAGE_NAME) is already running"; \
	fi;

.PHONY: test
test: build test_local ## run test scripts against container

.PHONY: stop
stop: ## stop a running container
	@if [ -n "$$(docker ps | grep $(IMAGE_NAME))" ]; then \
		echo "===> Stopping container $(IMAGE_NAME)"; \
		docker stop $(IMAGE_NAME); \
	fi;

