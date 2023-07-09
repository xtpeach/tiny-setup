#!/bin/bash
bash kafka-topics.sh --bootstrap-server kafka128:9092 --list
bash kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --create --partitions 2 --replication-factor 3
bash kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --describe
bash kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --alter --partitions 3 --replication-factor 3
bash kafka-topics.sh --bootstrap-server kafka128:9092 --topic first_topic --alter --replication-factor 3
