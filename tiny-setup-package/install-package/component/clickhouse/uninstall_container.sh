#!/bin/bash
# source
source ../../soft/script/common.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/clickhouse
docker-compose down
log_note "[remove clickhouse]" "cd $INSTALL_PACKAGE_DIR/component/clickhouse && docker-compose down"

# remove data
rm -rf /data/clickhouse
log_note "[remove clickhouse]" "rm -rf /data/clickhouse"

# remove config
rm -rf /home/clickhouse/conf
log_note "[remove clickhouse]" "rm -rf /home/clickhouse/conf"

# remove docker image
docker_images=$(docker images | grep clickhouse | awk -v FS=" " '{print $3}')
for docker_image in $docker_images; do
  docker rmi $docker_image
  log_note "[remove clickhouse]" "docker image: ${docker_image}" "docker rmi $docker_image"
done