#!/bin/bash
# 监控间隔时间
sleep_seconds=5

# 环境变量
source /etc/profile

# 日志文件路径
log_dir=/data/logs/monitor
# 日志文件
log_file=$log_dir/do_check_kafka.log
# 创建日志文件路径
mkdir -p $log_dir
# 创建日志文件
touch $log_file

# 检查
do_check_kafka() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') check kafka step1 " >> $log_file
}

# 循环执行检查
while (true); do
    # 执行时间间隔
    sleep $sleep_seconds
    echo "$(date '+%Y-%m-%d %H:%M:%S') check kafka ..." >> $log_file

    # 执行检查步骤
    do_check_kafka

    echo "$(date '+%Y-%m-%d %H:%M:%S') check kafka done" >> $log_file
    echo "..." >> $log_file
done
