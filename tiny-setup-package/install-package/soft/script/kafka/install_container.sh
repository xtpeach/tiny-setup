#!/bin/bash
# source
source ../common.sh

# config files
mkdir -p /home/kafka/conf
log_debug "[install kafka]" "mkdir -p /home/kafka/conf"
cp -a $INSTALL_PACKAGE_DIR/component/kafka/config/* /home/kafka/conf
log_debug "[install kafka]" "cp -a $INSTALL_PACKAGE_DIR/component/kafka/config/* /home/kafka/conf"

# load image
cd $INSTALL_PACKAGE_DIR/resources/docker-images
docker load < openjdk.8-jdk.tar
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/resources/docker-images && docker load < openjdk.8-jdk.tar"

# build kafka image
cd $INSTALL_PACKAGE_DIR/component/kafka/build
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/component/kafka/build"
bash image_build.sh
log_debug "[install kafka]" "bash image_build.sh"

# stop container
cd $INSTALL_PACKAGE_DIR/component/kafka
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/component/kafka"
docker-compose down
log_debug "[install kafka]" "docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/kafka
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/component/kafka"
docker-compose up -d
log_debug "[install kafka]" "docker-compose up -d"

# status container
log_info "[install kafka]" "kafka container started"