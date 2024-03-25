#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# 停止 redis exporter service
systemctl stop redis_exporter

# 删除 redis exporter
systemctl disable redis_exporter

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 删除文件
rm -rf /usr/local/redis_exporter
rm -rf /usr/lib/systemd/system/redis_exporter.service