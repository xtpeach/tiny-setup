#!/bin/bash
zookeeper_myid=$1
echo "zookeeper_myid: $zookeeper_myid"
if [[ "$zookeeper_myid"x != x ]]; then
  mkdir -p /data/zookeeper
  touch /data/zookeeper/myid
  echo "$zookeeper_myid" > /data/zookeeper/myid
fi
