#!/bin/bash
tar -zxvf kafka_2.13-3.4.1.tar.gz
docker build --no-cache=true -t kafka:xtpeach .
