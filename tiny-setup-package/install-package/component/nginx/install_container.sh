#!/bin/bash
# source
source ../../soft/script/common.sh

# nginx data
log_debug "[install nginx]" "mkdir -p /home/nginx/html"
mkdir -p /home/nginx/html
log_debug "[install nginx]" "cp -a $INSTALL_PACKAGE_DIR/component/nginx/build/html/* /home/nginx/html"
cp -a $INSTALL_PACKAGE_DIR/component/nginx/build/html/* /home/nginx/html

# config files
log_debug "[install nginx]" "mkdir -p /home/nginx/config"
mkdir -p /home/nginx/config
log_debug "[install nginx]" "cp -a $INSTALL_PACKAGE_DIR/component/nginx/config/* /home/nginx/config"
cp -a $INSTALL_PACKAGE_DIR/component/nginx/config/* /home/nginx/config

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/nginx.1.25.0.tar ]]; then
  log_debug "[install nginx]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < nginx.1.25.0.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < nginx.1.25.0.tar
else
  log_note "[install nginx]" "docker pull nginx:1.25.0"
  docker pull nginx:1.25.0
fi

# stop container
log_debug "[install nginx]" "cd $INSTALL_PACKAGE_DIR/component/nginx && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose down

# start container
log_debug "[install nginx]" "cd $INSTALL_PACKAGE_DIR/component/nginx && docker-compose up -d"
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose up -d
