#!/bin/bash
# source
source ../common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose down
log_note "[remove redis]" "cd $INSTALL_PACKAGE_DIR/component/redis && docker-compose down"

# remove config
rm -rf /home/redis/conf
log_note "[remove redis]" "rm -rf /home/redis/conf"

# remove data
rm -rf /data/redis
log_note "[remove redis]" "rm -rf /data/redis"

# remove docker image
docker_images=$(docker images | grep redis | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove redis]" "docker image: ${docker_image}" "docker rmi $docker_image"
done