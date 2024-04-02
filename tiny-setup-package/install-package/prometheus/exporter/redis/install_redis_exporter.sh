#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9121

# redis 的用户名/密码
redis_password=123456
redis_host="localhost"
redis_port=6379

# redis exporter 的版本/下载地址
redis_exporter_version=redis_exporter-v1.29.0.linux-amd64
redis_exporter_version_file=redis_exporter-v1.29.0.linux-amd64.tar.gz
redis_exporter_version_url=https://github.com/oliver006/redis_exporter/releases/download/v1.29.0/redis_exporter-v1.29.0.linux-amd64.tar.gz

# 创建 /home/exporter/redis 目录
mkdir -p /home/exporter/redis

# 判断当前路径下面有没有 redis exporter 安装文件，如果有就将其拷贝到安装目录
if [[ -f $redis_exporter_version_file ]]; then
  cp -a $base_path/$redis_exporter_version_file /home/exporter/redis/
fi

# 进入 redis exporter 安装目录
cd /home/exporter/redis

# 下载 redis exporter 安装文件
if [[ ! -f $redis_exporter_version_file ]]; then
  wget $redis_exporter_version_url
fi

# 解压安装文件
tar -zxvf $redis_exporter_version_file  -C /usr/local/

# 进入 /usr/local/
cd /usr/local/

# 添加超链接
ln -s $redis_exporter_version/ redis_exporter

# 创建 service 文件
cat >/usr/lib/systemd/system/redis_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
ExecStart=/usr/local/redis_exporter/redis_exporter -redis.addr $redis_host:$redis_port -redis.password $redis_password --web.listen-address=:$exporter_port
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 redis exporter
systemctl enable redis_exporter

# 重启 redis exporter service
systemctl restart redis_exporter

# 查看 redis exporter 状态
systemctl status redis_exporter

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
if [[ $(systemctl is-active --quiet firewalld) ]]; then
  firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
  firewall-cmd --reload
else
  iptables -I INPUT -p tcp --dport $exporter_port -j ACCEPT
fi
