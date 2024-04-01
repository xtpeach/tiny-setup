#!/bin/bash
# ssh服务配置文件位置
ssh_config_file=/etc/ssh/sshd_config

# 获取ssh服务端口方法
function get_local_ssh_port() {
  ssh_port=22
  ssh_ports=()
  # 可能存在
  if [[ -f $ssh_config_file ]]; then
    while IFS= read -r -d $'\n'; do
      ssh_port_exsit=$(netstat -ntpl | grep -w sshd | awk '{print $4}' | grep -wc "$REPLY")
      [[ $ssh_port_exsit -gt 0 ]] && ssh_ports=("${ssh_ports[@]}" "$REPLY")
    done < <(grep -w Port /etc/ssh/sshd_config | awk '{print $2}')
  else
    ssh_ports=("${ssh_ports[@]}" "$ssh_port")
  fi
  # 默认取第一个激活的SSH端口
  ssh_port=${ssh_ports[0]:-22}
  echo "${ssh_port}"
}

# 调用方法获取ssh端口
ssh_port=$(get_local_ssh_port)

# 显示ssh端口
echo $ssh_port
