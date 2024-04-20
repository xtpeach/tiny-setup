#!/bin/bash
# source
source ../../soft/script/common.sh

# 修改 users.xml 文件
sed -i "s|<password></password>|<password>${CLICKHOUSE_PASSWORD}</password>|g" $INSTALL_DIR/component/clickhouse/config/users.xml

# clickhouse data
log_debug "[install clickhouse]" "mkdir -p /data/clickhouse"
mkdir -p /data/clickhouse

# config files
log_debug "[install clickhouse]" "mkdir -p /home/clickhouse/conf"
mkdir -p /home/clickhouse/conf
log_debug "[install clickhouse]" "cp -a $INSTALL_DIR/component/clickhouse/config/* /home/clickhouse/conf"
cp -a $INSTALL_DIR/component/clickhouse/config/* /home/clickhouse/conf

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/clickhouse.23.8.2.7.tar ]]; then
  log_debug "[install clickhouse]" "cd $INSTALL_DIR/resource/docker-images && docker load < clickhouse.23.8.2.7.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < clickhouse.23.8.2.7.tar
else
  log_note "[install clickhouse]" "docker pull clickhouse.23.8.2.7.tar"
  docker pull clickhouse/clickhouse-server:23.8.2.7
fi

# stop container
log_debug "[install clickhouse]" "cd $INSTALL_DIR/component/clickhouse && docker-compose down"
cd $INSTALL_DIR/component/clickhouse
docker-compose down

# start container
log_debug "[install clickhouse]" "cd $INSTALL_DIR/component/clickhouse && docker-compose up -d"
cd $INSTALL_DIR/component/clickhouse
docker-compose up -d

# create databases
sleep 60
bash $INSTALL_DIR/component/clickhouse/create_databases.sh