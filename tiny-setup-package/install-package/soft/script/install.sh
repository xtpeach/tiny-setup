#!/bin/bash

# source
source ./common.sh

# ----- install begin -----

# ---> jdk
#log_info "start install jdk"
#cd $INSTALL_DIR/resource/jdk-8u401
#bash install_jdk.sh
#log_info "install jdk finished"

# ---> python
#log_info "start install python"
#cd $INSTALL_DIR/resource/Python-3.8.16
#bash install_python.sh
#log_info "install python finished"

# ---> docker
if [[ $(command -v docker) ]]; then
  log_info "$(docker -v)"
  log_info "$(docker-compose -v)"
else
  log_info "start install docker"
  cd $INSTALL_DIR/resource/docker-19.03.9-setup
  # 这边不要运行 close_firewall.sh
  bash setup_docker.sh >/dev/null 2>&1
  bash close_selinux.sh >/dev/null 2>&1
  log_info "$(docker -v)"
  log_info "$(docker-compose -v)"
  log_info "install docker finished"
fi

# ---> redis
if [[ "$REDIS_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install redis"
  cd $INSTALL_DIR/component/redis
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install redis finished"
else
  log_info "uninstall redis"
  cd $INSTALL_DIR/component/redis
  bash uninstall_container.sh
fi

# ---> zookeeper
if [[ "$ZOOKEEPER_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install zookeeper"
  cd $INSTALL_DIR/component/zookeeper
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install zookeeper finished"
else
  log_info "uninstall zookeeper"
  cd $INSTALL_DIR/component/zookeeper
  bash uninstall_container.sh
fi

# ---> kafka
if [[ "$KAFKA_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install kafka"
  cd $INSTALL_DIR/component/kafka
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install kafka finished"
else
  log_info "uninstall kafka"
  cd $INSTALL_DIR/component/kafka
  bash uninstall_container.sh
fi

# ---> postgresql
if [[ "$POSTGRESQL_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install postgresql"
  cd $INSTALL_DIR/component/postgresql
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install postgresql finished"
else
  log_info "uninstall postgresql"
  cd $INSTALL_DIR/component/postgresql
  bash uninstall_container.sh
fi

# ---> mysql
if [[ "$MYSQL_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install mysql"
  cd $INSTALL_DIR/component/mysql
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install mysql finished"
else
  log_info "uninstall mysql"
  cd $INSTALL_DIR/component/mysql
  bash uninstall_container.sh
fi

# ---> clickhouse
if [[ "$CLICKHOUSE_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install clickhouse"
  cd $INSTALL_DIR/component/clickhouse
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install clickhouse finished"
else
  log_info "uninstall clickhouse"
  cd $INSTALL_DIR/component/clickhouse
  bash uninstall_container.sh
fi

# ---> eureka
if [[ "$EUREKA_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install eureka"
  cd $INSTALL_DIR/component/eureka
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install eureka finished"
else
  log_info "uninstall eureka"
  cd $INSTALL_DIR/component/eureka
  bash uninstall_container.sh
fi

# ---> nacos
if [[ "$NACOS_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install nacos"
  cd $INSTALL_DIR/component/nacos
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install nacos finished"
else
  log_info "uninstall nacos"
  cd $INSTALL_DIR/component/nacos
  bash uninstall_container.sh
fi

# ---> nginx
if [[ "$NGINX_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install nginx"
  cd $INSTALL_DIR/component/nginx
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install nginx finished"
else
  log_info "uninstall nginx"
  cd $INSTALL_DIR/component/nginx
  bash uninstall_container.sh
fi

# ---> tiny-id
if [[ "$TINY_ID_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install tiny-id"
  cd $INSTALL_DIR/component/tiny-id
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install tiny-id finished"
else
  log_info "uninstall tiny-id"
  cd $INSTALL_DIR/component/tiny-id
  bash uninstall_container.sh
fi

# ---> tiny-file
if [[ "$TINY_FILE_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install tiny-file"
  cd $INSTALL_DIR/component/tiny-file
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install tiny-file finished"
else
  log_info "uninstall tiny-file"
  cd $INSTALL_DIR/component/tiny-file
  bash uninstall_container.sh
fi

# ---> tiny-sa
if [[ "$TINY_SA_INSTALL_REQUIRED"x == "true"x ]]; then
  log_info "start install tiny-sa"
  cd $INSTALL_DIR/component/tiny-sa
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install tiny-sa finished"
else
  log_info "uninstall tiny-sa"
  cd $INSTALL_DIR/component/tiny-sa
  bash uninstall_container.sh
fi

# ----- install end -----

# ---> open port
log_info "start open port"
cd $INSTALL_DIR/soft/script
bash ./port/open_port.sh
log_info "open port finished"

echo -e "
███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
" >> $SETUP_LOG_FILE

# ---> tag success to end progress bar
echo "#@success@#" >>$SETUP_LOG_FILE
