#!/bin/bash
#version
VERSION=1.1

echo -e "\n"
echo "--- common version: ${VERSION} begin ---"

# install package dir
# -- *** [/opt/tiny-setup-package/install-package] *** --
INSTALL_PACKAGE_DIR=/opt/tiny-setup-package/install-package
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# -- log level: debug-1, info-2, warn-3, error-4, always-5 --
LOG_LEVEL=1
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# config.ini hosts
host_index=1
host_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "hosts" "host${host_index}")
LOCAL_HOST_IP=""
while [[ -n "$host_ip" ]]; do
  local_ip_flag=$(ip addr | grep -c $host_ip)
  [[ $local_ip_flag -ge 1 ]] && {
    LOCAL_HOST_IP=$host_ip
  }
  ((host_index++))
  host_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "hosts" "host${host_index}")
done
LOCAL_HOST_IP_ARRAY=($(echo $LOCAL_HOST_IP | tr '.' ' '))

# zookeeper servers
ZOO_SERVERS=""
KAFKA_ZOO_SERVERS=""

# zookeeper index
zookeeper_index=1
zookeeper_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "zookeeper" "zookeeper${zookeeper_index}")
zookeeper_ip_array=($(echo $zookeeper_ip | tr '.' ' '))
zookeeper_ip_index=${zookeeper_ip_array[3]}
echo "zookeeper_ip:zookeeper${zookeeper_index}:${zookeeper_ip}"
while [[ -n "$zookeeper_ip" ]]; do
  sed -i "/zookeeper${zookeeper_ip_index}/d" /etc/hosts
  echo "${zookeeper_ip} zookeeper${zookeeper_ip_index}" >>/etc/hosts
  ZOO_SERVERS="server.${zookeeper_ip_index}=zookeeper${zookeeper_ip_index}:2888:3888;2181 ${ZOO_SERVERS}"
  KAFKA_ZOO_SERVERS="zookeeper${zookeeper_ip_index}:2181 ${KAFKA_ZOO_SERVERS}"
  ((zookeeper_index++))
  zookeeper_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "zookeeper" "zookeeper${zookeeper_index}")
  zookeeper_ip_array=($(echo $zookeeper_ip | tr '.' ' '))
  zookeeper_ip_index=${zookeeper_ip_array[3]}
  echo "zookeeper_ip:zookeeper${zookeeper_index}:${zookeeper_ip}"
done

# kafka index
kafka_index=1
kafka_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "kafka" "kafka${kafka_index}")
kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
kafka_ip_index=${kafka_ip_array[3]}
kafka_ip_index_first=${kafka_ip_array[3]}
echo "kafka_ip:kafka${kafka_index}:${kafka_ip}"
while [[ -n "$kafka_ip" ]]; do
  sed -i "/kafka${kafka_ip_index}/d" /etc/hosts
  echo "${kafka_ip} kafka${kafka_ip_index}" >>/etc/hosts
  ((kafka_index++))
  kafka_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "kafka" "kafka${kafka_index}")
  kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
  kafka_ip_index=${kafka_ip_array[3]}
  echo "kafka_ip:kafka${kafka_index}:${kafka_ip}"
done

# kafka topic
kafka_topic_index=1
kafka_topic=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "kafka-topic" "topic${kafka_topic_index}")
echo "kafka_topic:${kafka_topic_index}:${kafka_topic}"
while [[ -n "$kafka_topic" ]]; do
  kafka_topic_array+=($kafka_topic)
  ((kafka_topic_index++))
  kafka_topic=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "kafka-topic" "topic${kafka_topic_index}")
  echo "kafka_topic:${kafka_topic_index}:${kafka_topic}"
done

# ZOO_SERVERS >> /etc/profile
sed -i "/export ZOO_SERVERS=/d" /etc/profile
echo "export ZOO_SERVERS=\"${ZOO_SERVERS}\"" >>/etc/profile

# docker-compose
sed -i "s/^      - ZOO_SERVERS=.*/      - ZOO_SERVERS=${ZOO_SERVERS}/g" $INSTALL_PACKAGE_DIR/component/zookeeper/docker-compose.yml
sed -i "s/^      - ZOO_MY_ID=.*/      - ZOO_MY_ID=${LOCAL_HOST_IP_ARRAY[3]}/g" $INSTALL_PACKAGE_DIR/component/zookeeper/docker-compose.yml

sed -i "s/^      - ZOO_SERVERS=.*/      - ZOO_SERVERS=${KAFKA_ZOO_SERVERS}/g" $INSTALL_PACKAGE_DIR/component/kafka/docker-compose.yml
sed -i "s/^      - BROKER_ID=.*/      - BROKER_ID=${LOCAL_HOST_IP_ARRAY[3]}/g" $INSTALL_PACKAGE_DIR/component/kafka/docker-compose.yml
sed -i "s/^      - LISTENERS=.*/      - LISTENERS=PLAINTEXT:\/\/${LOCAL_HOST_IP}:9092/g" $INSTALL_PACKAGE_DIR/component/kafka/docker-compose.yml

# postgresql
POSTGRESQL_PASSWORD=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "postgresql" "password")
sed -i "s/^      - POSTGRES_PASSWORD=.*/      - POSTGRES_PASSWORD=${POSTGRESQL_PASSWORD}/g" $INSTALL_PACKAGE_DIR/component/postgresql/docker-compose.yml

# redis
REDIS_PASSWORD=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "redis" "password")
sed -i "s/^requirepass.*/requirepass ${REDIS_PASSWORD}/g" $INSTALL_PACKAGE_DIR/component/redis/config/redis.conf

# 日志文件目录
INSTALL_LOG_DIR=/var/tiny-setup/
if [ -d $INSTALL_LOG_DIR ]; then
  echo "[exist] ${INSTALL_LOG_DIR}"
else
  mkdir -p $INSTALL_LOG_DIR
fi

# 日志文件
LOG_FILE=/var/tiny-setup/install.log
if [ -e $LOG_FILE ]; then
  echo "[exist] ${LOG_FILE}"
else
  touch $LOG_FILE
fi

echo "--- common version: ${VERSION} end ---"
echo -e "\n"

SSH_CONFIG_FILE=/etc/ssh/sshd_config
INSTALL_PACKAGE_INFO=/opt/tiny-setup-package/install-package/package_info.properties
WORK_PACKAGE_INFO=/home/tiny-setup-package/install-package/package_info.properties

# 获取词条 $1 词条序号 $2 语言编号
function getI18nConfig() {
  env_file=${INSTALL_PACKAGE_INFO}

  number=$1
  language=$2

  if [ "$language" = "中文" ]; then
    param="message.${number}.zh_CN"
  elif [ "$language" = "English" ]; then
    param="message.${number}.en_US"
  else
    exit 1
  fi

  value=$(sed -E '/^#.*|^ *$/d' $env_file | awk -F "${param}=" "/${param}=/{print \$2}" | awk -F = '{print $1}')

  echo $value
}

#日志方法 ---------------------------------------------------------------------------------------
#日志文件 /var/tiny-setup/install.log

#调试日志
function log_debug() {
  content="[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 1 ] && echo $content >>$LOG_FILE && echo -e "\033[32m" ${content} "\033[0m"
}
#信息日志
function log_info() {
  content="[INFO] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 2 ] && echo $content >>$LOG_FILE && echo -e "\033[34m" ${content} "\033[0m"
}
#重点关注日志
function log_note() {
  content="[NOTE] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 3 ] && echo $content >>$LOG_FILE && echo -e "\033[33m" ${content} "\033[0m"
}
#错误日志
function log_err() {
  content="[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 4 ] && echo $content >>$LOG_FILE && echo -e "\033[31m" ${content} "\033[0m"
}
#一直都会打印的日志
function log_always() {
  content="[ALWAYS] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 5 ] && echo $content >>$LOG_FILE && echo -e "\033[32m" ${content} "\033[0m"
}
