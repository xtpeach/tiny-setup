#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9187

# postgresql 的用户名/密码
postgresql_username=postgres
postgresql_password=postgresql!123456
postgresql_host="localhost"
postgresql_port=5432

# postgresql exporter 的版本/下载地址
postgresql_exporter_version=postgres_exporter-0.13.2.linux-amd64
postgresql_exporter_version_file=postgres_exporter-0.13.2.linux-amd64.tar.gz
postgresql_exporter_version_url=https://github.com/prometheus-community/postgres_exporter/releases/download/v0.13.2/postgres_exporter-0.13.2.linux-amd64.tar.gz

# 创建 /home/exporter/postgresql 目录
mkdir -p /home/exporter/postgresql

# 判断当前路径下面有没有 postgresql exporter 安装文件，如果有就将其拷贝到安装目录
if [[ -f $postgresql_exporter_version_file ]]; then
  cp -a $base_path/$postgresql_exporter_version_file /home/exporter/postgresql/
fi

# 进入 postgresql exporter 安装目录
cd /home/exporter/postgresql

# 下载 postgresql exporter 安装文件
if [[ ! -f $postgresql_exporter_version_file ]]; then
  wget $postgresql_exporter_version_url
fi

# 解压安装文件
tar -zxvf $postgresql_exporter_version_file  -C /usr/local/

# 进入 /usr/local/
cd /usr/local/

# 添加超链接
ln -s $postgresql_exporter_version/ postgresql_exporter

# 创建 service 文件
cat >/usr/lib/systemd/system/postgresql_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
Environment=DATA_SOURCE_NAME=postgresql://$postgresql_username:$postgresql_password@$postgresql_host:$postgresql_port/postgres?sslmode=disable
ExecStart=/usr/local/postgresql_exporter/postgres_exporter --web.listen-address=:$exporter_port
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 postgresql exporter
systemctl enable postgresql_exporter

# 重启 postgresql exporter service
systemctl restart postgresql_exporter

# 查看 postgresql exporter 状态
systemctl status postgresql_exporter

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
if [[ $(systemctl is-active --quiet firewalld) ]]; then
  firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
  firewall-cmd --reload
else
  iptables -I INPUT -p tcp --dport $exporter_port -j ACCEPT
fi
