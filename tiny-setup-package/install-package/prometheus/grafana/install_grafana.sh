#!/bin/bash
# grafana dashboard 查询地址
# https://grafana.com/grafana/dashboards/

# 清除之前的容器
docker-compose down
# 清除之前的数据
rm -rf ./data
# 创建一个放置数据的目录
mkdir -p ./data
# 给目录赋权限
chmod -R 777 ./data
# 启动容器
docker-compose up -d

# grafana 端口
grafana_port=3000

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
if systemctl is-active --quiet firewalld; then
  firewall-cmd --zone=public --add-port=$grafana_port/tcp --permanent
  firewall-cmd --reload
else
  iptables -I INPUT -p tcp --dport $grafana_port -j ACCEPT
fi