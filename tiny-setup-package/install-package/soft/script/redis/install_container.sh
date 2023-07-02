#!/bin/bash
# source
source ../common.sh

# redis data
mkdir -p /data/redis

# config files
mkdir -p /home/redis/conf
cp -a $INSTALL_PACKAGE_DIR/component/redis/config/* /home/redis/conf

# stop container
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose down

# start container
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose up -d