#!/bin/bash
# source
source ../../soft/script/common.sh

# kettle files
log_debug "[install kettle]" "mkdir -p /home/kettle/"
mkdir -p /home/kettle/

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/webspoon.0.9.0.21.tar ]]; then
  log_debug "[install kettle]" "cd $INSTALL_DIR/resource/docker-images && docker load < webspoon.0.9.0.21.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < webspoon.0.9.0.21.tar
else
  log_note "[install kettle]" "docker pull hiromuhota/webspoon:latest"
  docker pull hiromuhota/webspoon:0.9.0.21
fi

# stop container
log_debug "[install kettle]" "cd $INSTALL_DIR/component/kettle"
cd $INSTALL_DIR/component/kettle
log_debug "[install kettle]" "docker-compose down"
docker-compose down

# start container
log_debug "[install kettle]" "cd $INSTALL_DIR/component/kettle"
cd $INSTALL_DIR/component/kettle
log_debug "[install kettle]" "docker-compose up -d"
docker-compose up -d

# status container
log_info "[install kettle]" "kettle container started"
