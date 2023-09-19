#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose down
log_note "[remove nginx]" "cd $INSTALL_PACKAGE_DIR/component/nginx && docker-compose down"

# remove config
rm -rf /home/nginx/config
log_note "[remove nginx]" "rm -rf /home/nginx/config"

# remove data
rm -rf /home/nginx/html
log_note "[remove nginx]" "rm -rf /home/nginx/html"

# remove docker image
docker_images=$(docker images | grep nginx | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove nginx]" "docker image: ${docker_image}" "docker rmi $docker_image"
done