#!/bin/bash

#Author：   xtpeach
#Date：     2023/06/30
#version：  1.0

# 1. 修改执行目录权限
# 安装目录（tiny-setup-package）上传至 /opt 下，并执行: bash /opt/tiny-setup-package/setup.sh
[ -d /opt/tiny-setup-package/ ] && chmod -R 755 /opt/tiny-setup-package/ > /dev/null 2>&1


# 2.展示选择框
language="中文"
language_menu=("中文" "English")
#echo "$(date '+%Y-%m-%d %H:%M:%S'): language menu："${language_menu[*]}
op_type=$(whiptail --title "语言/Language" --ok-button "确认/OK"  --cancel-button "退出/Quit" --menu "\n请选择语言/Please select language" 12 60 2 "1" ${language_menu[0]} "2" ${language_menu[1]}  3>&1 1>&2 2>&3)
exitstatus=$?  
if [[ $exitstatus -ne 0 ]]; then  
  echo "[install failure] - language menu - choose out"
  exit
fi  
install_language=$language
if [[ $op_type -eq 1 ]];then
  install_language="中文"
else
  install_language="English"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S'): install language："$install_language

# 3.设置环境变量（获取用户输入信息并设置）
# 获取当前脚本所在路径
base_path=$(cd `dirname $0`; pwd)
#echo "$(date '+%Y-%m-%d %H:%M:%S'): base path："$base_path
source $base_path/soft/script/common.sh
#echo "$(date '+%Y-%m-%d %H:%M:%S'): source "$base_path/soft/script/common.sh

# 所有安装主机信息放在生成的 hosts-xtpeach 文件中
rm -f "${base_path}"/status/hosts-xtpeach
touch "${base_path}"/status/hosts-xtpeach

# [ALL_HOSTS] 所有安装主机
ALL_HOSTS=''
db_type=""
db_name=""


# 选择安装模式
install_menu=("$(getI18nConfig 19 ${install_language})" "$(getI18nConfig 20 ${install_language})" "$(getI18nConfig 21 ${install_language})" "$(getI18nConfig 88 ${install_language})" )
install_type=$(whiptail --title "$(getI18nConfig 1 ${install_language})" --cancel-button "$(getI18nConfig 25 ${install_language})" --ok-button "$(getI18nConfig 24 ${install_language})" --cancel-button "$(getI18nConfig 25 ${install_language})" --ok-button "$(getI18nConfig 24 ${install_language})"  --menu "\n$(getI18nConfig 22 ${install_language})" 12 60 4 "1" "${install_menu[0]}" "2" "${install_menu[1]}" "3" "${install_menu[2]}" "4" "${install_menu[3]}"  3>&1 1>&2 2>&3)
exitstatus=$?  
if [[ $exitstatus -ne 0 ]]; then  
  echo "[install failure] - install menu - choose out"
  exit
fi  

# 安装模式1：内网主备
if [[ $install_type -eq 1 ]];then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): install type: ${install_menu[0]}"
  echo "ACTIVE=two" >> "${base_path}"/status/hosts-xtpeach
  echo "OUT=1" >> "${base_path}"/status/hosts-xtpeach
  while (true);do
    ha_install_type=1
    ha_install_menu=("$(getI18nConfig 68 ${install_language})" "$(getI18nConfig 69 ${install_language})($(getI18nConfig 73 ${install_language}))")
    ha_install_type=$(whiptail --title "$(getI18nConfig 1 ${install_language})" --cancel-button "$(getI18nConfig 25 ${install_language})" --ok-button "$(getI18nConfig 24 ${install_language})"   --menu "\n$(getI18nConfig 67 ${install_language})" 12 100 3 "1" "${ha_install_menu[0]}" "2" "${ha_install_menu[1]}" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [[ $exitstatus -ne 0 ]];then
      echo "[install failure] - install menu - choose out"
      exit $exitstatus
    fi
    
    # 还原 ha_install_type 数组下标
    ha_install_array_index=$[ha_install_type-1]

    # 是否主备并行安装
    echo "$(date '+%Y-%m-%d %H:%M:%S'): ha install type: ${ha_install_menu[$ha_install_array_index]}"
    
    # ---> [执行] 安装模式1：内网主备
    should_continue=1
    [[ 1 -eq $should_continue ]] && break
  done
fi

# 安装模式2：内网单机
if [[ $install_type -eq 2 ]];then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): install type: ${install_menu[1]}"
  echo "ACTIVE=single" >> "${base_path}"/status/hosts-xtpeach
  echo "OUT=1" >> "${base_path}"/status/hosts-xtpeach
  # ---> [执行] 安装模式2：内网单机
  
fi

# 安装模式3：外网单机
if [[ $install_type -eq 3 ]];then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): install type: ${install_menu[2]}"
  echo "ACTIVE=single" >> "${base_path}"/status/hosts-xtpeach
  echo "OUT=2" >> "${base_path}"/status/hosts-xtpeach
  # ---> [执行] 安装模式3：外网单机
  
fi

# 安装模式4：集群模式
if [[ $install_type -eq 4 ]];then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): install type: ${install_menu[3]}"
  # ---> [执行] 安装模式4：集群模式
  
  [[ $? -ne 0 ]] && exit 1
fi

# 还原 install_type 数组下标
install_array_index=$[$install_type-1]
#echo "$(date '+%Y-%m-%d %H:%M:%S'): instal type install array index: "$install_array_index


# 数据库选择
#whiptail --title "$(getI18nConfig 1 ${install_language})" --yes-button "KingBase" --no-button "MySQL"  --yesno "$(getI18nConfig 5 ${install_language}):\n\n    KingBase -> $(getI18nConfig 6 ${install_language})     MySQL -> $(getI18nConfig 7 ${install_language})" 12 80
#db_type=$?
#echo $db_type

# 数据库选择
database_menu=("Postgresql -> $(getI18nConfig 6 ${install_language})" "MySQL -> $(getI18nConfig 7 ${install_language})" )
database_type=$(whiptail --title "$(getI18nConfig 1 ${install_language})" --cancel-button "$(getI18nConfig 25 ${install_language})" --ok-button "$(getI18nConfig 24 ${install_language})" --cancel-button "$(getI18nConfig 25 ${install_language})" --ok-button "$(getI18nConfig 24 ${install_language})"  --menu "\n$(getI18nConfig 5 ${install_language})" 12 60 4 "1" "${database_menu[0]}" "2" "${database_menu[1]}"  3>&1 1>&2 2>&3)
exitstatus=$?
if [[ $exitstatus -ne 0 ]];then
  echo "[install failure] - database menu - choose out"
  exit $exitstatus
fi
#echo "$(date '+%Y-%m-%d %H:%M:%S'): database type: "$database_type

# 还原 database_type 数组下标
database_array_type=$[$database_type-1]
#echo "$(date '+%Y-%m-%d %H:%M:%S'): instal type database type array index: "$database_array_type
echo "$(date '+%Y-%m-%d %H:%M:%S'): database type: ${database_menu[$database_array_type]}"


# 确认安装信息
whiptail --title "$(getI18nConfig 1 ${install_language})" --yes-button "$(getI18nConfig 24 ${install_language})" --no-button "$(getI18nConfig 25 ${install_language})" --yesno "$(getI18nConfig 26 ${install_language}):\n\n$(getI18nConfig 27 ${install_language}):${install_menu[$install_array_index]}\n$(getI18nConfig 28 ${install_language}):${database_menu[$database_array_type]}\n${install_info}\n\n$(getI18nConfig 29 ${install_language})" 20 60
should_exit=$?

if [[ $should_exit -ne 0 ]];then
  echo "[install failure] - confirm - choose out"
  exit $should_exit
fi

echo "$(date '+%Y-%m-%d %H:%M:%S'): start install ..."


# 安装信息
install_info=""
# 创建安装信息
build_install_info() {
  msg="$(getI18nConfig 74 ${install_language}): \n\n"
  mode_info="$(getI18nConfig 27 ${install_language}): "
  if [[ $install_type -eq 1 ]];then
    mode_info=${mode_info}"$(getI18nConfig 19 ${install_language})"
  elif [[ $install_type -eq 2 ]];then
    mode_info=${mode_info}"$(getI18nConfig 20 ${install_language})"
  elif [[ $install_type -eq 4 ]];then
    mode_info=${mode_info}"$(getI18nConfig 88 ${install_language})"
  else
    mode_info=${mode_info}"$(getI18nConfig 21 ${install_language})"
  fi
  msg=${msg}${mode_info}"\n"
  # 添加安装信息
  if [[ $ha_install_type -eq 1 ]]; then
    msg=${msg}"$(getI18nConfig 77 ${install_language}): ""$(getI18nConfig 68 ${install_language})\n"
  else
    msg=${msg}"$(getI18nConfig 77 ${install_language}): ""$(getI18nConfig 69 ${install_language})\n"
  fi
  # 添加数据库信息
  db_info="$(getI18nConfig 28 ${install_language}): "${db_name}
  msg=${msg}${db_info}"\n"
  # 主机信息
  msg=${msg}"$(getI18nConfig 32 ${install_language}): $master_ip\n"
  # 备机信息
  [[ ""x = "$slave_ip"x ]] || msg=${msg}"$(getI18nConfig 48 ${install_language}): $slave_ip\n"
  # vip信息
  vip_tmp=$(echo $master_ip | awk -v FS="." '{print $1"."$2"."$3"."}')"$scada_vip_postfix"
  [[ $install_type -eq 1 ]] && msg=${msg}"$(getI18nConfig 23 ${install_language}): $vip_tmp\n"
  # 确认安装信息
  ensure_info="$(getI18nConfig 75 ${install_language})\n"
  [[ $ha_install_type -eq 2 && "$MASTER"x = "$local_host_ip"x ]] && ensure_info="$(getI18nConfig 76 ${install_language})\n"
  install_msg=${msg}"\n"${ensure_info}
}

# 4.开始安装步骤
