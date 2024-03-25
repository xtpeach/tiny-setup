#!/bin/bash

# 卸载 service 方法
uninstall() {
  # 传入 servce 的名称
  service_name=$1

  # 找到和服务名称同名的 service
  service_name="${service_name}.service"

  # 判断服务是否已存在
  isExist=$(systemctl list-units --type=service | grep "$service_name" | wc -l)
  if [ "$isExist" == "1" ]; then
    echo -e "\033[0;32m $service_name is uninstalling... \033[0m"
    # 停止服务
    systemctl stop "$service_name"
    # 卸载服务
    rm -rf /usr/lib/systemd/system/"$service_name"
    # 重新加载
    systemctl daemon-reload
  fi

  # 完成卸载
  echo -e "\033[0;32m $service_name is uninstalled! \033[0m"
}

# 接收调用脚本时传入的参数：要卸载的服务名字符串
monitor_service_name=$1

# 如果传入的要卸载的服务名字符串不为空，则执行卸载
if [[ "$monitor_service_name"x != x ]]; then
  uninstall $monitor_service_name
else
  echo -e "\033[0;31m monitor_service_name is null \033[0m"
fi
