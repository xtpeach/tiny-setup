#!/bin/bash
# 解压源码包
tar -zxvf webssh-1.6.2.tar.gz

# 进入源码包
cd webssh-1.6.2

# 启动服务
docker-compose up -d