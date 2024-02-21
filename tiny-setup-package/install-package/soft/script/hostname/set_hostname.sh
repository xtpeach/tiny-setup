#!/bin/bash

# 接受一个字符串参数，用于设置主机实例的 hostname
host_name_str=$1

# 输入名称不为空
[[ "$host_name_str"x != x ]] && {
  # 设置主机的 hostname
  hostnamectl set-hostname $host_name_str
  # 查看主机的 hostname
  hostnamectl status
  # 检查 hostname 是否设置成功
  set_hostname_flag=$(cat /etc/hosts | grep -v 'grep' | grep $host_name_str)
  # 如果检查到 hostname 设置成功了则添加 hosts 配置
  if [ "$set_hostname_flag"x == "x" ]; then
    # 添加 hosts 配置到 /etc/hosts 文件当中
    echo "127.0.0.1   $(hostname)" >>/etc/hosts
  fi
}

# 输入名称为空
[[ "$host_name_str"x == x ]] && {
  # 打印输出，hostname 输入为空
  echo "set_hostname input hostname is null"
}
