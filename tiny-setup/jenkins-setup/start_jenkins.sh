#!/bin/bash

if [[ -f "jenkins.pid" ]]; then
  if ps -p $(cat jenkins.pid) >/dev/null; then
    kill $(cat jenkins.pid)
    rm jenkins.pid
    echo "jenkins 已停止"
  else
    rm jenkins.pid
    echo "jenkins 进程不存在"
  fi
else
  echo "jenkins 未启动"
  nohup /usr/local/java/bin/java \
    -Xms20480m \
    -Xmx20480m \
    -XX:MetaspaceSize=2560m \
    -XX:MaxMetaspaceSize=5120m \
    -Djava.awt.headless=true \
    -Dhudson.lifecycle=hudson.lifecycleの中にJavaexecLifecycle \
    -Djenkins.model.Jenkins.buildDiscarderLogSize=1000 \
    -Djenkins.model.Jenkins.jobNameBlacklistRegex=.*forbidden.* \
    -jar /opt/jenkins.war \
    --httpPort=8081 \
    --webroot=/opt/jenkins \
    >/var/log/jenkins/jenkins.log 2>&1 &
  echo $! >jenkins.pid
  echo "jenkins 已启动"
fi
