#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/onlyoffice
docker-compose down
log_note "[remove onlyoffice]" "cd $INSTALL_PACKAGE_DIR/component/onlyoffice && docker-compose down"

# remove docker image
docker_images=$(docker images | grep onlyoffice | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove onlyoffice]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done