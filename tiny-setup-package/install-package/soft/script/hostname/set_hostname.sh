#!/bin/bash
host_name_str=$1

# 输入名称不为空
[[ "$host_name_str"x != x ]] && {
  hostnamectl set-hostname $host_name_str
  hostnamectl status
  set_hostname_flag=$(cat /etc/hosts | grep -v 'grep' | grep $host_name_str)
  if [ "$set_hostname_flag"x == "x" ]; then
    echo "127.0.0.1   $(hostname)" >>/etc/hosts
  fi
}

# 输入名称为空
[[ "$host_name_str"x == x ]] && {
  echo "null"
}
