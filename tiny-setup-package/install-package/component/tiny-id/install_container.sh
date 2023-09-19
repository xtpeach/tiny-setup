#!/bin/bash
# source
source ../../soft/script/common.sh

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install tiny-id]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install tiny-id]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build image
cd $INSTALL_PACKAGE_DIR/component/tiny-id
tar -zxvf tiny-id-server-1.0.0-release.tar.gz
cd $INSTALL_PACKAGE_DIR/component/tiny-id/tiny-id-server-1.0.0
log_debug "[install tiny-id]" "cd $INSTALL_PACKAGE_DIR/component/tiny-id/tiny-id-server-1.0.0 && bash image_build.sh"
bash image_build.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/tiny-id/tiny-id-server-1.0.0
docker-compose down
log_debug "[install tiny-id]" "cd $INSTALL_PACKAGE_DIR/component/tiny-id && docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/tiny-id/tiny-id-server-1.0.0
docker-compose up -d
log_debug "[install tiny-id]" "cd $INSTALL_PACKAGE_DIR/component/tiny-id && docker-compose up -d"