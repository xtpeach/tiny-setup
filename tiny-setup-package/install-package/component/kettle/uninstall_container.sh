#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/kettle
docker-compose down
log_note "[remove kettle]" "cd $INSTALL_PACKAGE_DIR/component/kettle && docker-compose down"

# remove kettle files
rm -rf /home/kettle
log_note "[remove kettle]" "rm -rf /home/kettle"

# remove docker image
docker_images=$(docker images | grep webspoon | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove kettle]" "docker image: ${docker_image}" "docker rmi $docker_image"
done