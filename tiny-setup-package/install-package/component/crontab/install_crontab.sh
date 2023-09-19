#!/bin/bash

# insert crontab
echo "*/1 * * * * root docker ps > /data/logs/docker_ps.log 2>&1 &" >> /etc/crontab