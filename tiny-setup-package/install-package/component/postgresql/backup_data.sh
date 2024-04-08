#!/bin/bash
# source
source ../../soft/script/common.sh

# 获取一下时间戳
date_str=$(date +%Y-%m-%d_%H:%M:%S)
# postgresql 备份时间戳目录
postgresql_backup_dir=/home/postgresql_backup/${date_str}
# postgresql 备份数据库目录
if [[ ! -d "${postgresql_backup_dir}" ]]; then
  # 如果备份数据库目录不存在则创建
  mkdir -p ${postgresql_backup_dir}
fi

# 循环创建数据库备份.sql文件
for index in "${!DATABASE_NAME_ARRAY[@]}"; do
  # 在PostgreSQL容器中执行pg_dump命令，将数据导出为.sql文件
  docker exec -i postgresql pg_dump -U postgres ${DATABASE_NAME_ARRAY[$index]} >/tmp/${DATABASE_NAME_ARRAY[$index]}.sql
  # 将.sql文件从PostgreSQL容器复制到宿主机
  docker cp postgresql:/tmp/${DATABASE_NAME_ARRAY[$index]}.sql ${postgresql_backup_dir}/${DATABASE_NAME_ARRAY[$index]}.sql
done

# 判断文件夹数量是否大于90，防止程序意外停止，删除所有备份
dirCount=$(ls -l /home/postgresql_backup/ | grep "^d" | wc -l)
if [[ ${dirCount} -gt 90 ]]; then
  # 删除超过90天的带"_"的目录
  find /home/postgresql_backup/ -mtime +90 -name "*_*" -exec rm -rf {} \;
fi
