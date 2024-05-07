#!/bin/bash
# source
source ../../../soft/script/common.sh

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install xxl-executor]" "cd $INSTALL_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install xxl-executor]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build image
log_debug "[install xxl-executor]" "cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1 && bash image_build.sh"
cd $INSTALL_DIR/component/xxl-job/xxl-executor
rm -rf xxl-job-executor-base-2.3.1
tar -zxvf xxl-job-executor-base-2.3.1-release.tar.gz
cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1
bash image_build.sh

# stop container
log_debug "[install xxl-executor]" "cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1 && docker-compose down"
cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1
sed -i "s/REDIS_PASSWORD: \"admin1!3\"/REDIS_PASSWORD: \"$REDIS_PASSWORD\"/g" $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1/docker-compose.yml
sed -i "s/REDIS_HOST: \"redis\"/REDIS_HOST: \"127.0.0.1\"/g" $INSTALL_DIR/component/xxl-job/xxl-admin/xxl-job-admin-2.3.1/docker-compose.yml
docker-compose down

# start container
log_debug "[install xxl-executor]" "cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1 && docker-compose up -d"
cd $INSTALL_DIR/component/xxl-job/xxl-executor/xxl-job-executor-base-2.3.1
docker-compose up -d
