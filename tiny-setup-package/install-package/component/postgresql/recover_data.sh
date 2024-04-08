#!/bin/bash

# 备份目录路径
postgresql_backup_dir=/home/postgresql_backup/

# 在备份目录中查找以时间戳命名的文件夹，并按时间排序
latest_folder=$(find "$postgresql_backup_dir" -type d | sort -r | head -n 1)

# 循环恢复数据库
for index in "${!DATABASE_NAME_ARRAY[@]}"; do
  # 将.sql文件从宿主机复制到PostgreSQL容器
  docker cp "${postgresql_backup_dir}/${DATABASE_NAME_ARRAY[$index]}.sql" postgresql:/tmp/${DATABASE_NAME_ARRAY[$index]}.sql

  # 恢复数据库
  docker exec postgresql sh -c "psql -U postgres ${DATABASE_NAME_ARRAY[$index]} < /tmp/${DATABASE_NAME_ARRAY[$index]}.sql"

  # 删除容器中的临时 SQL 文件
  docker exec postgresql rm /tmp/${DATABASE_NAME_ARRAY[$index]}.sql
done