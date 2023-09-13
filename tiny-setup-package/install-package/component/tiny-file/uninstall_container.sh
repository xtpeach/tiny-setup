#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/tiny-file/tiny-file-server-1.0.0
docker-compose down
log_note "[remove tiny-file]" "cd $INSTALL_PACKAGE_DIR/component/tiny-file/tiny-file-server-1.0.0 && docker-compose down"

# remove docker image
docker_images=$(docker images | grep tiny-file | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove tiny-file]" "docker image: ${docker_image}" "docker rmi $docker_image"
done