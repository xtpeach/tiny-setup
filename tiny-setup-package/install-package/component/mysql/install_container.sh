#!/bin/bash
# source
source ../../soft/script/common.sh

# mysql data
mkdir -p /data/mysql
log_debug "[install mysql]" "mkdir -p /data/mysql"

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resources/docker-images/mysql.5.7.tar ]]; then
  log_debug "[install mysql]" "cd $INSTALL_PACKAGE_DIR/resources/docker-images && docker load < mysql.5.7.tar"
  cd $INSTALL_PACKAGE_DIR/resources/docker-images
  docker load < mysql.5.7.tar
else
  log_note "[install mysql]" "docker pull mysql.5.7.tar"
  docker pull mysql:5.7
fi

# stop container
cd $INSTALL_PACKAGE_DIR/component/mysql
docker-compose down
log_debug "[install mysql]" "cd $INSTALL_PACKAGE_DIR/component/mysql && docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/mysql
docker-compose up -d
log_debug "[install mysql]" "cd $INSTALL_PACKAGE_DIR/component/mysql && docker-compose up -d"