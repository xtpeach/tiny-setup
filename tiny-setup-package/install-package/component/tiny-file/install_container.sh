#!/bin/bash
# source
source ../../soft/script/common.sh

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install tiny-file]" "cd $INSTALL_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install tiny-file]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build image
log_debug "[install tiny-file]" "cd $INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0 && bash image_build.sh"
cd $INSTALL_DIR/component/tiny-file
tar -zxvf tiny-file-server-1.0.0-release.tar.gz
cd $INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0
bash image_build.sh

# stop container
log_debug "[install tiny-file]" "cd $INSTALL_DIR/component/tiny-file && docker-compose down"
cd $INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0
docker-compose down

# start container
log_debug "[install tiny-file]" "cd $INSTALL_DIR/component/tiny-file && docker-compose up -d"
cd $INSTALL_DIR/component/tiny-file/tiny-file-server-1.0.0
docker-compose up -d
