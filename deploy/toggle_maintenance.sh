#!/bin/bash

set -e

COMPOSE_FILE="docker-compose.yaml"
NGINX_CONF="nginx.conf"

# 切換維護模式
if [ "$1" == "on" ]; then
    echo "Turning maintenance mode ON"
    sed -i 's/MAINTENANCE_MODE=0/MAINTENANCE_MODE=1/' $COMPOSE_FILE
    sed -i 's/set $maintenance 0;/set $maintenance 1;/' $NGINX_CONF
elif [ "$1" == "off" ]; then
    echo "Turning maintenance mode OFF"
    sed -i 's/MAINTENANCE_MODE=1/MAINTENANCE_MODE=0/' $COMPOSE_FILE
    sed -i 's/set $maintenance 1;/set $maintenance 0;/' $NGINX_CONF
else
    echo "Usage: $0 [on|off]"
    exit 1
fi

# 驗證更改
echo "Verifying changes..."
grep MAINTENANCE_MODE $COMPOSE_FILE
grep "set \$maintenance" $NGINX_CONF

# 重新創建並啟動 Nginx 容器
echo "Recreating Nginx container..."
docker compose up -d --force-recreate nginx

# 等待 Nginx 容器啟動
echo "Waiting for Nginx to start..."
sleep 2

# 檢查 Nginx 配置
echo "Checking Nginx configuration..."
docker exec spj-prod-nginx-1 nginx -T | grep maintenance

echo "Maintenance mode toggle complete. Please verify the website status."
