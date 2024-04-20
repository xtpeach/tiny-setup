#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
log_note "[remove nginx]" "cd $INSTALL_DIR/component/nginx && docker-compose down"
cd $INSTALL_DIR/component/nginx
docker-compose down

# remove config
log_note "[remove nginx]" "rm -rf /home/nginx/config"
rm -rf /home/nginx/config

# remove data
log_note "[remove nginx]" "rm -rf /home/nginx/html"
rm -rf /home/nginx/html

# remove docker image
docker_images=$(docker images | grep nginx | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove nginx]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done