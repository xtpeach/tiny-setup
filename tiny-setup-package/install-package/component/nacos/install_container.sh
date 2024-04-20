#!/bin/bash
# source
source ../../soft/script/common.sh

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install nacos]" "cd $INSTALL_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install nacos]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build nacos image
log_debug "[install nacos]" "cd $INSTALL_DIR/component/nacos/build"
cd $INSTALL_DIR/component/nacos/build
log_debug "[install nacos]" "bash image_build.sh"
bash image_build.sh

# stop container
log_debug "[install nacos]" "cd $INSTALL_DIR/component/nacos"
cd $INSTALL_DIR/component/nacos
log_debug "[install nacos]" "docker-compose down"
docker-compose down

# start container
log_debug "[install nacos]" "cd $INSTALL_DIR/component/nacos"
cd $INSTALL_DIR/component/nacos
log_debug "[install nacos]" "docker-compose up -d"
docker-compose up -d

# status container
log_info "[install nacos]" "nacos container started"