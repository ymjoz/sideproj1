#!/bin/bash

if [ "${LICENSE_MODE}" = "dongle" ]
then
    # 改DONGLE_LICENSE_SERVER_HOST
    sed -i "s/\(serveraddr\s=\s\).*/\1${DONGLE_LICENSE_SERVER_HOST:-127.0.0.1}/g" /etc/hasplm/hasplm.ini
    /etc/init.d/aksusbd start
    sleep 3
fi

if [ $# -eq 1 ] && [ "$1" = "get_hardware_token" ]
then 
    python get_hardware_token.py
    exit 0
fi

/start.sh