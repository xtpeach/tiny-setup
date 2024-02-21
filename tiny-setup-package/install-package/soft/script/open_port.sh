#!/bin/bash
# source
source ./common.sh

# centos
if [[ "$OS_NAME" == "centos" ]]; then
  # 循环开启所有配置要开启的端口
  for index in "${!OPEN_PORT_ARRAY[@]}"; do
    # 打印日志，记录开启的端口
    log_note "firewall-cmd --zone=public --add-port=${OPEN_PORT_ARRAY[$index]}/tcp --permanent"
    # 开启端口
    firewall-cmd --zone=public --add-port=${OPEN_PORT_ARRAY[$index]}/tcp --permanent
  done

  # 展示所有已经开启的端口
  firewall-cmd --list-ports

  # 防火墙重新加载所有端口
  firewall-cmd --reload
fi
