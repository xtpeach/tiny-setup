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