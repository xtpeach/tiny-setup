#!/bin/bash
# source
source ../../soft/script/common.sh

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install eureka]" "cd $INSTALL_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install eureka]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build image
log_debug "[install eureka]" "cd $INSTALL_DIR/component/eureka/eureka-final && bash image_build.sh"
cd $INSTALL_DIR/component/eureka
tar -zxvf eureka-final-release.tar.gz
cd $INSTALL_DIR/component/eureka/eureka-final
bash image_build.sh

# stop container
log_debug "[install eureka]" "cd $INSTALL_DIR/component/eureka && docker-compose down"
cd $INSTALL_DIR/component/eureka/eureka-final
docker-compose down

# start container
log_debug "[install eureka]" "cd $INSTALL_DIR/component/eureka && docker-compose up -d"
cd $INSTALL_DIR/component/eureka/eureka-final
docker-compose up -d
