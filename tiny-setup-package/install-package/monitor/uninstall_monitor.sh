#!/bin/bash

uninstall() {
  service_name=$1
  systemctl stop "$service_name"
  #删除服务
  rm -rf /usr/lib/systemd/system/"$service_name"
}


