#!/bin/bash

# update config
function update_config() {
  config_file=$1
  update_config_key=$2
  update_config_value=$3
  line=$(grep -n "$update_config_key=" $config_file | cut -d ":" -f 1)
  [[ ! -n "$line" ]] || {
    line=$line"c $update_config_key=$update_config_value"
    sed -i "$line" $config_file
  }
}

# broker id
if [[ -z $BROKER_ID ]]; then
  update_config $KAFKA_CONF_DIR/server.properties "broker.id" "0"
else
  update_config $KAFKA_CONF_DIR/server.properties "broker.id" "$BROKER_ID"
fi

# listeners
if [[ ! -z $LISTENERS ]]; then
  sed -i "/listeners=/d" $KAFKA_CONF_DIR/server.properties
  echo "listeners=$LISTENERS" >> $KAFKA_CONF_DIR/server.properties
fi

# zookeeper servers
if [[ ! -z $ZOO_SERVERS ]]; then
  zookeeper_server=""
  for server in $ZOO_SERVERS; do
    zookeeper_server="${zookeeper_server},$server"
  done
  zookeeper_server="${zookeeper_server}/kafka"
  sed -i "/zookeeper.connect=/d" $KAFKA_CONF_DIR/server.properties
  echo "zookeeper.connect=$zookeeper_server" >> $KAFKA_CONF_DIR/server.properties
fi

cd /usr/local/kafka
exec "$@"