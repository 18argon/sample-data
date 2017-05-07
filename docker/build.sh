#!/usr/bin/env bash

# Build the docker image

ECHO_PREFIX='===>'
OPERATION=$1
PRODUCT_DIR=$2

showHelp() {
    echo "Use: ./build.sh CMD TARGET"
    echo "    CMD    = build | run | teardown"
    echo "    TARGET = elasticsearch | mongo | percona | rethink"
}

# Arg validation
if [[ ! -d "$PRODUCT_DIR" || ( $OPERATION != "build" &&  $OPERATION != "run" &&  $OPERATION != "teardown")]]; then
    showHelp
    exit 1
fi

# Change docker context to build directory
cd $PRODUCT_DIR

# Import local config
. config.sh

case $OPERATION in
    build)
        echo "$ECHO_PREFIX Creating data import file"
        eval $BUILD_SETUP_CMD

        echo "$ECHO_PREFIX Building '$IMAGE_NAME'"
        docker build -t $IMAGE_NAME .

        echo "$ECHO_PREFIX Removing temporary build files"
        eval $BUILD_CLEANUP_CMD
        ;;

    run)
        echo "$ECHO_PREFIX Creating and starting '$CONTAINER_NAME'"
        eval $DOCKER_RUN_CMD
        ;;

    teardown)
        # Stop any existing containers
        RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)

        if [ "$RUNNING" == "true" ]; then
            echo "$ECHO_PREFIX Stopping '$CONTAINER_NAME' container"
            docker stop $CONTAINER_NAME
        else
            echo "$ECHO_PREFIX '$CONTAINER_NAME' container is not running"
        fi

        # Delete any existing containers and volumes
        if [[ "$(docker ps -aq --filter name=$CONTAINER_NAME 2> /dev/null)" != "" ]]; then
            echo "$ECHO_PREFIX Removing '$CONTAINER_NAME' container"
            docker rm -v $CONTAINER_NAME
        else
            echo "$ECHO_PREFIX '$CONTAINER_NAME' container does not exist"
        fi

        # Delete any existing images
        if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" != "" ]]; then
            echo "$ECHO_PREFIX Removing '$IMAGE_NAME' image"
            docker rmi -f $IMAGE_NAME
        else
            echo "$ECHO_PREFIX '$IMAGE_NAME' image does not exist"
        fi

        # Delete any orphaned (dangling) images
        if [[ "$(docker images -q -f dangling=true 2> /dev/null)" != "" ]]; then
            echo "$ECHO_PREFIX Removing dangling images"
            docker rmi -f $(docker images -q -f dangling=true)
        fi
        ;;
esac

