# README

[TOC]

## 簡介

本系統為XXXX平臺佈署環境.

## Docker-Compose 啟動使用

- 後端 API 服務佈署

  - 目錄
    - `backend/`

  - `docker-compose.yaml`佈署服務說明

    - mongo: MongoDB 服務
    - mongo-express: MongoDB Web GUI
    - tom4dock/backend-api:  xxx平臺後端 API server

  - 使用
    - 啟動: `docker compose up -d`
    - 停止: `docker compose down`
    - test: `docker compose --env-file .env up -d certbot-renew --remove-orphans` 
    > 可以清理掉 certbot-init 容器，並且只保留 certbot-renew 容器
    

- 前台 UI 服務佈署

  - 目錄
    - `frontend/`

  - `docker-compose.yaml`佈署服務說明
    - jointdefense-ui-dev: xx平臺前端 UI

### 初始申請SSL憑證與後續憑證自動renew
- 使用docker compose 時，需調整 .env 內容
  - 使用 first-step-nginx.conf
```bash
NGINX_CONF_FILE=./first-step-nginx.conf 
``` 
  - SSL成功後，調整 .env
```bash
NGINX_CONF_FILE=./nginx.conf 
```

### 實驗性功能

-  網站進入維護模式
```bash
cd ~/3-3a/deploy
bash toggle_maintenance.sh on
```
- 結束維護模式
```bash
cd ~/3-3a/deploy
bash toggle_maintenance.sh off
```
