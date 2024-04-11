#!/bin/bash

# source
source ./common.sh

# ----- uninstall begin -----

# ---> docker

# ---> redis
cd $INSTALL_PACKAGE_DIR/component/redis
bash uninstall_container.sh

# ---> zookeeper
cd $INSTALL_PACKAGE_DIR/component/zookeeper
bash uninstall_container.sh

# ---> kafka
cd $INSTALL_PACKAGE_DIR/component/kafka
bash uninstall_container.sh

# ---> postgresql
cd $INSTALL_PACKAGE_DIR/component/postgresql
bash uninstall_container.sh

# ---> mysql
cd $INSTALL_PACKAGE_DIR/component/mysql
bash uninstall_container.sh

# ---> eureka
cd $INSTALL_PACKAGE_DIR/component/eureka
bash uninstall_container.sh

# ---> nacos
cd $INSTALL_PACKAGE_DIR/component/nacos
bash uninstall_container.sh

# ---> nginx
cd $INSTALL_PACKAGE_DIR/component/nginx
bash uninstall_container.sh

# ---> tiny-id
cd $INSTALL_PACKAGE_DIR/component/tiny-id
bash uninstall_container.sh

# ---> tiny-file
cd $INSTALL_PACKAGE_DIR/component/tiny-file
bash uninstall_container.sh

# ---> tiny-sa
cd $INSTALL_PACKAGE_DIR/component/tiny-sa
bash uninstall_container.sh

# ----- uninstall end -----
