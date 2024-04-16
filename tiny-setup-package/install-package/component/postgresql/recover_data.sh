#!/bin/bash

# 备份目录路径
postgresql_backup_dir=/home/postgresql_backup/

# 在备份目录中查找以时间戳命名的文件夹，并按时间排序
latest_folder=$(find "$postgresql_backup_dir" -type d | sort -r | head -n 1)

echo "正在恢复:$latest_folder"

# 循环恢复数据库
for index in "${!DATABASE_NAME_ARRAY[@]}"; do
  # 输出一个日志用于让用户看到
  echo "正在恢复:${DATABASE_NAME_ARRAY[$index]}"

  # 这边恢复数据库的前提是数据库已经建好了，如果是重新执行的数据库安装，那么数据库会被重新建立
  # 恢复数据库
  docker exec postgresql sh -c "psql -U postgres ${DATABASE_NAME_ARRAY[$index]} < $latest_folder/${DATABASE_NAME_ARRAY[$index]}.sql"

  # 输出一个日志用于让用户看到
  echo "恢复sql:${DATABASE_NAME_ARRAY[$index]}.sql 执行完毕."
done