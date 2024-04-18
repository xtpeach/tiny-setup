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

# install package dir
# -- *** [/opt/tiny-setup-package/install-package] *** --
INSTALL_PACKAGE_DIR=/opt/tiny-setup-package/install-package
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# -- log level: debug-1, info-2, warn-3, error-4, always-5 --
LOG_LEVEL=1
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# get linux name
OS_NAME=$(cat /etc/os-release | grep "^ID=" | cut -c 4- | sed 's/"//g')

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

# 这边判断一下所有的组件标记位
# install required flag
zookeeper_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "zookeeper" "installRequired")
kafka_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "kafka" "installRequired")
redis_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "redis" "installRequired")
postgresql_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "postgresql" "installRequired")
mysql_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "mysql" "installRequired")
clickhouse_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "clickhouse" "installRequired")
eureka_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "eureka" "installRequired")
nacos_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "nacos" "installRequired")
nginx_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "nginx" "installRequired")
tiny_id_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "tiny-id" "installRequired")
tiny_file_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "tiny-file" "installRequired")
tiny_sa_install_required=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "tiny-sa" "installRequired")


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

# kafka index
kafka_index=1
kafka_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "kafka" "kafka${kafka_index}")
kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
kafka_ip_index=${kafka_ip_array[3]}
kafka_ip_index_first=${kafka_ip_array[3]}
while [[ -n "$kafka_ip" ]]; do
  ((kafka_index++))
  kafka_ip=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "kafka" "kafka${kafka_index}")
  kafka_ip_array=($(echo $kafka_ip | tr '.' ' '))
  kafka_ip_index=${kafka_ip_array[3]}
done

# postgresql
POSTGRESQL_PASSWORD=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "postgresql" "password")


# mysql
MYSQL_PASSWORD=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "mysql" "password")


# clickhouse
CLICKHOUSE_PASSWORD=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "clickhouse" "password")


# redis
REDIS_PASSWORD=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "redis" "password")


# databases
DATABASE_NAMES=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "databases" "databaseNames")
DATABASE_NAME_ARRAY=($(echo ${DATABASE_NAMES} | tr ',' ' '))


# openPorts
OPEN_PORTS=$(bash $INSTALL_PACKAGE_DIR/soft/script/ini_operator.sh "get" "$INSTALL_PACKAGE_DIR/config.ini" "open-ports" "openPorts")
OPEN_PORT_ARRAY=($(echo ${OPEN_PORTS} | tr ',' ' '))


# 日志文件目录
INSTALL_LOG_DIR=/var/tiny-setup/
if [[ ! -d $INSTALL_LOG_DIR ]]; then
  mkdir -p $INSTALL_LOG_DIR
fi

# 日志文件
LOG_FILE=/var/tiny-setup/install.log
if [[ ! -e $LOG_FILE ]]; then
  touch $LOG_FILE
fi

SETUP_FILE=/var/tiny-setup/setup.log
if [[ ! -e $SETUP_FILE ]]; then
  touch $SETUP_FILE
fi

# sshd_config
SSH_CONFIG_FILE=/etc/ssh/sshd_config

# version.info
VERSION_INFO=/opt/tiny-setup-package/install-package/version.info

#日志方法 ---------------------------------------------------------------------------------------
#日志文件 /var/tiny-setup/install.log

#调试日志
function log_debug() {
  content="[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 1 ]] && echo $content >>$LOG_FILE && echo -e "\033[32m" ${content} "\033[0m"
}
#信息日志
function log_info() {
  content="[INFO] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 2 ]] && echo $content >>$LOG_FILE && echo -e "\033[34m" ${content} "\033[0m"
}
#重点关注日志
function log_note() {
  content="[NOTE] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 3 ]] && echo $content >>$LOG_FILE && echo -e "\033[33m" ${content} "\033[0m"
}
#错误日志
function log_err() {
  content="[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 4 ]] && echo $content >>$LOG_FILE && echo -e "\033[31m" ${content} "\033[0m"
}
#一直都会打印的日志
function log_always() {
  content="[ALWAYS] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [[ $LOG_LEVEL -le 5 ]] && echo $content >>$LOG_FILE && echo -e "\033[32m" ${content} "\033[0m"
}
