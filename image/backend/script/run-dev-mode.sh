PRJ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..
cd ${PRJ_DIR}

export $(grep -v '^#' ../../deploy/.env.sit | xargs)

docker run \
    --name backend-api-dev-1 \
    -p 31244:80 \
    -v ${PRJ_DIR}/app:/app/app \
    --rm \
    -it \
    --network="${COMPOSE_PROJECT_NAME}_default" \
    --network-alias backend \
    --entrypoint bash \
    tom4dock/backend-api:`grep -Po "(?<=['\"])[0-9a-zA-Z\.\-]+" app/version.py`-src

