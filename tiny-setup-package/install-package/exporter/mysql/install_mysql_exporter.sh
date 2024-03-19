#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9104

# mysql 的用户名/密码
mysql_username="root"
mysql_password=123456
mysql_host="localhost"
mysql_port=3306

# mysql exporter 的版本/下载地址
mysql_exporter_version=mysqld_exporter-0.12.1.linux-amd64
mysql_exporter_version_file=mysqld_exporter-0.12.1.linux-amd64.tar.gz
mysql_exporter_version_url=https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz

# 创建 /home/exporter/mysql 目录
mkdir -p /home/exporter/mysql

# 判断当前路径下面有没有 mysql exporter 安装文件，如果有就将其拷贝到安装目录
if [[ ! -f $mysql_exporter_version_file ]]; then
  cp -a $base_path/$mysql_exporter_version_file /home/exporter/mysql/
fi

# 进入 mysql exporter 安装目录
cd /home/exporter/mysql

# 下载 mysql exporter 安装文件
if [[ ! -f $mysql_exporter_version_file ]]; then
  wget $mysql_exporter_version_url
fi

# 解压安装文件
tar zxvf $mysql_exporter_version_file -C /usr/local/

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
Environment=DATA_SOURCE_NAME=$mysql_username:$mysql_password@($mysql_host:$mysql_port)/
ExecStart=/usr/local/mysqld_exporter/mysqld_exporter --config.my-cnf=/usr/local/mysqld_exporter/.my.cnf --web.listen-address=:$exporter_port
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

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
firewall-cmd --zone=public --add-port=9104/tcp --permanent
firewall-cmd --reload