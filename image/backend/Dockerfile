##### 1. cpython 環境 (可編譯的環境) #####

FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-2023-05-22 AS cpython-builder
LABEL maintainer="Tom <tom@itri.org.tw>"
# apt-get
RUN apt-get update --fix-missing && apt-get install -y \
  dos2unix

# install cython & nuitka
RUN pip install Cython==0.29.28
RUN pip install nuitka==0.7

##### 2. use builder to build binary code #####

FROM cpython-builder AS build-stage

WORKDIR /compilable-dir

COPY ./ .

ARG LICENSE_MODE=none
ENV LICENSE_MODE=${LICENSE_MODE}
ARG LICENSE_TICK_SEC=30
ENV LICENSE_TICK_SEC=${LICENSE_TICK_SEC}
ARG LICENSE_MAX_RETRIES=5
ENV LICENSE_MAX_RETRIES=${LICENSE_MAX_RETRIES}

# LICENSE_MODE=date 時所需設定的值
ARG DATE_LICENSE_YEAR
ENV DATE_LICENSE_YEAR=${DATE_LICENSE_YEAR}
ARG DATE_LICENSE_MONTH
ENV DATE_LICENSE_MONTH=${DATE_LICENSE_MONTH}
ARG DATE_LICENSE_DAY
ENV DATE_LICENSE_DAY=${DATE_LICENSE_DAY}

# LICENSE_MODE=cloud 時所需設定的值
ARG CLOUD_LICENSE_DISABLE_TOKEN
ENV CLOUD_LICENSE_DISABLE_TOKEN=${CLOUD_LICENSE_DISABLE_TOKEN}
ARG CLOUD_LICENSE_APP_ID
ENV CLOUD_LICENSE_APP_ID=${CLOUD_LICENSE_APP_ID}
ARG CLOUD_LICENSE_SERVER_BIND
ENV CLOUD_LICENSE_SERVER_BIND=${CLOUD_LICENSE_SERVER_BIND}

# LICENSE_MODE=dongle 時所需設定的值
ARG DONGLE_LICENSE_FEAT_ID
ENV DONGLE_LICENSE_FEAT_ID=${DONGLE_LICENSE_FEAT_ID}

# LICENSE_MODE=hw-date 時所需設定的值
ARG HW_DATE_LICENSE_PUBLIC_KEY
ENV HW_DATE_LICENSE_PUBLIC_KEY=${HW_DATE_LICENSE_PUBLIC_KEY}

RUN python setup.py build

# app_build後處理
RUN dos2unix /compilable-dir/app_build/install/*.sh || true
RUN dos2unix /compilable-dir/app_build/install/dongle_driver/*.sh || true
RUN dos2unix /compilable-dir/app_build/docker-entrypoint.sh || true
RUN chmod 777 /compilable-dir/app_build/docker-entrypoint.sh || true

# app_stage後處理
# 下面兩個授權特殊檔案要從build複製過來.如此一來stage才能執行.
# 備註: || true 的用意是讓非license模式也視為正常.
RUN rm -rf /compilable-dir/app_stage/itri_usb_license* || true
RUN cp /compilable-dir/app_build/itri_usb_license* /compilable-dir/app_stage/. || true
RUN rm -rf /compilable-dir/app_stage/license_tick_check* || true
RUN cp /compilable-dir/app_build/license_tick_check* /compilable-dir/app_stage/. || true

##### A. export binary code #####

FROM scratch AS export_build
COPY --from=build-stage /compilable-dir/app_build /

##### B. export stage code #####

FROM scratch AS export_stage
COPY --from=build-stage /compilable-dir/app_stage /

##### 3. build production image #####

FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-2023-05-22

ARG LICENSE_MODE=none

ENV LICENSE_MODE=${LICENSE_MODE}
ENV DONGLE_LICENSE_SERVER_HOST=127.0.0.1
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Taipei

# change timezone.
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# dumb-init
RUN apt-get install -y wget
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 && chmod +x /usr/local/bin/dumb-init && ln -s /usr/local/bin/dumb-init /usr/bin/dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--", "bash", "docker-entrypoint.sh"]

WORKDIR /app/app
COPY --from=build-stage /compilable-dir/app_build /app/app

# install python package.
RUN pip install -r install/requirements.txt

# install dongle driver.
RUN if [ "${LICENSE_MODE}" = "dongle" ] ; \
  then \
  echo "Installing dongle driver..."; \
  bash -e install/dongle_driver/install_license_driver.sh; \
  cp install/dongle_driver/hasplm.ini /etc/hasplm/hasplm.ini; \
  fi


EXPOSE 80
