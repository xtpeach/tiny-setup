#!/bin/bash
# source
source ../../soft/script/common.sh

# zookeeper index
# config.conf 的 zookeeper 序号从1开始
zookeeper_index=1
# 先读到第一个zookeeper的IP地址，即zookeeper1对应的IP地址
zookeeper_ip=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "zookeeper" "zookeeper${zookeeper_index}")
# 将这个IP地址按照点分放进数组
zookeeper_ip_array=($(echo $zookeeper_ip | tr '.' ' '))
# 拿到IP地址的最后一位
zookeeper_ip_index=${zookeeper_ip_array[3]}
# 循环往下读 zookeeper1 zookeeper2 zookeeper3 ...
while [[ -n "$zookeeper_ip" ]]; do
  # 删除 /etc/hosts 中的 zookeeper 域名映射
  sed -i "/zookeeper${zookeeper_ip_index}/d" /etc/hosts
  # 将 kafka 的域名映射写入 /etc/hosts 文件中
  echo "${zookeeper_ip} zookeeper${zookeeper_ip_index}" >>/etc/hosts

  # 为下一次循环做准备
  # zookeeper1 zookeeper2 zookeeper3 ...
  ((zookeeper_index++))
  # 继续向下读取 kafka 配置，zookeeper1 zookeeper2 zookeeper3 ...
  zookeeper_ip=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "zookeeper" "zookeeper${zookeeper_index}")
  # 将读到的 zookeeper 的配置IP按照点分放入数组
  zookeeper_ip_array=($(echo $zookeeper_ip | tr '.' ' '))
  # 拿到 zookeeper 配置的IP的最后一位
  zookeeper_ip_index=${zookeeper_ip_array[3]}
done

# ZOO_SERVERS >> /etc/profile
sed -i "/export ZOO_SERVERS=/d" /etc/profile
echo "export ZOO_SERVERS=\"${ZOO_SERVERS}\"" >>/etc/profile

# docker-compose
sed -i "s/^      - ZOO_SERVERS=.*/      - ZOO_SERVERS=${ZOO_SERVERS}/g" $INSTALL_DIR/component/zookeeper/docker-compose.yml
sed -i "s/^      - ZOO_MY_ID=.*/      - ZOO_MY_ID=${LOCAL_HOST_IP_ARRAY[3]}/g" $INSTALL_DIR/component/zookeeper/docker-compose.yml

# config files
mkdir -p /home/zookeeper/conf
log_debug "[install zookeeper]" "mkdir -p /home/zookeeper/conf"
cp -a $INSTALL_DIR/component/zookeeper/config/* /home/zookeeper/conf
log_debug "[install zookeeper]" "cp -a $INSTALL_DIR/component/zookeeper/config/* /home/zookeeper/conf"

# zookeeper myid
echo "config zookeeper myid: ${LOCAL_HOST_IP_ARRAY[3]}"
bash ./config_zookeeper_myid.sh ${LOCAL_HOST_IP_ARRAY[3]}
log_debug "[install zookeeper]" "bash ./config_zookeeper_myid.sh ${LOCAL_HOST_IP_ARRAY[3]}"

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install zookeeper]" "cd $INSTALL_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install zookeeper]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi


# build zookeeper image
cd $INSTALL_DIR/component/zookeeper/build
log_debug "[install zookeeper]" "cd $INSTALL_DIR/component/zookeeper/build"
bash image_build.sh
log_debug "[install zookeeper]" "bash image_build.sh"

# stop container
cd $INSTALL_DIR/component/zookeeper
log_debug "[install zookeeper]" "cd $INSTALL_DIR/component/zookeeper"
docker-compose down
log_debug "[install zookeeper]" "docker-compose down"

# start container
cd $INSTALL_DIR/component/zookeeper
log_debug "[install zookeeper]" "cd $INSTALL_DIR/component/zookeeper"
docker-compose up -d
log_debug "[install zookeeper]" "docker-compose up -d"

# status container
log_info "[install zookeeper]" "zookeeper container started"