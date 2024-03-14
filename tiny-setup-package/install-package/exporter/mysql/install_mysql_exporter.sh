#!/bin/bash

mysql_username=insight
mysql_password=Sungrow2011!

base_path=$(dirname "${BASH_SOURCE[0]}")

# 创建 /home/exporter/mysql 目录
mkdir -p /home/exporter/mysql

# 判断当前路径下面有没有 mysql exporter 安装文件，如果有就将其拷贝到安装目录
if [[ ! -f mysqld_exporter-0.12.1.linux-amd64.tar.gz ]]; then
  cp -a $base_path/mysqld_exporter-0.12.1.linux-amd64.tar.gz /home/exporter/mysql/
fi

# 进入 mysql exporter 安装目录
cd /home/exporter/mysql

# 下载 mysql exporter 安装文件
if [[ ! -f mysqld_exporter-0.12.1.linux-amd64.tar.gz ]]; then
  wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz
fi

# 解压安装文件
tar zxvf mysqld_exporter-0.12.1.linux-amd64.tar.gz  -C /usr/local/

# 进入 /usr/local/
cd /usr/local/

# 添加超链接
ln -s mysqld_exporter-0.12.1.linux-amd64/ mysqld_exporter

# 进入 /usr/local/mysqld_exporter
cd /usr/local/mysqld_exporter

# 创建 .my.cnf 该文件为隐藏文件
cat > .my.cnf <<EOF
[client]
user=$mysql_username
password=$mysql_password
EOF

# 创建 service 文件
cat >/usr/lib/systemd/system/mysqld_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
Environment=DATA_SOURCE_NAME=$mysql_username:$mysql_password@(localhost:20002)/
ExecStart=/usr/local/mysqld_exporter/mysqld_exporter --config.my-cnf=/usr/local/mysqld_exporter/.my.cnf --web.listen-address=:9104
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 mysql exporter
systemctl enable mysqld_exporter

# 重启 mysql exporter service
systemctl restart mysqld_exporter

# 查看 mysql exporter 状态
systemctl status mysqld_exporter

# 开启防火墙端口
firewall-cmd --zone=public --add-port=9104/tcp --permanent
firewall-cmd --reload