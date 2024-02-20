#!/bin/bash
# 这里的进度不使用弹窗，使用命令打印展示进度条
# 效果大致如下：
# > install: [start]
# [####################################################################################################][100%][-]
#  > install: [ok]

# 此处设置暂停时间变量为1秒
sleep_time=1s

# 设置日志文件变量
progress_log_file=/home/testProgress.log

# 打印 - 开始
echo " ---> install: [start]"

# 初始化日志文件
echo "" > $progress_log_file

# 此处为一个示例，表示从 1 ~ 100 打印输出到日志文件中
{
  for i in {1..100}; do
    # 将 1 ~ 100 输入到日志文件中
    echo $i >> $progress_log_file

    # 暂停一段时间再进行输入，防止过快影响展示
    sleep $sleep_time
  done

  # 这里是将子任务执行结束标志输入进日志文件
  echo "install:success" >> $progress_log_file

  # 子 shell 并行执行
} &

# 子任务到执行结束的时候一共有多少行日志
# 比如，日志到执行完毕一共有2000行，这边写2000
let log_row_num_total=1

# 用于获取日志中结束标记位的变量
install_success_flag=""

# 实时行数，不停在获取当前行数
log_row_num_current=0

# 当前进度数值 0 ~ 99 最终不会到 100，得在日志中找到结束标记才会进到100
i=0

# 百分比进度数值
i_percent=0

# 用于在命令行打印进度条内容的变量
bar=''

# 用于循环展示旋转符号的标识变量
index=0

# 旋转提示打印的4个符号
arr=("|" "/" "-" "\\")

# 使用 while 循环，读取日志文件
while [ $i -le 99 ]; do

  # 循环中反复读取日志文件，找到结束标志
  install_success_flag=$(cat $progress_log_file | grep "install:success")

  # 读取日志文件当前一共有多少行
  log_row_num_current=$(sed -n '$=' $progress_log_file)

  # 计算当前的进度数值
  # 当前的行数 / 总共的行数
  let i_percent=log_row_num_current/log_row_num_total

  # 当前 i(进度数值) 小于等于 计算出来的当前进度数值（当前日志打印行号 / 总共的行数）
  if [ $i -le $i_percent ]; then
    # 当 i(进度数值) 小于 99 的情况下让进度条继续向前
    if [ $i -lt 99 ]; then
      let i++
      bar+='#'
    fi
  fi

  # 如果已经在日志文件中找到了执行结束的标记信息，则将命令打印的进度条直接推进到 100%
  if [ "$install_success_flag"x != "x" ]; then

    # 前面进度只会推进到 99%，到检测到日志中的结束标志时推进打印到 100%
    i=100

    # 推进填满打印的进度条
    bar='####################################################################################################'
  fi

  # 使用模4将index控制在 0 ~ 3
  let index=index%4

  # 旋转提示为4个符号轮询打印
  let index++

  # 循环打印旋转提示
  printf "[%-100s][%d%%][\e[43;46;1m%c\e[0m]\r" "$bar" "$i" "${arr[$index]}"

  # 暂停 0.3 秒
  sleep 0.3s
done

# 打印换行
printf "\n"

# 打印 - 结束
echo " ---> install: [ok]"
