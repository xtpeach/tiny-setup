#!/bin/bash
#version
VERSION=1.1

# 打印不同颜色的日志到命令行
# echo -e "\033[0;31m This text is red \033[0m"
# echo -e "\033[0;32m This text is green \033[0m"
# echo -e "\033[0;33m This text is yellow \033[0m"
# echo -e "\033[0;34m This text is blue \033[0m"
# echo -e "\033[0;35m This text is magenta \033[0m"
# echo -e "\033[0;36m This text is cyan \033[0m"

# install dir
# -- *** [/home/install-package] *** --
INSTALL_DIR=/home/tiny-setup-package/install-package

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# -- log level: debug-1, info-2, warn-3, error-4, always-5 --
LOG_LEVEL=1
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# get linux name
OS_NAME=$(cat /etc/os-release | grep "^ID=" | cut -c 4- | sed 's/"//g')

# config.conf hosts
# hosts配置下的host序号从1开始:host1 host2 host3 ...
host_index=1
# 读取 config.conf 中的 host1 的IP地址
host_ip=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "hosts" "host${host_index}")
# 获取当前操作机器的IP地址
LOCAL_HOST_IP=""
# 配置 config.conf 的 hosts 的时候，要把当前的操作机器的IP地址配置上去
while [[ -n "$host_ip" ]]; do
  # 判断 hosts 配置的IP地址是否在本地网卡上
  local_ip_flag=$(ip addr | grep -c $host_ip)
  # 如果在，表示匹配到点了当前操作机器的IP地址
  [[ $local_ip_flag -ge 1 ]] && {
    # 将匹配到的IP地址赋给当前操作机器的IP地址
    LOCAL_HOST_IP=$host_ip
    # 可以不用再继续匹配了
    break
  }

  # 为下一次循环做准备
  ((host_index++))
  # 继续向下读取 host1 host2 host3 ...
  host_ip=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "hosts" "host${host_index}")
done

# 将当前操作的机器的IP地址按照点分，放进数组
LOCAL_HOST_IP_ARRAY=($(echo $LOCAL_HOST_IP | tr '.' ' '))

# 这边判断一下所有的组件标记位
# install required flag: zookeeper
ZOOKEEPER_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "zookeeper" "install_required")
# install required flag: kafka
KAFKA_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "kafka" "install_required")
# install required flag: redis
REDIS_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "redis" "install_required")
# install required flag: postgresql
POSTGRESQL_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "postgresql" "install_required")
# install required flag: mysql
MYSQL_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "mysql" "install_required")
# install required flag: clickhouse
CLICKHOUSE_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "clickhouse" "install_required")
# install required flag: eureka
EUREKA_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "eureka" "install_required")
# install required flag: nacos
NACOS_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "nacos" "install_required")
# install required flag: nginx
NGINX_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "nginx" "install_required")
# install required flag: tiny-id
TINY_ID_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "tiny-id" "install_required")
# install required flag: tiny-file
TINY_FILE_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "tiny-file" "install_required")
# install required flag: tiny-sa
TINY_SA_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "tiny-sa" "install_required")
# install required flag: xxl-admin
XXL_ADMIN_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "xxl-admin" "install_required")
# install required flag: xxl-executor
XXL_EXECUTOR_INSTALL_REQUIRED=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "xxl-executor" "install_required")


# zookeeper servers
ZOO_SERVERS=""
KAFKA_ZOO_SERVERS=""

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
  # 将 zookeeper 的集群配置放入变量，如果只配了一个 zookeeper，那么这边就只有一个
  ZOO_SERVERS="server.${zookeeper_ip_index}=zookeeper${zookeeper_ip_index}:2888:3888;2181 ${ZOO_SERVERS}"
  # 将 kafka 配置文件中需要的 zookeeper 集群配置放入变量，如果支配了一个 zookeeper，那么这边就只有一个
  KAFKA_ZOO_SERVERS="zookeeper${zookeeper_ip_index}:2181 ${KAFKA_ZOO_SERVERS}"

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

# kafka index
# config.conf 的 kafka 序号从1开始
kafka_index=1
# 先读到第一个kafka的IP地址，即kafka1对应的IP地址
kafka_ip=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "kafka" "kafka${kafka_index}")
# 将这个IP地址按照点分放进数组
kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
# 拿到IP地址的最后一位
kafka_ip_index=${kafka_ip_array[3]}
# 拿到kafka1对应的IP地址的最后一位
KAFKA_IP_INDEX_FIRST=${kafka_ip_array[3]}
# 循环往下读 kafka1 kafka2 kafka3 ...
while [[ -n "$kafka_ip" ]]; do
  # 为下一次循环做准备
  # kafka1 kafka2 kafka3 ...
  ((kafka_index++))
  # 继续向下读取 kafka 配置，kafka1 kafka2 kafka3 ...
  kafka_ip=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "kafka" "kafka${kafka_index}")
  # 将读到的 kafka 的配置IP按照点分放入数组
  kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
  # 拿到 kafka 配置的IP的最后一位
  kafka_ip_index=${kafka_ip_array[3]}
done


# postgresql
POSTGRESQL_PASSWORD=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "postgresql" "password")


# mysql
MYSQL_PASSWORD=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "mysql" "password")


# clickhouse
CLICKHOUSE_PASSWORD=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "clickhouse" "password")


# redis
REDIS_PASSWORD=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "redis" "password")


# databases
DATABASE_NAMES=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "databases" "database_names")
DATABASE_NAME_ARRAY=($(echo ${DATABASE_NAMES} | tr ',' ' '))

# eureka
EUREKA_USER_NAME=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "eureka" "eureka_user_name")
EUREKA_USER_PASSWORD=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "eureka" "eureka_user_password")


# open_ports
OPEN_PORTS=$(bash $INSTALL_DIR/soft/script/conf_operator.sh "get" "$INSTALL_DIR/config.conf" "open-ports" "open_ports")
OPEN_PORT_ARRAY=($(echo ${OPEN_PORTS} | tr ',' ' '))


# 日志文件目录
INSTALL_LOG_DIR=/var/tiny-setup/
if [[ ! -d $INSTALL_LOG_DIR ]]; then
  mkdir -p $INSTALL_LOG_DIR
fi

# install 日志文件
INSTALL_LOG_FILE=/var/tiny-setup/install.log
if [[ ! -e $INSTALL_LOG_FILE ]]; then
  touch $INSTALL_LOG_FILE
fi

# setup 日志文件
SETUP_LOG_FILE=/var/tiny-setup/setup.log
if [[ ! -e $SETUP_LOG_FILE ]]; then
  touch $SETUP_LOG_FILE
fi

# sshd_config
SSH_CONFIG_FILE=/etc/ssh/sshd_config

# version.info
VERSION_INFO=$INSTALL_DIR/version.info

#日志方法 ---------------------------------------------------------------------------------------
#日志文件 /var/tiny-setup/install.log

#调试日志
function log_debug() {
  content="[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 1 ]] && echo $content >>$INSTALL_LOG_FILE && echo -e "\033[32m" ${content} "\033[0m"
}
#信息日志
function log_info() {
  content="[INFO] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 2 ]] && echo $content >>$INSTALL_LOG_FILE && echo -e "\033[34m" ${content} "\033[0m"
}
#重点关注日志
function log_note() {
  content="[NOTE] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 3 ]] && echo $content >>$INSTALL_LOG_FILE && echo -e "\033[33m" ${content} "\033[0m"
}
#错误日志
function log_err() {
  content="[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 4 ]] && echo $content >>$INSTALL_LOG_FILE && echo -e "\033[31m" ${content} "\033[0m"
}
#一直都会打印的日志
function log_always() {
  content="[ALWAYS] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 5 ]] && echo $content >>$INSTALL_LOG_FILE && echo -e "\033[32m" ${content} "\033[0m"
}
