#!/bin/bash
# jenkins最新war包从下面地址可以下载
# https://updates.jenkins-ci.org/download/war/
if [[ ! -f jenkins.war ]]; then
  wget https://mirrors.tuna.tsinghua.edu.cn/jenkins/war/2.454/jenkins.war
fi

# 没有下载下来，就不继续执行启动
if [[ ! -f jenkins.war ]]; then
  echo "没有 jenkins.war 文件，请先下载最新 jenkins.war"
  echo "https://updates.jenkins-ci.org/download/war/"
  exit 1
fi

# 检查 JAVA_HOME 环境变量
if [ -n "$JAVA_HOME" ]; then
    java_version=$("$JAVA_HOME/bin/java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [[ "$java_version" == "11"* ]]; then
        echo "JDK 11 已安装"
    else
        echo "JDK 11 未安装"
    fi
else
    echo "JAVA_HOME 环境变量未设置"
fi

# 具体jvm参数根据实际情况调整
nohup java -jar -Xms1G -Xmx1G -XX:+UseG1GC jenkins.war --httpPort=8081 > jenkins.log 2>&1 &
echo "jenkins 已启动"