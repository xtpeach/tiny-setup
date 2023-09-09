#!/bin/bash
# source
source ../../soft/script/common.sh

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install nacos]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install nacos]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build nacos image
cd $INSTALL_PACKAGE_DIR/component/nacos/build
log_debug "[install nacos]" "cd $INSTALL_PACKAGE_DIR/component/nacos/build"
bash image_build.sh
log_debug "[install nacos]" "bash image_build.sh"

# stop container
cd $INSTALL_PACKAGE_DIR/component/nacos
log_debug "[install nacos]" "cd $INSTALL_PACKAGE_DIR/component/nacos"
docker-compose down
log_debug "[install nacos]" "docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/nacos
log_debug "[install nacos]" "cd $INSTALL_PACKAGE_DIR/component/nacos"
docker-compose up -d
log_debug "[install nacos]" "docker-compose up -d"

# status container
log_info "[install nacos]" "nacos container started"