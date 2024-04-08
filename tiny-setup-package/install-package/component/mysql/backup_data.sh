#!/bin/bash
# source
source ../../soft/script/common.sh

# 获取一下时间戳
date_str=$(date +%Y-%m-%d_%H:%M:%S)
# mysql 备份时间戳目录
mysql_backup_dir=/home/mysql_backup/${date_str}
# mysql 备份数据库目录
if [[ ! -d "${mysql_backup_dir}" ]]; then
  # 如果备份数据库目录不存在则创建
  mkdir -p ${mysql_backup_dir}
fi

# 循环创建数据库备份.sql文件
for index in "${!DATABASE_NAME_ARRAY[@]}"; do
  # 导出数据到.sql文件
  docker exec -i mysql mysqldump -uroot -p${MYSQL_PASSWORD} ${DATABASE_NAME_ARRAY[$index]} >/tmp/${DATABASE_NAME_ARRAY[$index]}.sql
  # 将.sql文件从MySQL容器复制到宿主机
  docker cp mysql:/tmp/${DATABASE_NAME_ARRAY[$index]}.sql ${mysql_backup_dir}/${DATABASE_NAME_ARRAY[$index]}.sql
done

# 判断文件夹数量是否大于90，防止程序意外停止，删除所有备份
dirCount=$(ls -l /home/mysql_backup/ | grep "^d" | wc -l)
if [[ ${dirCount} -gt 90 ]]; then
  # 删除超过90天的带"_"的目录
  find /home/mysql_backup/ -mtime +90 -name "*_*" -exec rm -rf {} \;
fi
