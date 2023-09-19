#!/bin/bash

# zookeeper myid
if [[ ! -f "$ZOO_DATA_DIR/myid" ]]; then
  echo "${ZOO_MY_ID:-1}" >"$ZOO_DATA_DIR/myid"
fi

# zookeeper servers
if [[ -z $ZOO_SERVERS ]]; then
  ZOO_SERVERS="server.1=localhost:2888:3888;2181"
fi

# zookeeper servers
for server in $ZOO_SERVERS; do
  sed -i "/${server}/d" /etc/hosts
  echo "$server" >> "$ZOO_CONF_DIR/zoo.cfg"
done

cd /usr/local/zookeeper
exec "$@"
