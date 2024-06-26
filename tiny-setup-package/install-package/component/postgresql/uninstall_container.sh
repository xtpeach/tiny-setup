#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose down
log_note "[remove postgresql]" "cd $INSTALL_PACKAGE_DIR/component/postgresql && docker-compose down"

# remove data
rm -rf /data/postgresql
log_note "[remove postgresql]" "rm -rf /data/postgresql"

# remove docker image
docker_images=$(docker images | grep postgresql | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove postgresql]" "docker image: ${docker_image}" "docker rmi $docker_image"
done