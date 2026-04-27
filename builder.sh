#!/bin/bash

REV=${1:+-$1}
CPU_ARCH="${2:-nehalem}"
UBUNTU_CODENAME="${3:-jammy}"

DOCKER_FILE="Dockerfile-${UBUNTU_CODENAME}"
DOCKER_TAG="${UBUNTU_CODENAME}-${CPU_ARCH}-custom-mongodb"
UPLOAD_DIR="${UBUNTU_CODENAME}-${CPU_ARCH}-mongodb-upload"
UPLOAD_PATH="$(pwd)/${UPLOAD_DIR}"

if [ ! -f "${DOCKER_FILE}" ]; then
	echo "Error: no ${DOCKER_FILE} for UBUNTU_CODENAME=${UBUNTU_CODENAME} (use jammy or noble)." >&2
	exit 1
fi

mkdir -p "${UPLOAD_PATH}"

docker build --file "${DOCKER_FILE}" -t "${DOCKER_TAG}" --build-arg REV="${REV}" --build-arg CPU_ARCH="${CPU_ARCH}" .
docker run --rm -v "${UPLOAD_PATH}":/tmp/output/ "${DOCKER_TAG}"
