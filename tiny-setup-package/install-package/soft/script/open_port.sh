#!/bin/bash
# source
source ./common.sh

# "centos"
if [[ "$OS_NAME" == "centos" ]]; then
  for index in "${!OPEN_PORT_ARRAY[@]}"; do
    log_note "firewall-cmd --zone=public --add-port=${OPEN_PORT_ARRAY[$index]}/tcp --permanent"
    firewall-cmd --zone=public --add-port=${OPEN_PORT_ARRAY[$index]}/tcp --permanent
  done
  firewall-cmd --list-ports
  firewall-cmd --reload
fi
