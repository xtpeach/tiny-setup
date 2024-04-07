#!/bin/bash
# source
source ../../soft/script/common.sh

# mysql data
mkdir -p /data/mysql
log_debug "[install mysql]" "mkdir -p /data/mysql"

# config files
mkdir -p /home/mysql/conf
log_debug "[install mysql]" "mkdir -p /home/mysql/conf"
cp -a $INSTALL_PACKAGE_DIR/component/mysql/config/* /home/mysql/conf
log_debug "[install mysql]" "cp -a $INSTALL_PACKAGE_DIR/component/mysql/config/* /home/mysql/conf"

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/mysql.5.7.tar ]]; then
  log_debug "[install mysql]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < mysql.5.7.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
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

# create databases
sleep 60

log_debug "[install mysql]" "create database"
bash $INSTALL_PACKAGE_DIR/component/mysql/create_databases.sh