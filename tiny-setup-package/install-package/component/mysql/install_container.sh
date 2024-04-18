#!/bin/bash
# source
source ../../soft/script/common.sh

# 修改 docker-compose.yml 文件
sed -i "s/^      - MYSQL_ROOT_PASSWORD=.*/      - MYSQL_ROOT_PASSWORD=${MYSQL_PASSWORD}/g" $INSTALL_PACKAGE_DIR/component/mysql/docker-compose.yml

# mysql data
mkdir -p /data/mysql
log_debug "[install mysql]" "mkdir -p /data/mysql"

# config files
log_debug "[install mysql]" "mkdir -p /home/mysql/conf"
mkdir -p /home/mysql/conf
log_debug "[install mysql]" "cp -a $INSTALL_PACKAGE_DIR/component/mysql/config/* /home/mysql/conf"
cp -a $INSTALL_PACKAGE_DIR/component/mysql/config/* /home/mysql/conf

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/mysql.5.7.tar ]]; then
  log_debug "[install mysql]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < mysql.5.7.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < mysql.5.7.tar
else
  log_note "[install mysql]" "docker pull mysql.5.7.tar"
  docker pull mysql:5.7
fi

# stop container
log_debug "[install mysql]" "cd $INSTALL_PACKAGE_DIR/component/mysql && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/mysql
docker-compose down

# start container
log_debug "[install mysql]" "cd $INSTALL_PACKAGE_DIR/component/mysql && docker-compose up -d"
cd $INSTALL_PACKAGE_DIR/component/mysql
docker-compose up -d

# create databases
sleep 10s

# 函数：检查 MySQL 服务是否已经启动
check_mysql_service() {
  local container_name="$1"
  local mysql_cmd="mysql -u root -p${MYSQL_PASSWORD} -e\"SELECT 1\""
  local max_attempts=20
  local attempt=1

  # 检查容器是否存在
  local container_exists=$(docker ps -q --filter "name=$container_name")

  if [[ -n "$container_exists" ]]; then
    # 循环检查 MySQL 服务是否已启动
    log_debug "[install mysql]" "等待 MySQL 服务启动..."
    while [[ $attempt -le $max_attempts ]]; do
      if docker exec -i "$container_name" bash -c "$mysql_cmd" &>/dev/null; then
        log_debug "[install mysql]" "MySQL 服务已启动"
        return 0
      else
        log_debug "[install mysql]" "尝试 $attempt/$max_attempts：MySQL 服务尚未启动，继续等待..."
        sleep 20s
        ((attempt++))
      fi
    done
    log_debug "[install mysql]" "错误：MySQL 服务启动超时"
    exit 1
  else
    log_debug "[install mysql]" "错误：MySQL 容器 $container_name 不存在"
    exit 1
  fi
}

# MySQL 容器名称
mysql_container_name="mysql"

# 调用函数检查 MySQL 服务是否已启动
check_mysql_service "$mysql_container_name"

log_debug "[install mysql]" "create database"
bash $INSTALL_PACKAGE_DIR/component/mysql/create_databases.sh
