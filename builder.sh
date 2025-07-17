#!/bin/bash

REV=${1:+-$1}
PLATFORM="${2:-focal}"
NUM_CORES="${3:-4}"
CPU_ARCH="${4:-nehalem}"

DOCKER_FILE="Dockerfile-${PLATFORM}"
DOCKER_TAG="${PLATFORM}-${CPU_ARCH}-custom-mongodb"
UPLOAD_DIR="${PLATFORM}-${CPU_ARCH}-mongodb-upload"

docker build --file "${DOCKER_FILE}" -t "${DOCKER_TAG}" --build-arg REV="${REV}" --build-arg NUM_CORES="${NUM_CORES}" --build-arg CPU_ARCH="${CPU_ARCH}" .
docker run --rm -v "${UPLOAD_DIR}":/tmp/output/ "${DOCKER_TAG}"
