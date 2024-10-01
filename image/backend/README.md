# README #

[XXXX]

本程式是xxxx平台API server.


## Docker安裝與使用

1. build docker images: `LICENSE_MODE=bin bash script/build-docker-image.sh`
    - LICENSE_MODE可設定為: [`dongle`, `cloud`, `date`, `bin`, `src`]
    - 預設為`LICENSE_MODE=src`
    - 產出之docker image name 為: `backend-api:{version}`
2. run container (執行前先確認script帶的環境變數是否要修改)
    - 開發模式: `bash script/run-dev-mode.sh`
        - 進container後，較為正式的開啟方式: `/start.sh`
        - 進container後，code-hot-reload模式: `/start-reload.sh`
            - code一修改程式會自動reload，適合開發中使用
    - 正式模式: `bash script/run-production-mode.sh`


## 壓版號

- `vim app/version.py`
