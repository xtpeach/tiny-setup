#!/bin/bash

# exporter port
exporter_port=9100

# node exporter 的版本/下载地址
node_exporter_version=node_exporter-1.6.0.linux-amd64
node_exporter_version_file=node_exporter-1.6.0.linux-amd64.tar.gz
node_exporter_version_url=https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz

base_path=$(dirname "${BASH_SOURCE[0]}")

# 创建 /home/exporter/node 目录
mkdir -p /home/exporter/node

# 判断当前路径下面有没有 node exporter 安装文件，如果有就将其拷贝到安装目录
if [[ ! -f $node_exporter_version_file ]]; then
  cp -a $base_path/$node_exporter_version_file /home/exporter/node/
fi

# 进入 node exporter 安装目录
cd /home/exporter/node

# 下载 node exporter 安装文件
if [[ ! -f $node_exporter_version_file ]]; then
  wget $node_exporter_version_url
fi

# 解压安装文件
tar zxvf $node_exporter_version_file  -C /usr/local/

# 进入 /usr/local/
cd /usr/local/

# 添加超链接
ln -s $node_exporter_version/ node_exporter

# 创建 service 文件
cat >/usr/lib/systemd/system/node_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
ExecStart=/usr/local/node_exporter/node_exporter --web.listen-address=:$exporter_port
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 node exporter
systemctl enable node_exporter

# 重启 node exporter service
systemctl restart node_exporter

# 查看 node exporter 状态
systemctl status node_exporter

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
firewall-cmd --reload