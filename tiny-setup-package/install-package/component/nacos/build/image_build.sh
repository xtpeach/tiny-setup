#!/bin/bash
cat nacos.tar.gz.part* | tar -xzvf -
docker build --no-cache=true -t nacos:xtpeach .
