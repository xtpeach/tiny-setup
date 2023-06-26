#!/bin/bash
# source
source ../common.sh

# postgresql data
mkdir -p /data/postgresql

# stop container
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose down

# start container
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose up -d