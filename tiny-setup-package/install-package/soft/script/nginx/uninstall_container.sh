#!/bin/bash
# source
source ../common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose down

# remove config
rm -rf /home/nginx/config

# remove data
rm -rf /home/nginx/html

# remove docker image
docker_images=$(docker images | grep nginx | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  echo "docker image: ${docker_image}"
  docker rmi $docker_image
done