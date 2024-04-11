#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
log_note "[remove redis]" "cd $INSTALL_PACKAGE_DIR/component/redis && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose down

# remove config
log_note "[remove redis]" "rm -rf /home/redis/conf"
rm -rf /home/redis/conf

# remove data
log_note "[remove redis]" "rm -rf /data/redis"
rm -rf /data/redis

# remove docker image
docker_images=$(docker images | grep redis | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove redis]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done