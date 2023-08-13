#!/bin/bash
# source
source ../common.sh

# redis data
mkdir -p /data/redis
log_debug "[install redis]" "mkdir /data/redis"

# config files
mkdir -p /home/redis/conf
log_debug "[install redis]" "mkdir /data/redis/conf"
cp -a $INSTALL_PACKAGE_DIR/component/redis/config/* /home/redis/conf
log_debug "[install redis]" "cp -a $INSTALL_PACKAGE_DIR/component/redis/config/* /home/redis/conf"

# stop container
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose down
log_debug "[install redis]" "cd $INSTALL_PACKAGE_DIR/component/redis && docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose up -d
log_debug "[install redis]" "cd $INSTALL_PACKAGE_DIR/component/redis && docker-compose up -d"

# status container
log_info "[install redis]" "redis container started"