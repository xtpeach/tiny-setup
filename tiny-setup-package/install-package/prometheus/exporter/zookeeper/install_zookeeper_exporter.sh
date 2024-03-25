#!/bin/bash
#zookeeper exporter需要在zookeeper的配置文件中添加 4lw.commands.whitelist=mntr

# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9141

# zookeeper 的用户名/密码
zookeeper_host="localhost"
zookeeper_port=2181

# zookeeper exporter 的版本/下载地址
zookeeper_exporter_version=zookeeper-exporter-v0.1.13-linux
zookeeper_exporter_version_file=zookeeper-exporter-v0.1.13-linux.tar.gz
zookeeper_exporter_version_url=https://github.com/dabealu/zookeeper-exporter/releases/download/v0.1.13/zookeeper-exporter-v0.1.13-linux.tar.gz

# 创建 /home/exporter/zookeeper 目录
mkdir -p /home/exporter/zookeeper

# 判断当前路径下面有没有 zookeeper exporter 安装文件，如果有就将其拷贝到安装目录
if [[ ! -f $zookeeper_exporter_version_file ]]; then
  cp -a $base_path/$zookeeper_exporter_version_file /home/exporter/zookeeper/
fi

# 进入 zookeeper exporter 安装目录
cd /home/exporter/zookeeper

# 下载 zookeeper exporter 安装文件
if [[ ! -f $zookeeper_exporter_version_file ]]; then
  wget $zookeeper_exporter_version_url
fi

# 解压安装文件
tar -zxvf $zookeeper_exporter_version_file  -C /usr/local/

# 进入 /usr/local/
cd /usr/local/

# 添加超链接
ln -s $zookeeper_exporter_version/ zookeeper_exporter

# 创建 service 文件
cat >/usr/lib/systemd/system/zookeeper_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
ExecStart=/usr/local/zookeeper_exporter/zookeeper-exporter -zk-hosts $zookeeper_host:$zookeeper_port -listen 0.0.0.0:$exporter_port
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 zookeeper exporter
systemctl enable zookeeper_exporter

# 重启 zookeeper exporter service
systemctl restart zookeeper_exporter

# 查看 zookeeper exporter 状态
systemctl status zookeeper_exporter

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
firewall-cmd --reload