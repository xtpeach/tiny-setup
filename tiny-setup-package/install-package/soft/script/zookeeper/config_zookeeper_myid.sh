#!/bin/bash
zookeeper_myid=$1
if [[ "$zookeeper_myid"x != x ]]; then
  touch /data/zookeeper/myid
  echo "$zookeeper_myid" > /data/zookeeper/myid
fi
