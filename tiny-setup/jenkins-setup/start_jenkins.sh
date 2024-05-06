#!/bin/bash

if [[ -f "jenkins.pid" ]]; then
    if ps -p $(cat jenkins.pid) > /dev/null
    then
        kill $(cat jenkins.pid)
        rm jenkins.pid
        echo "jenkins 已停止"
    else
        rm jenkins.pid
        echo "jenkins 进程不存在"
    fi
else
    echo "jenkins 未启动"
    nohup java -jar jenkins.war --httpPort=8081 > jenkins.log 2>&1 &
    echo $! > jenkins.pid
    echo "jenkins 已启动"
fi