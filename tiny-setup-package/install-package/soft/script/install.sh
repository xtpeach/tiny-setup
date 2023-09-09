#!/bin/bash

# source
source ./common.sh

# ----- install begin -----
# redis
cd $INSTALL_PACKAGE_DIR/component/redis
bash uninstall_container.sh
bash install_container.sh

# zookeeper
cd $INSTALL_PACKAGE_DIR/component/zookeeper
bash uninstall_container.sh
bash install_container.sh

# kafka
cd $INSTALL_PACKAGE_DIR/component/kafka
bash uninstall_container.sh
bash install_container.sh

# postgresql
cd $INSTALL_PACKAGE_DIR/component/postgresql
bash uninstall_container.sh
bash install_container.sh

# mysql
cd $INSTALL_PACKAGE_DIR/component/mysql
bash uninstall_container.sh
bash install_container.sh

# eureka
cd $INSTALL_PACKAGE_DIR/component/eureka
bash uninstall_container.sh
bash install_container.sh

# nacos
cd $INSTALL_PACKAGE_DIR/component/nacos
bash uninstall_container.sh
bash install_container.sh

# nginx
cd $INSTALL_PACKAGE_DIR/component/nginx
bash uninstall_container.sh
bash install_container.sh

# tiny-id
cd $INSTALL_PACKAGE_DIR/component/tiny-id
bash uninstall_container.sh
bash install_container.sh

# ----- install end -----

# open port
cd $INSTALL_PACKAGE_DIR/soft/script
bash ./open_port.sh