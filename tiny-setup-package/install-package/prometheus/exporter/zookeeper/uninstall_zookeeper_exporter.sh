#!/bin/bash
# 当前路径
base_path=$(dirname "${BASH_SOURCE[0]}")

# 停止 zookeeper exporter service
systemctl stop zookeeper_exporter

# 删除 zookeeper exporter
systemctl disable zookeeper_exporter

# 对 systemd 服务或单元文件进行更改后，需要运行 systemctl daemon-reload 命令来通知 systemd 守护程序重新加载配置
systemctl daemon-reload

# 删除文件
rm -rf /usr/local/zookeeper_exporter
rm -rf /usr/lib/systemd/system/zookeeper_exporter.service