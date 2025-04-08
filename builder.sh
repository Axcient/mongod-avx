#!/bin/bash

REV=${1:+-$1}
PLATFORM="${2:-focal}"
NUM_CORES="${3:-4}"

DOCKER_FILE="Dockerfile-${PLATFORM}"
DOCKER_TAG="$PLATFORM-custom-mongodb"
UPLOAD_DIR="${PLATFORM}-mongodb-upload"

docker build --file "${DOCKER_FILE}" -t "${DOCKER_TAG}" --build-arg REV="${REV}" --build-arg NUM_CORES="${NUM_CORES}" .
docker run --rm -v "${UPLOAD_DIR}":/tmp/output/ "${DOCKER_TAG}"
