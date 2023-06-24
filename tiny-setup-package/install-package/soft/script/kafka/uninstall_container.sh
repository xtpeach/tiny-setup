#!/bin/bash
# source
source ../common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/kafka
docker-compose down

# remove config files
rm -rf /home/kafka/conf

# remove docker image
docker_images=$(docker images | grep kafka | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  echo $docker_image
  docker rmi $docker_image
done