#!/bin/bash

# 安装 service 方法
install() {
  # service 的名称
  service_name=$1

  # 找到同服务名的文件夹和同服务名的脚本
  service_file=./${service_name}/"${service_name}.sh"
  do_service_file=./${service_name}/"do_${service_name}.sh"

  # 找到同服务名的 .service 文件
  service_name="${service_name}.service"

  # 判断服务是否已存在
  isExist=$(systemctl list-units --type=service | grep "$service_name" | wc -l)
  if [ "$isExist" == "1" ]; then
    echo -e "\033[0;33m $service_name is reinstalling... \033[0m"
    status=$(systemctl status "$service_name" | grep "Active: active" | awk '{print $3}')
    if [ "$status" == "(running)" ]; then
      #停止服务
      systemctl stop "$service_name"
    fi
    #删除服务
    rm -rf /usr/lib/systemd/system/"$service_name"
    systemctl daemon-reload
  else
    echo -e "\033[0;32m $service_name is installing... \033[0m"
  fi

  # 赋执行权限
  chmod +x $service_file
  chmod +x $do_service_file

  # 拷贝文件并执行安装
  cp -Rp -f ./"$1"/"$service_name" /usr/lib/systemd/system/"$service_name"
  chmod -R 644 /usr/lib/systemd/system/"$service_name"
  systemctl daemon-reload
  systemctl enable "$service_name"
  systemctl restart "$service_name"

  # 完成安装
  echo -e "\033[0;32m $service_name is installed! \033[0m"
}

# 接收调用脚本时传入的参数：要安装的服务名字符串
monitor_service_name=$1

# 如果传入的要安装的服务名字符串不为空，则执行安装
if [[ "$monitor_service_name"x != x ]]; then
  install $monitor_service_name
else
  echo -e "\033[0;31m monitor_service_name is null \033[0m"
fi
