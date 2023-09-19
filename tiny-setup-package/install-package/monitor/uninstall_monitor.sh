#!/bin/bash

uninstall() {
  service_name=$1
  service_name="${service_name}.service"
  systemctl stop "$service_name"
  #删除服务
  rm -rf /usr/lib/systemd/system/"$service_name"
}

monitor_service_name=$1
[[ "$monitor_service_name"x != x ]] && {
  uninstall $monitor_service_name
  systemctl daemon-reload
}
