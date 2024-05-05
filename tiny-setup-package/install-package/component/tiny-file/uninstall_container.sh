#!/bin/bash
# source
source ../../soft/script/common.sh

# 如果目录不存在，则不要进行删除了
if [[ ! -d "$INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0" ]]; then
  log_note "[remove tiny-file]" "$INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0" "not exists"
  exit 0
fi

# stop container
log_note "[remove tiny-file]" "cd $INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0 && docker-compose down"
cd $INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0
docker-compose down

# remove docker image
docker_images=$(docker images | grep tiny-file | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove tiny-file]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done