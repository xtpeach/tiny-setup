#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
log_note "[remove kafka]" "cd $INSTALL_PACKAGE_DIR/component/kafka && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/kafka
docker-compose down

# remove config files
log_note "[remove kafka]" "rm -rf /home/kafka/conf"
rm -rf /home/kafka/conf

# remove data
log_note "[remove kafka]" "rm -rf /data/kafka"
rm -rf /data/kafka

# remove docker image
docker_images=$(docker images | grep kafka | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove kafka]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done