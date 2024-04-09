#!/bin/bash
# source
source ../../soft/script/common.sh

# kettle files
mkdir -p /home/kettle/
log_debug "[install kettle]" "mkdir -p /home/kettle/"

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/webspoon.latest.tar ]]; then
  log_debug "[install kettle]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < webspoon.latest.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < webspoon.latest.tar
else
  log_note "[install kettle]" "docker pull hiromuhota/webspoon:latest"
  docker pull hiromuhota/webspoon:latest
fi

# stop container
cd $INSTALL_PACKAGE_DIR/component/kettle
log_debug "[install kettle]" "cd $INSTALL_PACKAGE_DIR/component/kettle"
docker-compose down
log_debug "[install kettle]" "docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/kettle
log_debug "[install kettle]" "cd $INSTALL_PACKAGE_DIR/component/kettle"
docker-compose up -d
log_debug "[install kettle]" "docker-compose up -d"

# status container
log_info "[install kettle]" "kettle container started"
