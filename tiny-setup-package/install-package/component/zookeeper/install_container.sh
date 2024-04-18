#!/bin/bash
# source
source ../../soft/script/common.sh

# zookeeper servers
ZOO_SERVERS=""
KAFKA_ZOO_SERVERS=""

# zookeeper index
zookeeper_index=1
zookeeper_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "zookeeper" "zookeeper${zookeeper_index}")
zookeeper_ip_array=($(echo $zookeeper_ip | tr '.' ' '))
zookeeper_ip_index=${zookeeper_ip_array[3]}
while [[ -n "$zookeeper_ip" ]]; do
  ZOO_SERVERS="server.${zookeeper_ip_index}=zookeeper${zookeeper_ip_index}:2888:3888;2181 ${ZOO_SERVERS}"
  KAFKA_ZOO_SERVERS="zookeeper${zookeeper_ip_index}:2181 ${KAFKA_ZOO_SERVERS}"
  ((zookeeper_index++))
  zookeeper_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "zookeeper" "zookeeper${zookeeper_index}")
  zookeeper_ip_array=($(echo $zookeeper_ip | tr '.' ' '))
  zookeeper_ip_index=${zookeeper_ip_array[3]}
done

# ZOO_SERVERS >> /etc/profile
sed -i "/export ZOO_SERVERS=/d" /etc/profile
echo "export ZOO_SERVERS=\"${ZOO_SERVERS}\"" >>/etc/profile

# docker-compose
sed -i "s/^      - ZOO_SERVERS=.*/      - ZOO_SERVERS=${ZOO_SERVERS}/g" $INSTALL_PACKAGE_DIR/component/zookeeper/docker-compose.yml
sed -i "s/^      - ZOO_MY_ID=.*/      - ZOO_MY_ID=${LOCAL_HOST_IP_ARRAY[3]}/g" $INSTALL_PACKAGE_DIR/component/zookeeper/docker-compose.yml

# config files
mkdir -p /home/zookeeper/conf
log_debug "[install zookeeper]" "mkdir -p /home/zookeeper/conf"
cp -a $INSTALL_PACKAGE_DIR/component/zookeeper/config/* /home/zookeeper/conf
log_debug "[install zookeeper]" "cp -a $INSTALL_PACKAGE_DIR/component/zookeeper/config/* /home/zookeeper/conf"

# zookeeper myid
echo "config zookeeper myid: ${LOCAL_HOST_IP_ARRAY[3]}"
bash ./config_zookeeper_myid.sh ${LOCAL_HOST_IP_ARRAY[3]}
log_debug "[install zookeeper]" "bash ./config_zookeeper_myid.sh ${LOCAL_HOST_IP_ARRAY[3]}"

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install zookeeper]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install zookeeper]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi


# build zookeeper image
cd $INSTALL_PACKAGE_DIR/component/zookeeper/build
log_debug "[install zookeeper]" "cd $INSTALL_PACKAGE_DIR/component/zookeeper/build"
bash image_build.sh
log_debug "[install zookeeper]" "bash image_build.sh"

# stop container
cd $INSTALL_PACKAGE_DIR/component/zookeeper
log_debug "[install zookeeper]" "cd $INSTALL_PACKAGE_DIR/component/zookeeper"
docker-compose down
log_debug "[install zookeeper]" "docker-compose down"

# start container
cd $INSTALL_PACKAGE_DIR/component/zookeeper
log_debug "[install zookeeper]" "cd $INSTALL_PACKAGE_DIR/component/zookeeper"
docker-compose up -d
log_debug "[install zookeeper]" "docker-compose up -d"

# status container
log_info "[install zookeeper]" "zookeeper container started"