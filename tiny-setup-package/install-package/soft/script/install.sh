#!/bin/bash

# source
source ./common.sh

# ----- install begin -----

# ---> jdk
#log_info "start install jdk"
#cd $INSTALL_PACKAGE_DIR/resource/jdk-8u401
#bash install_jdk.sh
#log_info "install jdk finished"

# ---> python
#log_info "start install python"
#cd $INSTALL_PACKAGE_DIR/resource/Python-3.8.16
#bash install_python.sh
#log_info "install python finished"

# ---> docker
log_info "start install docker"
cd $INSTALL_PACKAGE_DIR/resource/docker-19.03.9-setup
bash setup_docker.sh
bash close_selinux.sh
log_info "install docker finished"

# ---> redis
if [[ "$redis_install_required"x == "true"x ]]; then
  log_info "start install redis"
  cd $INSTALL_PACKAGE_DIR/component/redis
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install redis finished"
fi

# ---> zookeeper
if [[ "$zookeeper_install_required"x == "true"x ]]; then
  log_info "start install zookeeper"
  cd $INSTALL_PACKAGE_DIR/component/zookeeper
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install zookeeper finished"
fi

# ---> kafka
if [[ "$kafka_install_required"x == "true"x ]]; then
  log_info "start install kafka"
  cd $INSTALL_PACKAGE_DIR/component/kafka
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install kafka finished"
fi

# ---> postgresql
if [[ "$postgresql_install_required"x == "true"x ]]; then
  log_info "start install postgresql"
  cd $INSTALL_PACKAGE_DIR/component/postgresql
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install postgresql finished"
fi

# ---> mysql
if [[ "$mysql_install_required"x == "true"x ]]; then
  log_info "start install mysql"
  cd $INSTALL_PACKAGE_DIR/component/mysql
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install mysql finished"
fi

# ---> eureka
if [[ "$eureka_install_required"x == "true"x ]]; then
  log_info "start install eureka"
  cd $INSTALL_PACKAGE_DIR/component/eureka
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install eureka finished"
fi

# ---> nacos
if [[ "$nacos_install_required"x == "true"x ]]; then
  log_info "start install nacos"
  cd $INSTALL_PACKAGE_DIR/component/nacos
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install nacos finished"
fi

# ---> nginx
if [[ "$nginx_install_required"x == "true"x ]]; then
  log_info "start install nginx"
  cd $INSTALL_PACKAGE_DIR/component/nginx
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install nginx finished"
fi

# ---> tiny-id
if [[ "$tiny_id_install_required"x == "true"x ]]; then
  log_info "start install tiny-id"
  cd $INSTALL_PACKAGE_DIR/component/tiny-id
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install tiny-id finished"
fi

# ---> tiny-file
if [[ "$tiny_file_install_required"x == "true"x ]]; then
  log_info "start install tiny-file"
  cd $INSTALL_PACKAGE_DIR/component/tiny-file
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install tiny-file finished"
fi

# ---> tiny-sa
if [[ "$tiny_sa_install_required"x == "true"x ]]; then
  log_info "start install tiny-sa"
  cd $INSTALL_PACKAGE_DIR/component/tiny-sa
  bash uninstall_container.sh
  bash install_container.sh
  log_info "install tiny-sa finished"
fi

# ----- install end -----

# ---> open port
log_info "start open port"
cd $INSTALL_PACKAGE_DIR/soft/script
bash ./open_port.sh
log_info "open port finished"

# ---> tag success to end progress bar
echo "#@success@#" >>$LOG_FILE
