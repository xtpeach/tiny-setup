#!/bin/bash
# 监控间隔时间
sleep_seconds=5

# 环境变量
source /etc/profile

# 日志文件路径
log_dir=/data/logs/monitor
# 日志文件
log_file=$log_dir/do_check_nginx.log
# 创建日志文件路径
mkdir -p $log_dir
# 创建日志文件
touch $log_file

# 检查
do_check_nginx() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') check nginx step1 " >> $log_file
}

# 循环执行检查
while (true); do
    # 执行时间间隔
    sleep $sleep_seconds
    echo "$(date '+%Y-%m-%d %H:%M:%S') check nginx ..." >> $log_file

    # 执行检查步骤
    do_check_nginx

    echo "$(date '+%Y-%m-%d %H:%M:%S') check nginx done" >> $log_file
    echo "..." >> $log_file
done
