#!/bin/bash

if [[ -f "jenkins.pid" ]]; then
    kill $(cat jenkins.pid)
    rm jenkins.pid
    echo "jenkins 已停止"
else
    echo "jenkins 未启动"
fi