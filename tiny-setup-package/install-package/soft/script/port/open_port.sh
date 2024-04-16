#!/bin/bash
# source
source ../common.sh

log_note "open ports ${OPEN_PORT_ARRAY[@]}"

# centos
if [[ "$OS_NAME" == "centos" ]]; then
  log_note "open ports on centos"

  if systemctl is-active --quiet firewalld; then
    log_note "firewalld status: active"
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
  else
    log_err "firewalld status: dead"
  fi

# 其他操作系统如果有 firewalld 可以直接用，如果没有，则可以使用基本都有的 iptables
else
  if systemctl is-active --quiet firewalld; then
    # 循环用 firewall-cmd 开启端口
    for index in "${!OPEN_PORT_ARRAY[@]}"; do
      # 打印日志，记录开启的端口
      log_note "firewall-cmd --zone=public --add-port=${OPEN_PORT_ARRAY[$index]}/tcp --permanent"
      firewall-cmd --zone=public --add-port=${OPEN_PORT_ARRAY[$index]}/tcp --permanent
      firewall-cmd --reload
    done
  else
    # 循环用 iptables 开启端口
    for index in "${!OPEN_PORT_ARRAY[@]}"; do
      iptables -I INPUT -p tcp --dport ${OPEN_PORT_ARRAY[$index]} -j ACCEPT
    done
  fi
fi
