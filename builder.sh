#!/bin/bash

REV=${1:+-$1}
CPU_ARCH="${2:-nehalem}"

DOCKER_FILE="Dockerfile-jammy"
DOCKER_TAG="jammy-${CPU_ARCH}-custom-mongodb"
UPLOAD_DIR="jammy-${CPU_ARCH}-mongodb-upload"
UPLOAD_PATH="$(pwd)/${UPLOAD_DIR}"

mkdir -p "${UPLOAD_PATH}"

docker build --file "${DOCKER_FILE}" -t "${DOCKER_TAG}" --build-arg REV="${REV}" --build-arg CPU_ARCH="${CPU_ARCH}" .
docker run --rm -v "${UPLOAD_PATH}":/tmp/output/ "${DOCKER_TAG}"
