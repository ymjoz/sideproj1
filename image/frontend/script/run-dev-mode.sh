PRJ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..
cd ${PRJ_DIR}

export $(grep -v '^#' ../../deploy/.env.sit | xargs)

docker network create "${COMPOSE_PROJECT_NAME}_default"

docker run \
    --name spj-ui-dev \
    -p 3011:3000 \
    -v ${PRJ_DIR}:/app \
    --workdir=/app \
    --rm \
    -it \
    --network="${COMPOSE_PROJECT_NAME}_default" \
    --network-alias frontend \
    --entrypoint sh \
    node:18-alpine

