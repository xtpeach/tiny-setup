#!/bin/bash

install() {
  service_name=$1

  service_file=./${service_name}/"${service_name}.sh"
  do_service_file=./${service_name}/"do_${service_name}.sh"

  service_name="${service_name}.service"

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

  chmod +x $service_file
  chmod +x $do_service_file

  cp -Rp -f /home/install-package/monitor/"$service_name" /usr/lib/systemd/system/"$service_name"
  chmod -R 644 /usr/lib/systemd/system/"$service_name"
  systemctl daemon-reload
  systemctl enable "$service_name"
  systemctl restart "$service_name"
}

monitor_service_name=$1
[[ "$monitor_service_name"x != x ]] && {
  install $monitor_service_name
}
