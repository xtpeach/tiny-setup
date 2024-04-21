#!/bin/bash

# 检查是否已安装 Java
java -version >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Java 已安装"
else
  echo "Java 未安装"
  exit 1
fi

MAVEN_HOME=/usr/local/maven

rm -rf $MAVEN_HOME
mkdir -p $MAVEN_HOME

tar -zxvf apache-maven-3.8.8-bin.tar.gz -C ${MAVEN_HOME}/ --strip-components 1

# 添加环境变量
echo "export MAVEN_HOME=/usr/local/maven/" >> /etc/profile
echo "export PATH=\${MAVEN_HOME}/bin:\$PATH" >> /etc/profile
source /etc/profile

mvn -version