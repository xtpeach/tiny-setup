#!/bin/bash
tar -zxvf zookeeper-3.8.1.tar.gz
docker build --no-cache=true -t zookeeper:xtpeach .
