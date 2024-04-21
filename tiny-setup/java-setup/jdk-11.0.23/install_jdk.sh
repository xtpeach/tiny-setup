#!/bin/bash

# 需要现在同级目录下面准备一个jdk安装文件例如：jdk-11.0.23_linux-x64_bin.tar.gz

# 找到jdk文件
JDK_FILE=$(find ./ -name "jdk*.tar.gz"  | awk 'END {print}')

# jdk 解压路径
JDK_PATH=/usr/local/java

# 创建 jdk 解压路径
mkdir -p $JDK_PATH

# 解压到执行目录
tar -zxvf $JDK_FILE -C ${JDK_PATH}/ --strip-components 1

# 添加环境变量
echo "export JAVA_HOME=${JDK_PATH}/" >> /etc/profile
echo "export PATH=\${JAVA_HOME}/bin:\$PATH" >> /etc/profile
source /etc/profile

# 测试是否已经安装
java -version