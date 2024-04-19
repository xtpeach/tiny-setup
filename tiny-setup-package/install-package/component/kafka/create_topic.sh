#!/bin/bash

# source
source ../../soft/script/common.sh

#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --list
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --create --partitions 2 --replication-factor 3
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --describe
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --alter --partitions 3 --replication-factor 3
#bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --alter --replication-factor 3

# create topic
# 循环读取 config.ini 中的 topic
for index in "${!kafka_topic_array[@]}"; do
  # 例如：topic1=first_topic:p-3_r-1
  # 将配置的 topic 分割入数组
  topic_array=($(echo ${kafka_topic_array[$index]} | tr ':' ' '))
  # topic的名称: first_topic
  topic=${topic_array[0]}
  # topic的副本和分区数量：p-3 r-1
  topic_param_array=($(echo ${topic_array[1]} | tr '_' ' '))
  # topic的分区数量(p-3): p 3
  topic_partition_array=($(echo ${topic_param_array[0]} | tr '-' ' '))
  # topic的副本数量(r-1): r 1
  topic_replication_array=($(echo ${topic_param_array[1]} | tr '-' ' '))

  # partition 分区
  topic_partition=${topic_partition_array[1]}
  # replication 副本
  topic_replication=${topic_replication_array[1]}

  log_note "index: $index, topic: ${topic} ; [topic_partition] - $topic_partition; [topic_replication] - $topic_replication"

  # 创建 topic
  docker exec kafka bash /usr/local/kafka/bin/kafka-topics.sh --bootstrap-server kafka${KAFKA_IP_INDEX_FIRST}:9092 --topic ${topic} --create --partitions $topic_partition --replication-factor $topic_replication
done
