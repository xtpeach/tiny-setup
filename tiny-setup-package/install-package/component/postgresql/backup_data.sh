#!/bin/bash
# source
source ../../soft/script/common.sh

# 获取时间戳
date_str=$(date +%Y-%m-%d_%H:%M:%S)
# postgresql 备份时间戳目录
postgresql_backup_dir="/home/postgresql_backup/${date_str}"
# 创建 postgresql 备份数据库目录
mkdir -p "${postgresql_backup_dir}"

# 循环创建数据库备份.sql文件
for index in "${!DATABASE_NAME_ARRAY[@]}"; do
  # 输出一个日志用于让用户看到
  echo "正在备份:${DATABASE_NAME_ARRAY[$index]}"
  # 在PostgreSQL容器中执行pg_dump命令，将数据导出为.sql文件
  docker exec -i postgresql pg_dump -U postgres "${DATABASE_NAME_ARRAY[$index]}" >/tmp/"${DATABASE_NAME_ARRAY[$index]}".sql
  # 将.sql文件从PostgreSQL容器复制到宿主机
  docker cp postgresql:/tmp/"${DATABASE_NAME_ARRAY[$index]}".sql "${postgresql_backup_dir}"/"${DATABASE_NAME_ARRAY[$index]}".sql
  # 删除容器中的临时 SQL 文件
  docker exec postgresql rm /tmp/"${DATABASE_NAME_ARRAY[$index]}".sql
  # 输出一个日志用于让用户看到
  echo "备份sql:${DATABASE_NAME_ARRAY[$index]}.sql 已保存至 ${postgresql_backup_dir}"
done

# 判断文件夹数量是否大于90，防止程序意外停止，删除所有备份
dirCount=$(find /home/postgresql_backup/ -maxdepth 1 -type d -name "*_*" | wc -l)
if (( dirCount > 90 )); then
  # 删除超过90天的带"_"的目录
  find /home/postgresql_backup/ -maxdepth 1 -type d -name "*_*" -mtime +90 -exec rm -rf {} \;
fi

# 输出一个日志用于让用户看到
echo "所有数据库备份sql已保存至:${postgresql_backup_dir} done."