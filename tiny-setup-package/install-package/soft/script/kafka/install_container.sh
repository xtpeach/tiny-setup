#!/bin/bash
# source
source ../common.sh

# config files
mkdir -p /home/kafka/conf
cp -a $INSTALL_PACKAGE_DIR/component/kafka/config/* /home/kafka/conf

# build kafka image
cd $INSTALL_PACKAGE_DIR/component/kafka/build
bash image_build.sh

# stop container
cd $INSTALL_PACKAGE_DIR/component/kafka
docker-compose down

# start container
cd $INSTALL_PACKAGE_DIR/component/kafka
docker-compose up -d