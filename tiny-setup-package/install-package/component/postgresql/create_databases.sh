#!/bin/bash
# source
source ../../soft/script/common.sh

for index in "${!DATABASE_NAME_ARRAY[@]}"; do
  log_info "docker exec -it postgresql psql -U postgres -c \"CREATE DATABASE ${DATABASE_NAME_ARRAY[$index]} WITH ENCODING 'UTF8' LC_COLLATE='C' LC_CTYPE='C' TEMPLATE template0;\""
  docker exec postgresql psql -U postgres -c "CREATE DATABASE ${DATABASE_NAME_ARRAY[$index]} WITH ENCODING 'UTF8' LC_COLLATE='C' LC_CTYPE='C' TEMPLATE template0;"
done