#!/bin/bash

#Author：   xtpeach
#Date：     2023/06/30
#version：  1.0
# bash脚本这一层不要做得复杂，越简单约好！
# 尽量让每个bash脚本都能独立运行，减少相互依赖，方便运维

# source
source ./soft/script/common.sh

# 1. 修改执行目录权限
# 安装目录（tiny-setup-package）上传至 /opt 下，并执行: bash /opt/tiny-setup-package/install-package/setup.sh
# 修改成相对路径，不一定要上传到 /opt 下
[[ -d $INSTALL_PACKAGE_DIR ]] && chmod -R 755 $INSTALL_PACKAGE_DIR >/dev/null 2>&1

# 重新创建日志文件
DATE_STR=$(date "+%Y-%m-%d %H:%M:%S")
echo "---> setup.sh [$DATE_STR] <---" > $SETUP_FILE

# 2. 执行安装逻辑
# 休眠时间
sleep_time=2s
# 进度条-日志文件一共有多少行
log_row_num_total=2000
# 进度条-日志文件当前有多少行
log_row_num_current=0

# 刷新 testProgressBar.log 放入 “start” 字符串到首行
log_info "start setup..."
{
  # 需要执行的逻辑
  {
    # 执行 [安装] 步骤
    cd $INSTALL_PACKAGE_DIR/soft/script
    bash install.sh

    # 将安装日志输入到日志文件中
  } >>$SETUP_FILE 2>&1 &

  # 进度条显示
  bar_i=0
  while true; do
    sleep $sleep_time
    # 安装执行完毕之后打印 #@success@# 这个符号比较特殊，一般不会有重复
    # 判断执行日志最后一行是否打印的成功标志“#@success@#”
    lastLine=$(sed -n '$p' $SETUP_FILE)
    if [[ "$lastLine"x == "#@success@#"x ]]; then
      # 若已成功快速达到100
      sleep_time=0.2
      # 如果已经到了99则推进到100并结束进度条
      if [[ $bar_i -eq 99 ]]; then
        bar_i=100
        echo $bar_i
        sleep 1s
        break
      else
        ((bar_i++))
      fi
    fi

    # 把进度卡在 99% 之前
    if [[ $bar_i -lt 99 && "$lastLine"x != "#@success@#"x ]]; then
      log_row_num_current=$(sed -n '$=' $SETUP_FILE)
      i_percent=$((log_row_num_current * 100 / log_row_num_total))
      bar_i=$i_percent
    fi

    # 打印进度在 99% 之前
    echo $bar_i
  done

  # 展示进度条
} | whiptail --gauge "Please wait while installing ..." 6 60 0

# 提示安装完毕
whiptail --title "Setup completed" --msgbox " Choose Ok to continue." 10 60
log_info "setup done."
