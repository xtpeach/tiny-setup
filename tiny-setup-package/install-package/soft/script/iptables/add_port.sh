#!/bin/bash
# 接受一个参数，输入一个端口
port=$1

# 使用 iptables 添加端口规则
iptables -A INPUT -p tcp --dport $port -j ACCEPT

# 创建保存 iptables 规则的路径
mkdir -p /etc/iptables

# 创建 iptables 规则保存文件
touch /etc/iptables/rules.v4

# 将 iptables 规则保存至文件
iptables-save > /etc/iptables/rules.v4