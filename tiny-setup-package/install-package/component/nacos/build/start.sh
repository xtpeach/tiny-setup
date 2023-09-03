#!/bin/bash
cd /home/nacos/bin
bash startup.sh -m standalone
tail -f /home/nacos/logs/start.out