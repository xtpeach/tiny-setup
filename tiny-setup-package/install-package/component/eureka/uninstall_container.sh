#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/eureka/eureka-final
docker-compose down

# remove docker image
docker_images=$(docker images | grep eureka | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  echo "docker image: ${docker_image}"
  docker rmi $docker_image
done