#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
log_note "[remove postgresql]" "cd $INSTALL_PACKAGE_DIR/component/postgresql && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose down

# remove data
log_note "[remove postgresql]" "rm -rf /data/postgresql"
rm -rf /data/postgresql

# remove docker image
docker_images=$(docker images | grep postgresql | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove postgresql]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done