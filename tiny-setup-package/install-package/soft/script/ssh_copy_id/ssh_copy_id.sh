#!/bin/bash
# 远程服务器 IP 地址
remote_ip=$1
# 远程服务器用户名
remote_username=$2
# 远程服务器密码
remote_password=$3
# ssh 服务端口
ssh_port=$4

# 使用 sshpass 配置免密互信
sshpass -p ${remote_password} ssh-copy-id -p ${ssh_port} -o "StrictHostKeyChecking no" ${remote_username}@${remote_ip}
