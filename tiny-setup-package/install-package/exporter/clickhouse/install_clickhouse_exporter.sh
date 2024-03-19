#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9116

# clickhouse 的用户名/密码
clickhouse_username=default
clickhouse_password=123456
clickhouse_host="localhost"
clickhouse_port=8123

# clickhouse exporter 文件位置（编译好的文件）
clickhouse_exporter_version_file=clickhouse_exporter

# 创建 /home/exporter/clickhouse 目录
mkdir -p /home/exporter/clickhouse

# 判断当前路径下面有没有 clickhouse exporter 安装文件，如果有就将其拷贝到安装目录
if [[ ! -f $clickhouse_exporter_version_file ]]; then
  cp -a $base_path/$clickhouse_exporter_version_file /home/exporter/clickhouse/
fi

# 进入 clickhouse exporter 安装目录
cd /home/exporter/clickhouse

# 解压安装文件
mkdir -p /usr/local/clickhouse_exporter
cp -a /home/exporter/clickhouse/$clickhouse_exporter_version_file /usr/local/clickhouse_exporter

# 进入 /usr/local/
cd /usr/local/clickhouse_exporter
chmod +x $clickhouse_exporter_version_file

# 创建 service 文件
cat >/usr/lib/systemd/system/clickhouse_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
#ExecStart=/usr/local/clickhouse_exporter/clickhouse_exporter -scrape_uri=http://$clickhouse_username:$clickhouse_password@$clickhouse_host:$clickhouse_port/  --telemetry.address=:$exporter_port
ExecStart=/usr/local/clickhouse_exporter/clickhouse_exporter -scrape_uri=http://$clickhouse_host:$clickhouse_port/ --telemetry.address=:$exporter_port
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 clickhouse exporter
systemctl enable clickhouse_exporter

# 重启 clickhouse exporter service
systemctl restart clickhouse_exporter

# 查看 clickhouse exporter 状态
systemctl status clickhouse_exporter

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
firewall-cmd --reload