#!/bin/bash

# source
source ./common.sh

# ----- install begin -----
# ---> redis
log_info "start install redis"
cd $INSTALL_PACKAGE_DIR/component/redis
bash uninstall_container.sh
bash install_container.sh
log_info "install redis finished"

# ---> zookeeper
log_info "start install zookeeper"
cd $INSTALL_PACKAGE_DIR/component/zookeeper
bash uninstall_container.sh
bash install_container.sh
log_info "install zookeeper finished"

# ---> kafka
log_info "start install kafka"
cd $INSTALL_PACKAGE_DIR/component/kafka
bash uninstall_container.sh
bash install_container.sh
log_info "install kafka finished"

# ---> postgresql
log_info "start install postgresql"
cd $INSTALL_PACKAGE_DIR/component/postgresql
bash uninstall_container.sh
bash install_container.sh
log_info "install postgresql finished"

# ---> mysql
log_info "start install mysql"
cd $INSTALL_PACKAGE_DIR/component/mysql
bash uninstall_container.sh
bash install_container.sh
log_info "install mysql finished"

# ---> eureka
log_info "start install eureka"
cd $INSTALL_PACKAGE_DIR/component/eureka
bash uninstall_container.sh
bash install_container.sh
log_info "install eureka finished"

# ---> nacos
log_info "start install nacos"
cd $INSTALL_PACKAGE_DIR/component/nacos
bash uninstall_container.sh
bash install_container.sh
log_info "install nacos finished"

# ---> nginx
log_info "start install nginx"
cd $INSTALL_PACKAGE_DIR/component/nginx
bash uninstall_container.sh
bash install_container.sh
log_info "install nginx finished"

# ---> tiny-id
log_info "start install tiny-id"
cd $INSTALL_PACKAGE_DIR/component/tiny-id
bash uninstall_container.sh
bash install_container.sh
log_info "install tiny-id finished"

# ----- install end -----

# ---> open port
log_info "start open port"
cd $INSTALL_PACKAGE_DIR/soft/script
bash ./open_port.sh
log_info "open port finished"


# ---> tag success to end progress bar
echo "#@success@#" >> $LOG_FILE