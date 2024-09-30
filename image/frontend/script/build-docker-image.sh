#!/bin/bash -e
PRJ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..
cd ${PRJ_DIR}

# CHANGE THIS {DOCKER_IMAGE_NAME}.
DOCKER_IMAGE_NAME="sideproj-ui"
# VERSION=`grep -Po "(?<=['\"])[0-9a-zA-Z\.\-]+" ./version.txt`
VERSION=$(grep -Po '"version": "\K.*?(?=")' ${PRJ_DIR}/package.json)

VUE_APP_API_HOST="${VUE_APP_API_HOST:-https://https://rag.helenfit.com:31244/v1}"
VUE_APP_DEV_MODE="${VUE_APP_DEV_MODE:-false}"

repo_and_tag="${DOCKER_IMAGE_NAME}:${VERSION}"

echo "Building... (version: ${repo_and_tag})"

docker build \
    --network=host \
    --build-arg VUE_APP_API_HOST=${VUE_APP_API_HOST} \
    --build-arg VUE_APP_DEV_MODE=${VUE_APP_DEV_MODE} \
    --force-rm \
    --tag $repo_and_tag \
    -f Dockerfile \
    .
# docker build \
#     --network=host \
#     --force-rm \
#     --tag $repo_and_tag \
#     -f Dockerfile \
#     .