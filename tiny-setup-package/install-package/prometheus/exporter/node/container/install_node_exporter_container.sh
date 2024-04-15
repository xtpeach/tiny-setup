#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# 判断镜像文件是否存在，如果存在就加载一下
if [[ -f node-exporter.tar ]]; then
  cp -a $base_path/node-exporter.tar /home/exporter/node/
  docker load < $base_path/node-exporter.tar
fi

# 安装 exporter 容器
docker-compose up -d