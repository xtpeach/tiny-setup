#!/bin/bash
# source
source ../../soft/script/common.sh

# config files
log_debug "[install kafka]" "mkdir -p /home/kafka/conf"
mkdir -p /home/kafka/conf
log_debug "[install kafka]" "cp -a $INSTALL_PACKAGE_DIR/component/kafka/config/* /home/kafka/conf"
cp -a $INSTALL_PACKAGE_DIR/component/kafka/config/* /home/kafka/conf

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install kafka]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build kafka image
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/component/kafka/build"
cd $INSTALL_PACKAGE_DIR/component/kafka/build
log_debug "[install kafka]" "bash image_build.sh"
bash image_build.sh

# stop container
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/component/kafka"
cd $INSTALL_PACKAGE_DIR/component/kafka
log_debug "[install kafka]" "docker-compose down"
docker-compose down

# start container
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/component/kafka"
cd $INSTALL_PACKAGE_DIR/component/kafka
log_debug "[install kafka]" "docker-compose up -d"
docker-compose up -d

# status container
log_info "[install kafka]" "kafka container started"

# create topic
sleep 60s
log_info "[install kafka]" "kafka create topic"
bash $INSTALL_PACKAGE_DIR/component/kafka/create_topic.sh