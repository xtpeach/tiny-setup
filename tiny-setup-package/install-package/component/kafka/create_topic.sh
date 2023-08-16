#!/bin/bash

# source
source ../../soft/script/common.sh

#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --list
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --create --partitions 2 --replication-factor 3
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --describe
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --alter --partitions 3 --replication-factor 3
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --alter --replication-factor 3

for index in "${!kafka_topic_array[@]}"; do
  topic_array=($(echo ${kafka_topic_array[$index]} | tr ':' ' '))
  topic=${topic_array[0]}
  topic_param_array=($(echo ${topic_array[1]} | tr '_' ' '))
  topic_partition_array=($(echo ${topic_param_array[0]} | tr '-' ' '))
  topic_replication_array=($(echo ${topic_param_array[1]} | tr '-' ' '))
  topic_partition=${topic_partition_array[1]}
  topic_replication=${topic_replication_array[1]}
  echo "index: $index, topic: ${topic} - topic_partition $topic_partition - topic_replication $topic_replication"
  docker exec kafka bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka${kafka_ip_index_first}:9092 --topic ${topic} --create --partitions $topic_partition --replication-factor $topic_replication
done
