#!/bin/bash
# source
source ../../../soft/script/common.sh

# 如果目录不存在，则不要进行删除了
if [[ ! -d "$INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1" ]]; then
  log_note "[remove xxl-executor]" "$INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1" "not exists"
  exit 0
fi

# stop container
log_note "[remove xxl-executor]" "cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1 && docker-compose down"
cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1
docker-compose down

# remove docker image
docker_images=$(docker images | grep xxl-job-executor-base | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove xxl-executor]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done