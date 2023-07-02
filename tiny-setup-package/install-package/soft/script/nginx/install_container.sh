#!/bin/bash
# source
source ../common.sh

# redis data
mkdir -p /home/nginx/html
cp -a $INSTALL_PACKAGE_DIR/component/nginx/build/html/* /home/nginx/html

# config files
mkdir -p /home/nginx/config
cp -a $INSTALL_PACKAGE_DIR/component/nginx/config/* /home/nginx/config

# stop container
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose down

# start container
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose up -d