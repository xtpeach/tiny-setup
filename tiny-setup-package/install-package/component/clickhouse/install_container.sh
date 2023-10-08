#!/bin/bash
# source
source ../../soft/script/common.sh

# clickhouse data
mkdir -p /data/clickhouse
log_debug "[install clickhouse]" "mkdir -p /data/clickhouse"

# config files
mkdir -p /home/clickhouse/conf
log_debug "[install clickhouse]" "mkdir -p /home/clickhouse/conf"
cp -a $INSTALL_PACKAGE_DIR/component/clickhouse/config/* /home/clickhouse/conf
log_debug "[install clickhouse]" "cp -a $INSTALL_PACKAGE_DIR/component/clickhouse/config/* /home/clickhouse/conf"

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/clickhouse.23.8.2.7.tar ]]; then
  log_debug "[install clickhouse]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < clickhouse.23.8.2.7.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < clickhouse.23.8.2.7.tar
else
  log_note "[install clickhouse]" "docker pull clickhouse.23.8.2.7.tar"
  docker pull clickhouse/clickhouse-server:23.8.2.7
fi

# stop container
cd $INSTALL_PACKAGE_DIR/component/clickhouse
docker-compose down
log_debug "[install clickhouse]" "cd $INSTALL_PACKAGE_DIR/component/clickhouse && docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/clickhouse
docker-compose up -d
log_debug "[install clickhouse]" "cd $INSTALL_PACKAGE_DIR/component/clickhouse && docker-compose up -d"

# create databases
sleep 60
bash $INSTALL_PACKAGE_DIR/component/clickhouse/create_databases.sh