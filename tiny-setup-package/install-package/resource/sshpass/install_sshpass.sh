#!/bin/bash

# 检查sshpass命令是否存在
if [[ ! $(command -v sshpass) ]]; then
  echo "sshpass命令不存在，开始安装sshpass-1.06-2.el7.x86_64.rpm"
  rpm -ivh --force ./rpm/sshpass-1.06-2.el7.x86_64.rpm
fi

# 再次检查sshpass命令是否存在
if [[ ! $(command -v sshpass) ]]; then
  echo "sshpass命令仍然不存在，开始安装rpm/目录下所有的.rpm包"
  rpm -ivh --force ./rpm/*.rpm
fi
