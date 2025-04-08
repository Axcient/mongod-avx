#!/bin/bash

REV=${1:+-$1}
PLATFORM="${2:-focal}"
NUM_CORES=$3

DOCKER_CONTAINER="${PLATFORM}-custom-mongodb"
DOCKER_FILE="Dockerfile-${PLATFORM}"
DOCKER_TAG="$PLATFORM-custom-mongodb"
UPLOAD_DIR="${PLATFORM}-mongodb-upload"

echo "REVISION is $REV"
echo "PLATFORM is $PLATFORM"
echo "DOCKER_CONTAINER is $DOCKER_CONTAINER"
echo "DOCKER_FILE is $DOCKER_FILE"
echo "UPLOAD_DIR is $UPLOAD_DIR"
echo "NUM_CORES is $NUM_CORES"

docker build --file "${DOCKER_FILE}" -t "${DOCKER_TAG}" --build-arg REV="${REV}" --build-arg NUM_CORES="${NUM_CORES}" .
docker container rm -f "${DOCKER_CONTAINER}" 2>/dev/null || true

mkdir -p "${UPLOAD_DIR}" && rm -rf "${UPLOAD_DIR:?}/*"

docker create -it --name="${DOCKER_CONTAINER}" "${DOCKER_TAG}" -e REV="${REV}" --build-arg NUM_CORES="${NUM_CORES}" bash
docker cp "${DOCKER_CONTAINER}":/tmp/output/mongod.zip "${UPLOAD_DIR}"

docker container rm -f "${DOCKER_CONTAINER}" || true
