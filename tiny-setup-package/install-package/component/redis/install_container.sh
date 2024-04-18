#!/bin/bash
# source
source ../../soft/script/common.sh

# 修改 redis.conf 文件
sed -i "s/^requirepass.*/requirepass ${REDIS_PASSWORD}/g" $INSTALL_PACKAGE_DIR/component/redis/config/redis.conf

# redis data
mkdir -p /data/redis
log_debug "[install redis]" "mkdir -p /data/redis"

# config files
log_debug "[install redis]" "mkdir -p /home/redis/conf"
mkdir -p /home/redis/conf
log_debug "[install redis]" "cp -a $INSTALL_PACKAGE_DIR/component/redis/config/* /home/redis/conf"
cp -a $INSTALL_PACKAGE_DIR/component/redis/config/* /home/redis/conf

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/redis.6.2.12.tar ]]; then
  log_debug "[install redis]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < redis.6.2.12.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < redis.6.2.12.tar
else
  log_note "[install redis]" "docker pull redis:6.2.12"
  docker pull redis:6.2.12
fi

# stop container
log_debug "[install redis]" "cd $INSTALL_PACKAGE_DIR/component/redis && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose down

# start container
log_debug "[install redis]" "cd $INSTALL_PACKAGE_DIR/component/redis && docker-compose up -d"
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose up -d

# status container
log_info "[install redis]" "redis container started"