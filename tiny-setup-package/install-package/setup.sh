#!/bin/bash

#Author：   xtpeach
#Date：     2023/06/30
#version：  1.0
# bash脚本这一层不要做得复杂，越简单约好！
# 尽量让每个bash脚本都能独立运行，减少相互依赖，方便运维

# --------------------------------------------------------------------
{
  # install package dir
  # 上传到 /opt/ 目录下面，然后安装的时候拷贝到 /home/ 下面
  # -- *** [/opt/tiny-setup-package/install-package] *** --
  INSTALL_PACKAGE_DIR=/opt/tiny-setup-package/install-package

  # install dir
  # -- *** [/home/install-package] *** --
  INSTALL_DIR=/home/tiny-setup-package

  # 先删除
  rm -rf $INSTALL_DIR

  # 临时文件记录进度数字
  TEMP_FILE="/tmp/rsync_progress"
  # 删除之前的进度文件
  rm -rf $TEMP_FILE
  # 创建新的临时文件
  touch $TEMP_FILE
  # 将 INSTALL_PACKAGE_DIR 拷贝至 /home/tiny-setup-package
  rsync -a --info=progress2 --delete $INSTALL_PACKAGE_DIR $INSTALL_DIR >>$TEMP_FILE &

  RSYNC_PID=$!

  # 通过进程ID来判断rsync是否结束
  while kill -0 $RSYNC_PID 2>/dev/null; do
    if [[ -f "$TEMP_FILE" ]]; then
      # 从临时文件中获取包含进度信息的那一行
      PROGRESS_LINE=$(grep -oP '\d+%' "$TEMP_FILE" | tail -n 1)

      if [[ -n "$PROGRESS_LINE" ]]; then
        # 提取进度百分比
        PROGRESS=$(echo "$PROGRESS_LINE" | grep -oP '\d+')
        echo "$PROGRESS"
      fi
    fi
    sleep 0.1
  done

  # 安装完成，删除临时文件
  rm -rf "$TEMP_FILE"

} | whiptail --title "复制文件" --gauge "正在复制,请稍等 ..." 6 60 0
# --------------------------------------------------------------------


# source
source ./soft/script/common.sh

# 1. 修改执行目录权限
# 安装目录（tiny-setup-package）上传至 /opt 下，并执行: bash /opt/tiny-setup-package/install-package/setup.sh
# 修改成相对路径，不一定要上传到 /opt 下
[[ -d $INSTALL_DIR ]] && chmod -R 755 $INSTALL_DIR >/dev/null 2>&1

# 重新创建日志文件
DATE_STR=$(date "+%Y-%m-%d %H:%M:%S")
echo "---> setup.sh [$DATE_STR] <---" >$SETUP_FILE

# 2. 执行安装逻辑
# 休眠时间
sleep_time=2s
# 进度条-日志文件一共有多少行
log_row_num_total=1000
# 进度条-日志文件当前有多少行
log_row_num_current=0

# 刷新 testProgressBar.log 放入 “start” 字符串到首行
log_info "start setup..."
{
  # 需要执行的逻辑
  {
    # 执行 [安装] 步骤
    cd $INSTALL_DIR/soft/script
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
} | whiptail --title "安装" --gauge "正在安装,请稍等 ... \n详细日志:$SETUP_FILE" 8 60 0
# 这边 --gauge 后面可以把安装信息拿出来展示一下

# 提示安装完毕
whiptail --title "安装" --msgbox "安装完毕,按下 enter 键继续 . \n详细日志:$SETUP_FILE" 10 60
log_info "setup done."
