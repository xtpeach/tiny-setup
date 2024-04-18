#!/bin/bash
# source
source ../../soft/script/common.sh

# 修改 docker-compose.yml 文件
sed -i "s/^      - POSTGRES_PASSWORD=.*/      - POSTGRES_PASSWORD=${POSTGRESQL_PASSWORD}/g" $INSTALL_PACKAGE_DIR/component/postgresql/docker-compose.yml

# postgresql data
log_debug "[install postgresql]" "mkdir -p /data/postgresql"
mkdir -p /data/postgresql

# load image
if [[ -f $INSTALL_PACKAGE_DIR/resource/docker-images/postgresql.14.8.tar ]]; then
  log_debug "[install postgresql]" "cd $INSTALL_PACKAGE_DIR/resource/docker-images && docker load < postgresql.14.8.tar"
  cd $INSTALL_PACKAGE_DIR/resource/docker-images
  docker load < postgresql.14.8.tar
else
  log_note "[install postgresql]" "docker pull postgresql:14.8"
  docker pull postgresql:14.8
fi

# stop container
log_debug "[install postgresql]" "cd $INSTALL_PACKAGE_DIR/component/postgresql && docker-compose down"
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose down

# start container
log_debug "[install postgresql]" "cd $INSTALL_PACKAGE_DIR/component/postgresql && docker-compose up -d"
cd $INSTALL_PACKAGE_DIR/component/postgresql
docker-compose up -d

# create databases
sleep 10s

# 函数：检查 PostgreSQL 服务是否已经启动
check_postgresql_service() {
  local container_name="$1"
  local postgres_cmd="psql -U postgres -c 'SELECT 1;'"
  local max_attempts=20
  local attempt=1

  # 检查容器是否存在
  local container_exists=$(docker ps -q --filter "name=$container_name")

  if [[ -n "$container_exists" ]]; then
    # 循环检查 PostgreSQL 服务是否已启动
    log_debug "[install postgresql]" "等待 PostgreSQL 服务启动..."
    while [[ $attempt -le $max_attempts ]]; do
      if docker exec -i "$container_name" bash -c "$postgres_cmd" &>/dev/null; then
        log_debug "[install postgresql]" "PostgreSQL 服务已启动"
        return 0
      else
        log_debug "[install postgresql]" "尝试 $attempt/$max_attempts：PostgreSQL 服务尚未启动，继续等待..."
        sleep 1
        ((attempt++))
      fi
    done
    log_debug "[install postgresql]" "错误：PostgreSQL 服务启动超时"
    exit 1
  else
    log_debug "[install postgresql]" "错误：PostgreSQL 容器 $container_name 不存在"
    exit 1
  fi
}

# PostgreSQL 容器名称
postgresql_container_name="postgresql"

# 调用函数检查 PostgreSQL 服务是否已启动
check_postgresql_service "$postgresql_container_name"

log_debug "[install postgresql]" "create database"
bash $INSTALL_PACKAGE_DIR/component/postgresql/create_databases.sh

# config files
log_debug "[install postgresql]" "cp -a $INSTALL_PACKAGE_DIR/component/postgresql/config/* /data/postgresql"
cp -a $INSTALL_PACKAGE_DIR/component/postgresql/config/* /data/postgresql
log_debug "[install postgresql]" "docker-compose restart"
docker-compose restart