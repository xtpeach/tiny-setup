#!/bin/bash
# source
source ../../soft/script/common.sh

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/onlyoffice.latest.tar ]]; then
  log_debug "[install onlyoffice]" "cd $INSTALL_DIR/resource/docker-images && docker load < onlyoffice.latest.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < onlyoffice.latest.tar
else
  log_note "[install onlyoffice]" "docker pull onlyoffice/documentserver:latest"
  docker pull onlyoffice/documentserver:latest
fi

# stop container
log_debug "[install onlyoffice]" "cd $INSTALL_DIR/component/onlyoffice"
cd $INSTALL_DIR/component/onlyoffice
log_debug "[install onlyoffice]" "docker-compose down"
docker-compose down

# start container
log_debug "[install onlyoffice]" "cd $INSTALL_DIR/component/onlyoffice"
cd $INSTALL_DIR/component/onlyoffice
log_debug "[install onlyoffice]" "docker-compose up -d"
docker-compose up -d

# status container
log_info "[install onlyoffice]" "onlyoffice container started"
