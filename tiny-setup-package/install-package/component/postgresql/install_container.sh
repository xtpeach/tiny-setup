#!/bin/bash
# source
source ../../soft/script/common.sh

# postgresql data
mkdir -p /data/postgresql
log_debug "[install postgresql]" "mkdir -p /data/postgresql"

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/postgresql.14.8.tar ]]; then
  log_debug "[install postgresql]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < postgresql.14.8.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < postgresql.14.8.tar
else
  log_note "[install postgresql]" "docker pull postgresql:14.8"
  docker pull postgresql:14.8
fi

# stop container
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose down
log_debug "[install postgresql]" "cd $INSTALL_PACKAGE_DIR/component/postgresql && docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose up -d
log_debug "[install postgresql]" "cd $INSTALL_PACKAGE_DIR/component/postgresql && docker-compose up -d"

# create databases
sleep 60
bash $INSTALL_PACKAGE_DIR/component/postgresql/create_databases.sh