#!/bin/bash

install() {
  service_name=$1
  #判断服务是否已存在
  isExist=$(systemctl list-units --type=service | grep "$service_name" | wc -l)
  if [ "$isExist" == "1" ]; then
    echo "$service_name is installed!"
    status=$(systemctl status "$service_name" | grep "Active: active" | awk '{print $3}')
    if [ "$status" == "(running)" ]; then
      #停止服务
      systemctl stop "$service_name"
    fi
    #删除服务
    rm -rf /usr/lib/systemd/system/"$service_name"
    systemctl daemon-reload
  else
    echo "$service_name is not installed!"
  fi
  cp -Rp -f /home/sungrow/watch_dog/"$service_name" /usr/lib/systemd/system/"$service_name"
  chmod -R 644 /usr/lib/systemd/system/"$service_name"
  systemctl daemon-reload
  systemctl enable "$service_name"
  systemctl restart "$service_name"
}


