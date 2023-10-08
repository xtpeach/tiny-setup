#!/bin/bash

#Author：   xtpeach
#Date：     2023/06/30
#version：  1.0

# source
source ./soft/script/common.sh

# 1. 修改执行目录权限
# 安装目录（tiny-setup-package）上传至 /opt 下，并执行: bash /opt/tiny-setup-package/setup.sh
[[ -d $INSTALL_PACKAGE_DIR ]] && chmod -R 755 $INSTALL_PACKAGE_DIR >/dev/null 2>&1

# 2. 执行安装逻辑
# 进度条
sleep_time=5s
# 刷新 testProgressBar.log 放入 “start” 字符串到首行
log_info "start setup"
{
  # 需要执行的逻辑
  {
    # 执行 [安装] 步骤
    cd $INSTALL_PACKAGE_DIR/soft/script
    bash install.sh

    # 将安装日志输入到日志文件中
  } >>$LOG_FILE 2>&1 &

  # 进度条显示
  bar_i=0
  while [[ 1 == 1 ]]; do
    sleep $sleep_time
    # 判断执行日志最后一行是否打印的成功标志“#@success@#”
    lastLine=$(sed -n '$p' $LOG_FILE)
    if [[ "$lastLine"x == "#@success@#"x ]]; then
      # 若已成功快速达到100
      sleep_time=0.5
      # 若已成功直接进度到达100
      bar_i=100
      break
    fi
    echo $bar_i
    if [[ $bar_i -lt 99 ]]; then
      ((bar_i++))
    fi
  done

  # 展示进度条
} | whiptail --gauge "Please wait while installing ..." 6 60 0

# 提示安装完毕
whiptail --title "Setup completed" --msgbox " Choose Ok to continue." 10 60