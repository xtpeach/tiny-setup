#!/bin/bash
# 监控间隔时间
sleep_seconds=5

# 环境变量
source /etc/profile

# 日志文件路径
log_dir=/data/logs/monitor
# 日志文件
log_file=$log_dir/do_check_log.log
# 创建日志文件路径
mkdir -p $log_dir
# 创建日志文件
touch $log_file

# 检查
do_check_log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') check log... " >>$log_file

  # /data/logs/monitor/do_check_log.log
  check_and_clean_log $log_dir/do_check_log.log

  # /data/logs/monitor/do_check_clickhouse.log
  check_and_clean_log $log_dir/do_check_clickhouse.log
}

# 日志文件大小变量 10MB
log_file_max_size=$((5 * 1024 * 1024))

# 日志文件数量变量 10
log_file_num_max_size=5

# 日志文件过大就进行裁剪，数量过多就删除历史文件
function check_and_clean_log() {
  # 接收传入的日志文件变量
  local check_and_clean_log_log_file=$1

  # 打印标识清理日志文件开始执行
  echo "[INFO] | $(date '+%Y-%m-%d %H:%M:%S') | start check and clean logs" >>$check_and_clean_log_log_file
  # 获取当前日志文件大小
  size=$(du -b $check_and_clean_log_log_file | awk '{print $1}')
  # 获取当前历史日志文件数量
  num=$(find $log_dir/ -wholename "${check_and_clean_log_log_file}-*" | wc -l)

  # 如果当前日志文件大小超过限制，则将日志文件分出去
  [[ $size -gt $log_file_max_size ]] && {
    # 将当前日志文件分摊到标有时间的日志文件中
    echo "[WARNING] | $(date '+%Y-%m-%d %H:%M:%S') | too large log exsit, mv oldest logs file." >>$check_and_clean_log_log_file
    mv $check_and_clean_log_log_file $check_and_clean_log_log_file"-""$(date '+%Y%m%d%H%M%S')"
    touch $check_and_clean_log_log_file
  }

  # 如果文件数量超过限制个数，则删除最早的一个日志
  [[ $num -gt $log_file_num_max_size ]] && {
    # 清理过多的日志文件
    echo "[WARNING] | $(date '+%Y-%m-%d %H:%M:%S') | too much log exsit, clean oldest logs file." >>$check_and_clean_log_log_file
    rm -rf "$(find $log_dir/ -wholename "${check_and_clean_log_log_file}-*" | uniq | sort -n -r | sed -n '1p')"
  }
}

# 循环执行检查
while (true); do
  # 执行时间间隔
  sleep $sleep_seconds
  echo "$(date '+%Y-%m-%d %H:%M:%S') check clickhouse ..." >>$log_file

  # 执行检查步骤
  do_check_log

  echo "$(date '+%Y-%m-%d %H:%M:%S') check clickhouse done" >>$log_file
  echo "..." >> $log_file
done
