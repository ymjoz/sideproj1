#!/bin/bash -e
PRJ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..
cd ${PRJ_DIR}

export DOCKER_BUILDKIT=1

# CHANGE THIS {DOCKER_IMAGE_NAME}.
DOCKER_IMAGE_NAME="tom4dock/backend-api"
VERSION=`grep -Po "(?<=['\"])[0-9a-zA-Z\.\-]+" app/version.py`

# LICENSE_MODE 支援: ['dongle', 'cloud', 'date', 'bin', 'src', 'hw-date'], 預設 src
LICENSE_MODE="${LICENSE_MODE:-src}"
LICENSE_TICK_SEC="${LICENSE_TICK_SEC:-30}"
LICENSE_MAX_RETRIES="${LICENSE_MAX_RETRIES:-5}"
CLOUD_LICENSE_SERVER_BIND="${CLOUD_LICENSE_SERVER_BIND:-http://license.itri-nlp.tw:9453}"

repo_and_tag="${DOCKER_IMAGE_NAME}:${VERSION}-${LICENSE_MODE}"

echo "Building... (version: ${repo_and_tag})"

docker build \
    --network=host \
    --build-arg LICENSE_MODE=${LICENSE_MODE} \
    --build-arg LICENSE_MAX_RETRIES=${LICENSE_MAX_RETRIES} \
    --build-arg LICENSE_TICK_SEC=${LICENSE_TICK_SEC} \
    --build-arg DATE_LICENSE_YEAR=${DATE_LICENSE_YEAR} \
    --build-arg DATE_LICENSE_MONTH=${DATE_LICENSE_MONTH} \
    --build-arg DATE_LICENSE_DAY=${DATE_LICENSE_DAY} \
    --build-arg CLOUD_LICENSE_DISABLE_TOKEN=${CLOUD_LICENSE_DISABLE_TOKEN} \
    --build-arg CLOUD_LICENSE_APP_ID=${CLOUD_LICENSE_APP_ID} \
    --build-arg CLOUD_LICENSE_SERVER_BIND=${CLOUD_LICENSE_SERVER_BIND} \
    --build-arg DONGLE_LICENSE_FEAT_ID=${DONGLE_LICENSE_FEAT_ID} \
    --build-arg HW_DATE_LICENSE_PUBLIC_KEY=${HW_DATE_LICENSE_PUBLIC_KEY} \
    --force-rm \
    --tag $repo_and_tag \
    -f Dockerfile \
    .