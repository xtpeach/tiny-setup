#!/bin/bash
# 接受一个参数，输入一个端口
port=$1

# 判断传入的端口号不为空
if [[ "$port"x != ""x ]]; then
  # 有 firewalld 的情况
  if [[ $(systemctl is-active --quiet firewalld) ]]; then
    # 使用 firewall-cmd 进行端口开放
    firewall-cmd --zone=public --add-port=$port/tcp --permanent

    # 重新加载 firewall-cmd 开放的端口
    firewall-cmd --reload

  # 没有 firewalld 的情况，iptables 基本会有
  else
    # 使用 iptables 添加端口规则
    iptables -I INPUT -p tcp --dport $port -j ACCEPT

    # 创建保存 iptables 规则的路径
    mkdir -p /etc/iptables

    # 创建 iptables 规则保存文件
    touch /etc/iptables/rules.v4

    # 将 iptables 规则保存至文件
    iptables-save >/etc/iptables/rules.v4
  fi
fi
