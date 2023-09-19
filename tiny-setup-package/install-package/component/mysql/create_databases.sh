#!/bin/bash
# source
source ../../soft/script/common.sh

for index in "${!DATABASE_NAME_ARRAY[@]}"; do
  log_info "docker exec -it mysql mysql -u root -p${MYSQL_PASSWORD} -e \"CREATE DATABASE ${DATABASE_NAME_ARRAY[$index]} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci\""
  docker exec -it mysql mysql -u root -p${MYSQL_PASSWORD} -e "CREATE DATABASE ${DATABASE_NAME_ARRAY[$index]} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
done