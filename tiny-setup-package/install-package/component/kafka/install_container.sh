#!/bin/bash
# source
source ../../soft/script/common.sh

# kafka index
# config.ini 的 kafka 序号从1开始
kafka_index=1
# 先读到第一个kafka的IP地址，即kafka1对应的IP地址
kafka_ip=$(bash $INSTALL_DIR/soft/script/ini_operator.sh "get" "$INSTALL_DIR/config.ini" "kafka" "kafka${kafka_index}")
# 将这个IP地址按照点分放进数组
kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
# 拿到IP地址的最后一位
kafka_ip_index=${kafka_ip_array[3]}
# 拿到kafka1对应的IP地址的最后一位
KAFKA_IP_INDEX_FIRST=${kafka_ip_array[3]}
# 循环往下读 kafka1 kafka2 kafka3 ...
while [[ -n "$kafka_ip" ]]; do
  # 删除 /etc/hosts 中的 kafka 域名映射
  sed -i "/kafka${kafka_ip_index}/d" /etc/hosts
  # 将 kafka 的域名映射写入 /etc/hosts 文件中
  echo "${kafka_ip} kafka${kafka_ip_index}" >>/etc/hosts

  # 为下一次循环做准备
  # kafka1 kafka2 kafka3 ...
  ((kafka_index++))
  # 继续向下读取 kafka 配置，kafka1 kafka2 kafka3 ...
  kafka_ip=$(bash $INSTALL_DIR/soft/script/ini_operator.sh "get" "$INSTALL_DIR/config.ini" "kafka" "kafka${kafka_index}")
  # 将读到的 kafka 的配置IP按照点分放入数组
  kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
  # 拿到 kafka 配置的IP的最后一位
  kafka_ip_index=${kafka_ip_array[3]}
done

# 修改 docker-compose.yml 文件
sed -i "s/^      - ZOO_SERVERS=.*/      - ZOO_SERVERS=${KAFKA_ZOO_SERVERS}/g" $INSTALL_DIR/component/kafka/docker-compose.yml
sed -i "s/^      - BROKER_ID=.*/      - BROKER_ID=${LOCAL_HOST_IP_ARRAY[3]}/g" $INSTALL_DIR/component/kafka/docker-compose.yml
sed -i "s/^      - LISTENERS=.*/      - LISTENERS=PLAINTEXT:\/\/${LOCAL_HOST_IP}:9092/g" $INSTALL_DIR/component/kafka/docker-compose.yml

# config files
log_debug "[install kafka]" "mkdir -p /home/kafka/conf"
mkdir -p /home/kafka/conf
log_debug "[install kafka]" "cp -a $INSTALL_DIR/component/kafka/config/* /home/kafka/conf"
cp -a $INSTALL_DIR/component/kafka/config/* /home/kafka/conf

# load image
if [[ -f $INSTALL_DIR/resource/docker-images/openjdk.8-jdk.tar ]]; then
  log_debug "[install kafka]" "cd $INSTALL_DIR/resource/docker-images && docker load < openjdk.8-jdk.tar"
  cd $INSTALL_DIR/resource/docker-images
  docker load < openjdk.8-jdk.tar
else
  log_note "[install kafka]" "docker pull openjdk:8-jdk"
  docker pull openjdk:8-jdk
fi

# build kafka image
log_debug "[install kafka]" "cd $INSTALL_DIR/component/kafka/build"
cd $INSTALL_DIR/component/kafka/build
log_debug "[install kafka]" "bash image_build.sh"
bash image_build.sh

# stop container
log_debug "[install kafka]" "cd $INSTALL_DIR/component/kafka"
cd $INSTALL_DIR/component/kafka
log_debug "[install kafka]" "docker-compose down"
docker-compose down

# start container
log_debug "[install kafka]" "cd $INSTALL_DIR/component/kafka"
cd $INSTALL_DIR/component/kafka
log_debug "[install kafka]" "docker-compose up -d"
docker-compose up -d

# status container
log_info "[install kafka]" "kafka container started"

# create topic
for ((i = 1; i <= 60; i++)); do
  log_debug "[install kafka]" "wait(${i}s) ..."
  sleep 1s
done

log_info "[install kafka]" "kafka create topic"
bash $INSTALL_DIR/component/kafka/create_topic.sh