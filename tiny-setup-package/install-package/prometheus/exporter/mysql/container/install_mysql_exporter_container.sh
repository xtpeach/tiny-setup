#!/bin/bash

# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# 判断镜像文件是否存在，如果存在就加载一下
if [[ -f mysqld-exporter.tar ]]; then
  docker load < $base_path/mysqld-exporter.tar
fi

# 进入 /usr/local/mysqld_exporter
mkdir -p /usr/local/mysqld_exporter
cd /usr/local/mysqld_exporter

# 创建 .my.cnf 该文件为隐藏文件
cat > .my.cnf <<EOF
[client]
user=$mysql_username
password=$mysql_password
EOF

# 安装 exporter 容器
docker-compose up -d