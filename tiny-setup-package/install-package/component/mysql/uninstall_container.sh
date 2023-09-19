#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/mysql
docker-compose down
log_note "[remove mysql]" "cd $INSTALL_PACKAGE_DIR/component/mysql && docker-compose down"

# remove data
rm -rf /data/mysql
log_note "[remove mysql]" "rm -rf /data/mysql"

# remove config
rm -rf /home/mysql/conf
log_note "[remove mysql]" "rm -rf /home/mysql/conf"

# remove docker image
docker_images=$(docker images | grep mysql | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove mysql]" "docker image: ${docker_image}" "docker rmi $docker_image"
done