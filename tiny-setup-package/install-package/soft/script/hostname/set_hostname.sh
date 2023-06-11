#!/bin/bash
host_name_str=$1

# 输入名称不为空
[[ "$host_name_str"x != x ]] && {
  hostnamectl $host_name_str
  hostnamectl status
}

# 输入名称为空
[[ "$host_name_str"x == x ]] && {
  echo "null"
}