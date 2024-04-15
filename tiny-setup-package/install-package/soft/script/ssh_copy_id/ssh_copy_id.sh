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

# 配置了互信之后，可以使用 ssh 直接到远程服务器上面执行命令
# ssh -p 22 root@192.168.96.129 "mkdir -p /home/xtpeach"

# 配置了互信之后，可以使用 scp 命令拷贝文件到远程服务器上面
# scp -r -P 22 /home/xtpeach root@192.168.96.129:/home/xtpeach

# 也可以使用 rsync 同步文件到别的服务器
# rsync -a --progress "-e ssh -p 22" --delete /home/xtpeach root@192.168.96.129:/home/xtpeach