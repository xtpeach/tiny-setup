#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/nacos
docker-compose down
log_note "[remove nacos]" "cd $INSTALL_PACKAGE_DIR/component/nacos && docker-compose down"

# remove docker image
docker_images=$(docker images | grep nacos | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove nacos]" "docker image: ${docker_image}" "docker rmi $docker_image"
done