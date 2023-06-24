#!/bin/bash
# source
source ../common.sh

# config files
mkdir -p /home/zookeeper/conf
cp -a $INSTALL_PACKAGE_DIR/component/zookeeper/config/* /home/zookeeper/conf

# zookeeper myid
echo "config zookeeper myid: ${LOCAL_HOST_IP_ARRAY[3]}"
bash ./config_zookeeper_myid.sh ${LOCAL_HOST_IP_ARRAY[3]}

# build zookeeper image
cd $INSTALL_PACKAGE_DIR/component/zookeeper/build
bash image_build.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/zookeeper
docker-compose down

# start container
cd $INSTALL_PACKAGE_DIR/component/zookeeper
docker-compose up -d