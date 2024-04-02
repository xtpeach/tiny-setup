#!/bin/bash
# nginx 的 exporter 需要 nginx 自身支持 !!!

# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# exporter port
exporter_port=9113

nginx_host="localhost"
nginx_port=80

# nginx exporter 的版本/下载地址
nginx_exporter_version=nginx-prometheus-exporter_0.9.0_linux_amd64
nginx_exporter_version_file=nginx-prometheus-exporter_0.9.0_linux_amd64.tar.gz
nginx_exporter_version_url=https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.9.0/nginx-prometheus-exporter_0.9.0_linux_amd64.tar.gz

# 创建 /home/exporter/nginx 目录
mkdir -p /home/exporter/nginx

# 判断当前路径下面有没有 nginx exporter 安装文件，如果有就将其拷贝到安装目录
if [[ -f $nginx_exporter_version_file ]]; then
  cp -a $base_path/$nginx_exporter_version_file /home/exporter/nginx/
fi

# 进入 nginx exporter 安装目录
cd /home/exporter/nginx

# 下载 nginx exporter 安装文件
if [[ ! -f $nginx_exporter_version_file ]]; then
  wget $nginx_exporter_version_url
fi

# 解压安装文件
tar -zxvf $nginx_exporter_version_file  -C /usr/local/

# 进入 /usr/local/
cd /usr/local/

# 添加超链接
ln -s $nginx_exporter_version/ nginx_exporter

# 创建 service 文件
cat >/usr/lib/systemd/system/nginx_exporter.service  <<EOF
[Unit]
Description=Prometheus
[Service]
ExecStart=/usr/local/nginx_exporter/nginx-prometheus-exporter -nginx.scrape-uri=http://$nginx_host:$nginx_port/nginx_status
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 启用 nginx exporter
systemctl enable nginx_exporter

# 重启 nginx exporter service
systemctl restart nginx_exporter

# 查看 nginx exporter 状态
systemctl status nginx_exporter

# 下面开通防火墙端口需要根据不同的操作系统来
# 开启防火墙端口(CentOS)
if systemctl is-active --quiet firewalld; then
  firewall-cmd --zone=public --add-port=$exporter_port/tcp --permanent
  firewall-cmd --reload
else
  iptables -I INPUT -p tcp --dport $exporter_port -j ACCEPT
fi
