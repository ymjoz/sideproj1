PRJ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..
cd ${PRJ_DIR}

export $(grep -v '^#' ../../deploy/.env.sit | xargs)

# 刪除先前已建立的 Docker 網絡（如果存在）
docker network rm "${COMPOSE_PROJECT_NAME}_default" 2>/dev/null || true

# 創建新的 Docker 網絡
docker network create "${COMPOSE_PROJECT_NAME}_default"

docker run \
    --name spj-ui-dev \
    -p 17281:3000 \
    -v ${PRJ_DIR}:/app \
    --workdir=/app \
    --rm \
    -it \
    --network="${COMPOSE_PROJECT_NAME}_default" \
    --network-alias frontend \
    --entrypoint sh \
    node:18-alpine
