#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9308

# kafka 的用户名/密码
kafka_sasl_username=kafka
kafka_sasl_password=123456
kafka_host="localhost"
kafka_port=9292
zookeeper_host="localhost"
zookeeper_port=2181

# kafka exporter 的版本/下载地址
kafka_exporter_version=kafka_exporter-1.7.0.linux-amd64
kafka_exporter_version_file=kafka_exporter-1.7.0.linux-amd64.tar.gz
kafka_exporter_version_url=https://github.com/danielqsj/kafka_exporter/releases/download/v1.7.0/kafka_exporter-1.7.0.linux-amd64.tar.gz

# 创建 /home/exporter/kafka 目录
mkdir -p /home/exporter/kafka

# 判断当前路径下面有没有 kafka exporter 安装文件，如果有就将其拷贝到安装目录
if [[ -f $kafka_exporter_version_file ]]; then
  cp -a $base_path/$kafka_exporter_version_file /home/exporter/kafka/
fi

# 进入 kafka exporter 安装目录
cd /home/exporter/kafka

# 下载 kafka exporter 安装文件
if [[ ! -f $kafka_exporter_version_file ]]; then
  wget $kafka_exporter_version_url
fi

# 解压安装文件
tar -zxvf $kafka_exporter_version_file  -C /usr/local/

# 进入 /usr/local/
cd /usr/local/

# 添加超链接
ln -s $kafka_exporter_version/ kafka_exporter

# 创建 service 文件
cat >/usr/lib/systemd/system/kafka_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
#ExecStart=/usr/local/kafka_exporter/kafka_exporter --kafka.server=$kafka_host:$kafka_port --web.listen-address=:$exporter_port
ExecStart=/usr/local/kafka_exporter/kafka_exporter --kafka.server=$kafka_host:$kafka_port --zookeeper.server=$zookeeper_host:$zookeeper_port --sasl.enabled --sasl.mechanism=plain --sasl.username=$kafka_sasl_username --sasl.password=$kafka_sasl_password --web.listen-address=:$exporter_port
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 kafka exporter
systemctl enable kafka_exporter

# 重启 kafka exporter service
systemctl restart kafka_exporter

# 查看 kafka exporter 状态
systemctl status kafka_exporter

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
if [[ $(systemctl is-active --quiet firewalld) ]]; then
  firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
  firewall-cmd --reload
else
  iptables -I INPUT -p tcp --dport $exporter_port -j ACCEPT
fi
