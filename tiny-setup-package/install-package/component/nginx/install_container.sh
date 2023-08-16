#!/bin/bash
# source
source ../../soft/script/common.sh

# nginx data
mkdir -p /home/nginx/html
log_debug "[install nginx]" "mkdir -p /home/nginx/html"
cp -a $INSTALL_PACKAGE_DIR/component/nginx/build/html/* /home/nginx/html
log_debug "[install nginx]" "cp -a $INSTALL_PACKAGE_DIR/component/nginx/build/html/* /home/nginx/html"

# config files
mkdir -p /home/nginx/config
log_debug "[install nginx]" "mkdir -p /home/nginx/config"
cp -a $INSTALL_PACKAGE_DIR/component/nginx/config/* /home/nginx/config
log_debug "[install nginx]" "cp -a $INSTALL_PACKAGE_DIR/component/nginx/config/* /home/nginx/config"

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resources/docker-images/nginx.1.25.0.tar ]]; then
  log_debug "[install nginx]" "cd $INSTALL_PACKAGE_DIR/resources/docker-images && docker load < nginx.1.25.0.tar"
  cd $INSTALL_PACKAGE_DIR/resources/docker-images
  docker load < nginx.1.25.0.tar
else
  log_note "[install nginx]" "docker pull nginx:1.25.0"
  docker pull nginx:1.25.0
fi

# stop container
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose down
log_debug "[install nginx]" "cd $INSTALL_PACKAGE_DIR/component/nginx && docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/nginx
docker-compose up -d
log_debug "[install nginx]" "cd $INSTALL_PACKAGE_DIR/component/nginx && docker-compose up -d"