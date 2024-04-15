#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9100

# 判断镜像文件是否存在，如果存在就加载一下
if [[ -f node-exporter.tar ]]; then
  docker load < $base_path/node-exporter.tar
fi

# 安装 exporter 容器
docker-compose up -d

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
if [[ $(systemctl is-active --quiet firewalld) ]]; then
  firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
  firewall-cmd --reload
else
  iptables -I INPUT -p tcp --dport $exporter_port -j ACCEPT
fi
