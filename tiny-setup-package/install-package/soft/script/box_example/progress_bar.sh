#!/bin/bash
# 命令行对话框弹窗演示 - 进度条
# 此示例展示在命令行展示“进度条”弹窗并执行脚本逻辑

# 进度条弹窗会展示一个进度条，从 0% ~ 100%，0 ~ 100 的数字变化中间需要一个间隔时间
# 该间隔时间使用 sleep 实现
# sleep 命令后面跟一个整数或小数，默认单位是秒
# sleep 后面的整数可以带单位：s(秒)、m(分钟)、h(小时)、(d)天

# 此处设置暂停时间变量为1秒
sleep_time=1s

# 日志文件路径
progress_bar_log_file=/home/testProgressBar.log

# 刷新 testProgressBar.log 放入 “start” 字符串到首行
echo "start" >$progress_bar_log_file

# {}：用于创建一个子shell，子shell中的命令在一个单独的进程中执行，不会影响主shell的环境
# |：用于将前一个命令的输出作为后一个命令的输入，实现命令之间的管道传递
# 在示例中，{}中的内容通过管道传递给whiptail --gauge命令，用于更新进度条的显示，通过echo输出数字来控制进度条的展示是一种常见的做法
{
  # 需要执行的逻辑，用 {} 包裹，表示开启一个子 shell 不影响主shell环境
  # 此处可以执行一些并且的任务，进度条和这些任务并行执行，通过读取日志文件，判断当前进度
  {
    # 中间的执行步骤
    sleep $sleep_time
    echo "1"
    sleep $sleep_time
    echo "2"
    sleep $sleep_time
    echo "3"
    sleep $sleep_time

    # 最后打印 success 表示子 shell 里面并行的任务已经执行完毕
    echo "success"

    # 子 shell 执行并将 echo 输出记录在文件中
  } >>$progress_bar_log_file 2>&1 &

  # 进度条显示 0 ~ 100
  # 此处使用的是 for 循环，通过间隔时间来展示进度，该进度并非真实子任务执行的进度
  # 可以使用 while 循环，读取日志文件日志打印关键点，来展示较为真实的进度
  for ((i = 0; i <= 100; i += 1)); do

    # 进度条需要间隔一段时间再更新进度打印，不然会让人反应不过来，显得突兀
    sleep $sleep_time

    # 判断执行日志最后一行是否打印的成功标志“success”
    lastLine=$(sed -n '$p' $progress_bar_log_file)
    if [[ "$lastLine"x = "success"x ]]; then

      # 若已从日志文件中读取到执行完毕，可以直接将 echo 100
      # 此处为调整间隔时间为 0.5 秒，让 for 循环快速跑完
      sleep_time=0.1s
    fi
    echo $i
  done

  # {} 子 shell 的内容需要跑完之后，进度条弹窗才会关闭
} | whiptail --gauge "please wait ..." 6 60 0
# 6 表示进度条弹窗的高度，即显示的行数
# 60 表示进度条弹窗的宽度，即显示的列数
# 0 表示进度条的初始值，通常是0，表示进度条的初始位置