#!/bin/bash
# source
source ../common.sh

# config files
mkdir -p /home/zookeeper/conf
log_debug "[install zookeeper]" "mkdir -p /home/zookeeper/conf"
cp -a $INSTALL_PACKAGE_DIR/component/zookeeper/config/* /home/zookeeper/conf
log_debug "[install zookeeper]" "cp -a $INSTALL_PACKAGE_DIR/component/zookeeper/config/* /home/zookeeper/conf"

# zookeeper myid
echo "config zookeeper myid: ${LOCAL_HOST_IP_ARRAY[3]}"
bash ./config_zookeeper_myid.sh ${LOCAL_HOST_IP_ARRAY[3]}
log_debug "[install zookeeper]" "bash ./config_zookeeper_myid.sh ${LOCAL_HOST_IP_ARRAY[3]}"

# load image
cd $INSTALL_PACKAGE_DIR/resources/docker-images
docker load < openjdk.8-jdk.tar
log_debug "[install kafka]" "cd $INSTALL_PACKAGE_DIR/resources/docker-images && docker load < openjdk.8-jdk.tar"

# build zookeeper image
cd $INSTALL_PACKAGE_DIR/component/zookeeper/build
log_debug "[install zookeeper]" "cd $INSTALL_PACKAGE_DIR/component/zookeeper/build"
bash image_build.sh
log_debug "[install zookeeper]" "bash image_build.sh"

# stop container
cd $INSTALL_PACKAGE_DIR/component/zookeeper
log_debug "[install zookeeper]" "cd $INSTALL_PACKAGE_DIR/component/zookeeper"
docker-compose down
log_debug "[install zookeeper]" "docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/zookeeper
log_debug "[install zookeeper]" "cd $INSTALL_PACKAGE_DIR/component/zookeeper"
docker-compose up -d
log_debug "[install zookeeper]" "docker-compose up -d"

# status container
log_info "[install zookeeper]" "zookeeper container started"