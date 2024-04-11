#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
log_note "[remove clickhouse]" "cd $INSTALL_PACKAGE_DIR/component/clickhouse && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/clickhouse
docker-compose down

# remove data
log_note "[remove clickhouse]" "rm -rf /data/clickhouse"
rm -rf /data/clickhouse

# remove config
log_note "[remove clickhouse]" "rm -rf /home/clickhouse/conf"
rm -rf /home/clickhouse/conf

# remove docker image
docker_images=$(docker images | grep clickhouse | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  log_note "[remove clickhouse]" "docker image: ${docker_image}" "docker rmi $docker_image"
  docker rmi $docker_image
done