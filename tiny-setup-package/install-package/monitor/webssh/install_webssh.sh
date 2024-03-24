#!/bin/bash
# ssh 可以直接通过链接连上服务器
# 举例：http://192.168.96.128:8888/?hostname=192.168.96.129&username=root&password=MTIzNDU2

# 解压源码包
tar -zxvf webssh-1.6.2.tar.gz

# 加载镜像
docker load < webssh-162_web.tar

# 进入源码包
cd webssh-1.6.2

# 启动服务
docker-compose up -d