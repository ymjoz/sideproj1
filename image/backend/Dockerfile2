# 1. cpython environment (compilable environment)
# 支援ARM64架構 
FROM tiangolo/uvicorn-gunicorn:python3.11 AS cpython-builder


# apt-get
RUN apt-get update --fix-missing && apt-get install -y \
  dos2unix \
  build-essential \
  gcc

# install cython & nuitka
RUN pip install Cython==0.29.28
RUN pip install nuitka==0.7

# 2. use builder to build binary code
FROM cpython-builder AS build-stage

WORKDIR /compilable-dir
COPY ./ .

ARG LICENSE_MODE=none
ENV LICENSE_MODE=${LICENSE_MODE}

ARG LICENSE_TICK_SEC=30
ENV LICENSE_TICK_SEC=${LICENSE_TICK_SEC}

ARG LICENSE_MAX_RETRIES=5
ENV LICENSE_MAX_RETRIES=${LICENSE_MAX_RETRIES}

# LICENSE_MODE=date settings
ARG DATE_LICENSE_YEAR
ENV DATE_LICENSE_YEAR=${DATE_LICENSE_YEAR}

ARG DATE_LICENSE_MONTH
ENV DATE_LICENSE_MONTH=${DATE_LICENSE_MONTH}

ARG DATE_LICENSE_DAY
ENV DATE_LICENSE_DAY=${DATE_LICENSE_DAY}

# LICENSE_MODE=cloud settings
ARG CLOUD_LICENSE_DISABLE_TOKEN
ENV CLOUD_LICENSE_DISABLE_TOKEN=${CLOUD_LICENSE_DISABLE_TOKEN}

ARG CLOUD_LICENSE_APP_ID
ENV CLOUD_LICENSE_APP_ID=${CLOUD_LICENSE_APP_ID}

ARG CLOUD_LICENSE_SERVER_BIND
ENV CLOUD_LICENSE_SERVER_BIND=${CLOUD_LICENSE_SERVER_BIND}

# LICENSE_MODE=dongle settings
ARG DONGLE_LICENSE_FEAT_ID
ENV DONGLE_LICENSE_FEAT_ID=${DONGLE_LICENSE_FEAT_ID}

# LICENSE_MODE=hw-date settings
ARG HW_DATE_LICENSE_PUBLIC_KEY
ENV HW_DATE_LICENSE_PUBLIC_KEY=${HW_DATE_LICENSE_PUBLIC_KEY}

RUN python setup.py build

# app_build post-processing
RUN dos2unix /compilable-dir/app_build/install/*.sh || true
RUN dos2unix /compilable-dir/app_build/install/dongle_driver/*.sh || true
RUN dos2unix /compilable-dir/app_build/docker-entrypoint.sh || true
RUN chmod 777 /compilable-dir/app_build/docker-entrypoint.sh || true

# app_stage post-processing
RUN rm -rf /compilable-dir/app_stage/itri_usb_license* || true
RUN cp /compilable-dir/app_build/itri_usb_license* /compilable-dir/app_stage/. || true
RUN rm -rf /compilable-dir/app_stage/license_tick_check* || true
RUN cp /compilable-dir/app_build/license_tick_check* /compilable-dir/app_stage/. || true

# A. export binary code
FROM scratch AS export_build
COPY --from=build-stage /compilable-dir/app_build /

# B. export stage code
FROM scratch AS export_stage
COPY --from=build-stage /compilable-dir/app_stage /

# 3. build production image
FROM tiangolo/uvicorn-gunicorn:python3.11

ARG LICENSE_MODE=none
ENV LICENSE_MODE=${LICENSE_MODE}

ENV DONGLE_LICENSE_SERVER_HOST=127.0.0.1
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Taipei

# change timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# dumb-init
# RUN apt-get install -y wget
RUN apt-get clean && apt-get autoclean && apt-get update && apt-get install -y wget
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_aarch64 && chmod +x /usr/local/bin/dumb-init && ln -s /usr/local/bin/dumb-init /usr/bin/dumb-init

ENTRYPOINT ["/usr/bin/dumb-init", "--", "bash", "docker-entrypoint.sh"]

WORKDIR /app/app
COPY --from=build-stage /compilable-dir/app_build /app/app

# upgrade pip
RUN pip install --upgrade pip

# begin: 安裝 Rust: 在hhkb3host上安裝時，不再需要安裝Rust..why?
# 嘗試安裝 orjson 套件時，需要 Rust 和 Cargo 來編譯擴展，但是在系統中找不到 Rust 或 Cargo。這是因為 orjson 是用 Rust 語言寫的，並且需要 Rust 工具鏈來編譯。
# 安裝 Rust 和 Cargo
# RUN apt-get update && \
#   apt-get install -y curl && \
#   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
#   . $HOME/.cargo/env && \
#   rm -rf /var/lib/apt/lists/*

# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ENV PATH="/root/.cargo/bin:${PATH}"
# end: 安裝 Rust


# install python package
RUN pip install -r install/requirements2.txt

# install dongle driver
RUN if [ "${LICENSE_MODE}" = "dongle" ] ; \
  then \
  echo "Installing dongle driver..."; \
  bash -e install/dongle_driver/install_license_driver.sh; \
  cp install/dongle_driver/hasplm.ini /etc/hasplm/hasplm.ini; \
  fi

EXPOSE 80