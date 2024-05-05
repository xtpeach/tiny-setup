#!/bin/bash
# source
source ../../../soft/script/common.sh

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install xxl-admin]" "cd $INSTALL_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install xxl-admin]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build image
log_debug "[install xxl-admin]" "cd $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1 && bash image_build.sh"
cd $INSTALL_DIR/component/xxl-job/xxl-admin
tar -zxvf xxl-job-admin-2.3.1-release.tar.gz
cd $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1
bash image_build.sh

# stop container
log_debug "[install xxl-admin]" "cd $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1 && docker-compose down"
cd $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1
sed -i 's/DATASOURCE_PASSWORD: "12345678"/DATASOURCE_PASSWORD: "postgresql!123456"/g' $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1/docker-compose.yml
docker-compose down

# start container
log_debug "[install xxl-admin]" "cd $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1 && docker-compose up -d"
cd $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1
docker-compose up -d
