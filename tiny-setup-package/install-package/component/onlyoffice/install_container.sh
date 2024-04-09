#!/bin/bash
# source
source ../../soft/script/common.sh

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/onlyoffice.latest.tar ]]; then
  log_debug "[install onlyoffice]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < onlyoffice.latest.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < onlyoffice.latest.tar
else
  log_note "[install onlyoffice]" "docker pull onlyoffice/documentserver:latest"
  docker pull onlyoffice/documentserver:latest
fi

# stop container
cd $INSTALL_PACKAGE_DIR/component/onlyoffice
log_debug "[install onlyoffice]" "cd $INSTALL_PACKAGE_DIR/component/onlyoffice"
docker-compose down
log_debug "[install onlyoffice]" "docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/onlyoffice
log_debug "[install onlyoffice]" "cd $INSTALL_PACKAGE_DIR/component/onlyoffice"
docker-compose up -d
log_debug "[install onlyoffice]" "docker-compose up -d"

# status container
log_info "[install onlyoffice]" "onlyoffice container started"
