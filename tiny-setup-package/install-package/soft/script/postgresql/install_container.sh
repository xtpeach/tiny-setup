#!/bin/bash
# source
source ../common.sh

# postgresql data
mkdir -p /data/postgresql

# load image
cd $INSTALL_PACKAGE_DIR/resources/docker-images
docker load < postgresql.14.8.tar

# stop container
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose down

# start container
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose up -d