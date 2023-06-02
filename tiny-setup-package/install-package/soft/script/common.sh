#!/bin/bash
#version：  1.0

#日志级别 debug-1, info-2, warn-3, error-4, always-5
LOG_LEVEL=1
#日志文件
LOG_FILE=/var/install.log
INSTALL_LOG_DIR=/var/sungrow/log/install
ssh_config_file=/etc/ssh/sshd_config
install_pkg_info=/opt/insight-install-package/pkg_info.properties
work_pkg_info=/home/sungrow/pkg_info.properties

# 获取词条 $1 词条序号 $2 语言编号
function getI18nConfig() {
  base_path=$(cd `dirname $0`; pwd)
  env_file=${base_path}/i18n_config.properties

  language=$2
  number=$1
  
  if [ "$language" = "中文" ]; then
    param="message.${number}.zh_CN"
  elif [ "$language" = "English" ]; then
    param="message.${number}.en_US"
  else
    exit 1
  fi

  value=$(sed -E '/^#.*|^ *$/d' $env_file | awk -F "${param}=" "/${param}=/{print \$2}" | awk -F = '{print $1}')

  echo $value
}

#调试日志
function log_debug(){
  content="[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 1  ] && echo $content >> $LOG_FILE && echo -e "\033[32m"  ${content}  "\033[0m"
}
#信息日志
function log_info(){
  content="[INFO] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 2  ] && echo $content >> $LOG_FILE && echo -e "\033[34m"  ${content} "\033[0m"
}
#重点关注日志
function log_note(){
  content="[NOTE] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 3  ] && echo $content >> $LOG_FILE && echo -e "\033[33m" ${content} "\033[0m"
}
#错误日志
function log_err(){
  content="[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
  [ $LOG_LEVEL -le 4  ] && echo $content >> $LOG_FILE && echo -e "\033[31m" ${content} "\033[0m"
}
#一直都会打印的日志
function log_always(){
   content="[ALWAYS] $(date '+%Y-%m-%d %H:%M:%S') $LOCAL_HOST_IP:$@"
   [ $LOG_LEVEL -le 5  ] && echo $content >> $LOG_FILE && echo -e  "\033[32m" ${content} "\033[0m"
}

function add_env(){
  if [[ $2 != "" ]];then
    profilename=/etc/profile
    sed -i "/$1=/d" $profilename
    export $1=$2
    echo export $1=$2 >> $profilename
    source $profilename
    sed -i "/^$1=/d" /home/sungrow/status/hosts-insight
    echo "$1=$2" >> /home/sungrow/status/hosts-insight
    log_debug "$1 is：$2"
  fi
}

function add_properties() {
    #文件名
    file_name=$1
    #写入的内容 如果内容存在 先删除原来的
    value=$2
    #在倒数第几行写入，默认在最后一行写入 1 倒数第二行 2 倒数第三
    number=$3
    if [[ $number == "" ]]; then
        echo "$value" >>$file_name
        return
    fi
    # 先删除原来的
    /home/sungrow/soft/script/delete_content "$value" "$file_name"
    line=$(wc -l <$file_name)
    write_line=$(($line - $number + 1))
    if [[ $write_line -le 0 ]]; then
        echo "$value" >>"$file_name"
    else
        sed -i "${write_line}i\\$value\\" "$file_name"
    fi
}

function get_local_ssh_port() {
  ssh_port=22
  ssh_ports=()
  # 可能存在
  if [[ -f $ssh_config_file ]];then
    while IFS= read -r -d $'\n'; do
      ssh_port_exsit=$(netstat -ntpl | grep -w  sshd | awk '{print $4}' | grep -wc "$REPLY")
      [[ $ssh_port_exsit -gt 0 ]] && ssh_ports=("${ssh_ports[@]}" "$REPLY")
    done < <(grep -w  Port /etc/ssh/sshd_config | awk '{print $2}')
  else 
    ssh_ports=("${ssh_ports[@]}" "$ssh_port")
  fi
  # 默认取第一个激活的SSH端口
  ssh_port=${ssh_ports[0]:-22}
  echo "${ssh_port}"
}

function set_local_ssh_port() {
  ssh_port=$(get_local_ssh_port)
  [[ -f $install_pkg_info ]] && sed -i "s/ssh_port=.*/ssh_port=${ssh_port}/g" $install_pkg_info
  [[ -f $work_pkg_info ]] && sed -i "s/ssh_port=.*/ssh_port=${ssh_port}/g" $work_pkg_info
}

# shellcheck disable=SC2112
function open_port(){
  os_name=$(cat /etc/os-release | grep "^ID=" | cut -c 4-)
  openPorts=(54321 8123 9000 9004 9009 3001 3002 102 8000 9293 9898 8800 8888 9081 9292 22 20001 20002 20003 20004 20005 20006 20007 8756)
  ssh_port=$(get_local_ssh_port)
  openPorts=("${openPorts[@]}"  "$ssh_port")
  iecPorts=(2404 2405 2406 2407 2408 2409 2410 2411 2412 2413 2414 2415)
  if [ "$os_name" = "Linx" ]; then
    #凝思系统
    #禁用端口之前先清除历史规则
    iptables -F
    #可以把INPUT默认规则设为ACCEPT
    iptables  -P  INPUT  ACCEPT
    #防火墙打开端口
    /sbin/iptables -A INPUT -p tcp --dport 1:21 -j DROP
    /sbin/iptables -A INPUT -p tcp --dport 23:20000 -j DROP
    /sbin/iptables -A INPUT -p tcp --dport 27017:27018 -j DROP
    /sbin/iptables -A INPUT -p tcp --dport 50070 -j DROP
    /sbin/iptables -A INPUT -p tcp --dport 50030 -j DROP
    # /sbin/iptables -A INPUT -p udp --dport 1:65535 -j DROP
    file_name="/etc/rc.local"
    sed -i '/iptables/d' $file_name
    add_properties "$file_name" "iptables  -P  INPUT  ACCEPT" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p tcp --dport 1:21 -j DROP" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p tcp --dport 23:20000 -j DROP" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p tcp --dport 27017:27018 -j DROP" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p tcp --dport 50070 -j DROP" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p tcp --dport 50030 -j DROP" "1"
    # add_properties "$file_name" "/sbin/iptables -A INPUT -p udp --dport 1:65535 -j DROP" "1"
    for openpt in ${openPorts[@]}; do
      echo "open port ${openpt}"
      /sbin/iptables -I INPUT -p tcp --dport ${openpt} -j ACCEPT
      add_properties "$file_name" "/sbin/iptables -I INPUT -p tcp --dport ${openpt} -j ACCEPT" "1"
    done

    for iecpt in ${iecPorts[@]}; do
      echo "open port ${iecpt}"
      /sbin/iptables -I INPUT -p tcp --dport ${iecpt} -j ACCEPT
      add_properties "$file_name" "/sbin/iptables -I INPUT -p tcp --dport ${iecpt} -j ACCEPT" "1"
    done
    /sbin/iptables -I INPUT -p tcp --dport 6123 -j ACCEPT
    /sbin/iptables -I INPUT -p tcp --dport 6124 -j ACCEPT
    /sbin/iptables -I INPUT -p tcp --dport 6125 -j ACCEPT
    /sbin/iptables -I INPUT -p tcp --dport 8082 -j ACCEPT
    /sbin/iptables -I INPUT -p udp --dport 11000 -j ACCEPT
    add_properties "$file_name" "/sbin/iptables -I INPUT -p tcp --dport 6123 -j ACCEPT" "1"
    add_properties "$file_name" "/sbin/iptables -I INPUT -p tcp --dport 6124 -j ACCEPT" "1"
    add_properties "$file_name" "/sbin/iptables -I INPUT -p tcp --dport 6125 -j ACCEPT" "1"
    add_properties "$file_name" "/sbin/iptables -I INPUT -p tcp --dport 8082 -j ACCEPT" "1"
    add_properties "$file_name" "/sbin/iptables -I INPUT -p udp --dport 11000 -j ACCEPT" "1"
    /sbin/iptables -A INPUT -p udp --dport 1:122 -j DROP
    /sbin/iptables -A INPUT -p udp --dport 124:10999 -j DROP
    /sbin/iptables -A INPUT -p udp --dport 11001:32767 -j DROP
    /sbin/iptables -A INPUT -p udp --dport 65500:65535 -j DROP
    add_properties "$file_name" "/sbin/iptables -A INPUT -p udp --dport 1:122 -j DROP" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p udp --dport 124:10999 -j DROP" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p udp --dport 11001:32767 -j DROP" "1"
    add_properties "$file_name" "/sbin/iptables -A INPUT -p udp --dport 65500:65535 -j DROP" "1"
    # iptables -I INPUT -s 127.0.0.1 -p tcp -j ACCEPT
    # iptables -I INPUT -s ${LOCAL_HOST_IP} -p tcp -j ACCEPT
    # iptables  -I  INPUT  -p icmp  -j ACCEPT
    /sbin/iptables -I INPUT -p udp --dport 123 -j ACCEPT
    add_properties "$file_name" "/sbin/iptables -I INPUT -p udp --dport 123 -j ACCEPT" "1"
  else
    #防火墙打开端口
    systemctl start firewalld.service
    ## 2 开放端口之前，先关闭一切端口
    echo ""
    a=$(firewall-cmd --list-ports)
    arr=($a)
    for s in ${arr[@]}; do
      if [[ $s =~ "tcp" ]]; then
        if [ $s == "22/tcp" ]; then
          continue
        fi
        port=${s%\/*}
        echo "关闭端口 $port"
        firewall-cmd --zone=public --remove-port=${port}/tcp --permanent
      else
        continue
      fi
    done
    for openpt in ${openPorts[@]}; do
      echo "open port ${openpt}"
      firewall-cmd --zone=public --add-port=$openpt/tcp --permanent
    done
    
    for iecpt in ${iecPorts[@]};do
      echo "open port ${iecpt}"
      firewall-cmd --zone=public --add-port=$iecpt/tcp --permanent
    done
    firewall-cmd --zone=public --add-port=123/udp --permanent
    #关闭80端口
    firewall-cmd --zone=public --remove-port=80/tcp --permanent
    
    firewall-cmd --reload
    firewall-cmd --list-ports
    echo "tcp ports successful"
  fi
}

function install_service(){
  if [ ! -d "/usr/lib/systemd/system" ];then 
    mkdir -p /usr/lib/systemd/system
  fi
  service_name=$1
  #判断服务是否已存在
  isExist=$(systemctl list-units --type=service|grep "$service_name"|wc -l)
  if [ "$isExist" == "1" ]; then
    status=$(systemctl status "$service_name"|grep "Active: active"|awk '{print $3}')
    if [ "$status" == "(running)" ]; then
      #停止服务
      systemctl stop "$service_name"
    fi
    #删除服务
    rm -rf /usr/lib/systemd/system/"$service_name"
    systemctl daemon-reload
    #清理缓存
    echo 1 > /proc/sys/vm/drop_caches
    echo 2 > /proc/sys/vm/drop_caches
    echo 3 > /proc/sys/vm/drop_caches
  fi
  cp -Rp -f $2 /usr/lib/systemd/system/"$service_name"
  chmod -R 644 /usr/lib/systemd/system/"$service_name"
  systemctl daemon-reload
  systemctl enable "$service_name"
  systemctl restart "$service_name"
}

function isIp(){
    IP=$1
    count=`echo "$IP" |  egrep '((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' | wc -l`
	if [ $count -gt 0 ]
	then
	    return 0
	else
	    return 1
	fi
}

function set_progress(){
    sed -i '/^PROGRESS=/c'PROGRESS=$1'' /home/sungrow/status/hosts-insight
    sed -i '/^CURRENT_TASK=/c'CURRENT_TASK=$2'' /home/sungrow/status/hosts-insight
}

function set_docker_boot_start(){
    sudo cat << EOF > /etc/systemd/system/docker.service
[Unit]
 
Description=Docker Application Container Engine
 
Documentation=https://docs.docker.com
 
After=network-online.target firewalld.service
 
Wants=network-online.target
 
[Service]
 
Type=notify
 
ExecStart=/usr/bin/dockerd
 
ExecReload=/bin/kill -s HUP $MAINPID
 
LimitNOFILE=infinity
 
LimitNPROC=infinity
 
LimitCORE=infinity
 
TimeoutStartSec=0
 
# set delegate yes so that systemd does not reset the cgroups of docker containers
 
Delegate=yes
 
# kill only the docker process, not all processes in the cgroup
 
KillMode=process
 
# restart the docker process if it exits prematurely
 
Restart=on-failure
 
StartLimitBurst=3

StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

# docker重启不影响容器状态

    #赋予权限
    sudo chmod +x /etc/systemd/system/docker.service 
    #重载unit配置文件
    sudo systemctl daemon-reload
    #启动Docker
    sudo systemctl start docker
    #设置开机自启
    sudo systemctl enable docker.service  
}




# 配置ssh连接属性
config_ssh(){
	echo "***加入ssh最大连接数"
	sed -i '/#MaxStartups 10:30:100/d' /etc/ssh/sshd_config
	sed -i '/#MaxSessions 0/d' /etc/ssh/sshd_config
	sed -i '/#LoginGraceTime 120/d' /etc/ssh/sshd_config

	if [ `cat /etc/ssh/sshd_config | grep '#MaxStartups' | wc -l` -eq 1 ];then
	    sed -i '60aMaxStartups 7000:30:7500' /etc/ssh/sshd_config
	fi
	if [ `cat /etc/ssh/sshd_config | grep 'MaxSessions' | wc -l` -eq 1 ];then
	    sed -i '60aMaxSessions 5000' /etc/ssh/sshd_config
	fi
	if [ `cat /etc/ssh/sshd_config | grep 'LoginGraceTime' | wc -l` -eq 1 ];then
	    sed -i '60aLoginGraceTime 0' /etc/ssh/sshd_config
	fi
	if [ `cat /etc/ssh/sshd_config | grep 'MaxStartups' | wc -l` -eq 0 ];then
	    sed -i '60aMaxStartups 7000:30:7500' /etc/ssh/sshd_config
	fi
	systemctl restart sshd
}

clean_firewall() {
  clean_fw_log=$INSTALL_LOG_DIR/clean_firewall.log
  [[ -d $INSTALL_LOG_DIR ]] || mkdir -p $INSTALL_LOG_DIR
  [[ -f $clean_fw_log ]] || touch $clean_fw_log
  os_name=$(cat /etc/os-release | grep "^ID=" | cut -c 4-)
  if [[ "$os_name" = "Linx" ]]; then
    iptables -F
    iptables -X
    iptables -t nat -F
    iptables -t nat -X
  else
    allPorts=$(firewall-cmd --list-ports)
    for pt in ${allPorts[@]}; do
      firewall-cmd --zone=public --remove-port=$pt --permanent  >> $clean_fw_log 2>&1
    done
    firewall-cmd --reload  >> $clean_fw_log 2>&1
  fi
}

function messagebox() {
    # messagebox <title> [<content> [<height> [<width>]]]
    title=$1
    msgbox=$2
    height=10
    width=60
    ok_button=$(getI18nConfig 24 "${install_language:-a}")
    if [ -n "$3" ]; then
        height=$3
    fi
    if [ -n "$4" ]; then
        width=$4
    fi
    if [ -n "$5" ]; then
        ok_button=$5
    fi
    # 消息框
    # whiptail --title "<message box title>" --msgbox "<text to show>" <height> <width>
    # whiptail --title "Test Message Box" --msgbox "Create a message box with whiptail. Choose Ok to continue." 10 60
    whiptail --title "$title" --ok-button "$ok_button" --msgbox "$msgbox"  $height $width
}

function inputbox() {
    # inputbox <title> [<content> [<height> [<width> [<default>]]]]
    title=$1
    inputbox=$2
    height=12
    width=60
    default=""
    ok_button=$(getI18nConfig 24 "${install_language:-a}")
    cancel_button=$(getI18nConfig 25 "${install_language:-a}")
    if [ -n "$3" ]; then
        height=$3
    fi
    if [ -n "$4" ]; then
        width=$4
    fi
    if [ -n "$5" ]; then
        default=$5
    fi
    if [ -n "$6" ]; then
        ok_button=$6
    fi
    if [ -n "$7" ]; then
        cancel_button=$7
    fi
    value=$(whiptail --title "$title" --ok-button "$ok_button" --cancel-button "$cancel_button" --inputbox "$inputbox" "$height" "$width" "$default" 3>&1 1>&2 2>&3)
    exitstatus=$?
    # echo "exitstatus:$exitstatus"
    if [ $exitstatus = 0 ]; then
        echo "$value"
    fi
    return $((10#${exitstatus}))
}

function promptbox() {
    # promptbox <title> [<content> [<height> [<width> [<yes_button> [<no_button>]]]]]
    title=$1
    yesno=$2
    height=10
    width=60
    yes_button=$(getI18nConfig 24 "${install_language:-a}")
    no_button=$(getI18nConfig 25 "${install_language:-a}")
    if [ -n "$3" ]; then
        height=$3
    fi
    if [ -n "$4" ]; then
        width=$4
    fi
    if [ -n "$5" ]; then
        yes_button=$5
    fi
    if [ -n "$6" ]; then
        no_button=$6
    fi

    # 提示框
    # whiptail --title "<dialog box title>" --yesno "<text to show>" <height> <width>
    #!/bin/bash if (whiptail --title "Test Yes/No Box" --yes-button "Skittles" --no-button "M&M's" --yesno "Which do you like better?" 10 60) then echo "You chose Skittles Exit status was $?." else echo "You chose M&M's. Exit status was $?." fi
    whiptail --title "$title" --yes-button "$yes_button" --no-button "$no_button" --yesno "$yesno" $height $width
    ret=$?
    return $ret
}

function gen_ssh_rsa() {
  [[ ! -d ~/.ssh/ ]] &&  mkdir ~/.ssh
  if [[ ! -f "/root/.ssh/id_rsa" ]];then
  ssh-keygen -q -N "" -t rsa -b 2048 -f ~/.ssh/id_rsa 
fi
}

function check_ssh_pass() {
  sshpass > /dev/null 2>&1
  check_ssh_pass_result=$?
  return $((10#${check_ssh_pass_result}))
}

function install_ssh_pass() {
  if [[ -f /opt/insight-install-package/resource/pkg/sshpass-1.06-2.el7.x86_64.rpm ]];then 
    rpm -i /opt/insight-install-package/resource/pkg/sshpass-1.06-2.el7.x86_64.rpm > /dev/null 2>&1
  elif [[  -f /home/sungrow/resource/pkg/sshpass-1.06-2.el7.x86_64.rpm ]];then
    rpm -i /opt/insight-install-package/resource/pkg/sshpass-1.06-2.el7.x86_64.rpm > /dev/null 2>&1
  else
    log_err "sshpass miss!"
    exit 1
  fi
}

# -- 使用SSHPASS免密通信
function connect_server_by_ssh() {
  [[ -f /root/.ssh/id_rsa ]] || gen_ssh_rsa
  [[ -n $1 ]] || return 1
  server_ip=$1
  ssh_port=$(get_local_ssh_port)
  ssh_user=root
  ssh_pawd=12345678
  if [[ -n "$2" ]];then
    ssh_port=$2
  fi
  if [[ -n "$3" ]];then
    ssh_user=$3
  fi
  check_ssh_pass
  sshpass_exsit=$?
  [[ $sshpass_exsit -eq 0 ]] || install_ssh_pass
  if [[ -f /opt/insight-install-package/status/SERVER_PASSWORD ]];then
    sshpass -p $ssh_pawd ssh-copy-id -p "$ssh_port" -o "StrictHostKeyChecking no" "$ssh_user"@"$server_ip" > /dev/null 2>&1
  else
    sshpass -f /opt/insight-install-package/status/SERVER_PASSWORD ssh-copy-id -p "$ssh_port" -o "StrictHostKeyChecking no" "$ssh_user"@"$server_ip" > /dev/null 2>&1
  fi
  ssh_result=$?
  return $((10#${ssh_result}))
}

function check_kingbase_license() {
  target_node_ip=127.0.0.1
  [[ -n $1 ]] && target_node_ip=$1
  connect_server_by_ssh "$target_node_ip"
  connect_result=$?
  [[ $connect_result -eq 0 ]] || return 1
  ssh -p $ssh_port  root@"$target_node_ip" "test -f /opt/kingbase/license/license.dat"  > /dev/null 2>&1
  check_result=$?
  return $((10#${check_result}))
}

function add_kingbase_license() {
  target_node_ip=("127.0.0.1")
  ssh_port=$(get_local_ssh_port)
  license_index=0
  license_conf=""
  [[ -n $1 ]] && target_node_ip=( "$1")
  [[ -n $2 ]] && target_node_ip=( "$1" "$2")
  for node in ${target_node_ip[@]};
  do 
    license_name=license-"$license_index".dat
    scp -P $ssh_port root@$node:/opt/kingbase/license/license.dat /opt/insight-install-package/component/kingbase/conf/$license_name  > /dev/null 2>&1
    ((license_index++))
    license_conf=$license_conf" "$license_name
  done
  sed -i "s/license_file=.*/license_file=(${license_conf})/g" /opt/insight-install-package/component/kingbase/conf/install.conf
}


function mask_to_cidr () {
    # Assumes there's no "255." after a non-255 byte in the mask
    local x=${1##*255.}
    set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
    x=${1%%$3*}
    echo $(( $2 + (${#x}/4) ))
}

function cidr_to_mask () {
    # Number of args to shift, 255..255, first non-255 byte, zeroes
    set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
    [ $1 -gt 1 ] && shift $1 || shift
    echo ${1-0}.${2-0}.${3-0}.${4-0}
}