#!/bin/bash
# source
source ../common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/zookeeper
docker-compose down

# remove config files
rm -rf /home/zookeeper/conf

# remove data
rm -rf /data/zookeeper

# remove docker image
docker_images=$(docker images | grep zookeeper | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  echo "docker image: ${docker_image}"
  docker rmi $docker_image
done