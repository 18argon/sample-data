## Sample data

Derived database docker images seeded with sample data.

## Contacts

US Contacts from [Brian Dunning Sample Data](https://www.briandunning.com/sample-data/). 500 contacts for free, much more for a nominal price.

## Docker images

Docker images are built via local makefiles. See `make help` for more details.

See each docker directory's README.md for more details:

* [elasticsearch](https://github.com/stevetarver/sample-data/tree/master/docker/elasticsearch)
* [mariadb](https://github.com/stevetarver/sample-data/tree/master/docker/mariadb)
* [mongo](https://github.com/stevetarver/sample-data/tree/master/docker/mongo)
* [mysql](https://github.com/stevetarver/sample-data/tree/master/docker/mysql)
* [percona](https://github.com/stevetarver/sample-data/tree/master/docker/percona)
* [postgres](https://github.com/stevetarver/sample-data/tree/master/docker/postgres)
* [rethink](https://github.com/stevetarver/sample-data/tree/master/docker/rethink)

## Build

Each `docker/*` directory contains a makefile that provides this help: `make help`

```shell
 Expected use:
  version upgrade:
    make         - build a new image
    make test    - test the image
    make archive - push the image to the docker registry
    make clean   - remove build artifacts

  run a local image:
    make rund    - build a new image and run it detached

  playground - multiple starts & stops of the same container
    make create  - build a new image and create a container
    make start   - start the container
    # ...        - do some stuff
    make stop    - stop the container

Use: make [target]

target:
  all - build the docker image
  archive - push the image to docker registry
  bash - start a bash shell in the container
  build - build the docker image
  clean - remove all build artifacts
  create - create a docker container
  logs - show container logs
  run - create and start a docker container (rm on exit)
  rund - create and start a docker container in detached mode (rm on exit)
  start - start an existing docker container
  stop - stop a running container
  test - run test scripts against container
```

Common functionality is implemented in `docker/common.mk`.

## TODO

* Make test targets wait for database to become ready
* Provide revisions on our derived image tags
