#!/bin/bash
# source
source ../common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/redis
docker-compose down

# remove config
rm -rf /home/redis/conf

# remove data
rm -rf /data/redis

# remove docker image
docker_images=$(docker images | grep redis | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  echo "docker image: ${docker_image}"
  docker rmi $docker_image
done