#!/bin/bash
kafka_home_path=/home/install-package/component/kafka/kafka_2.13-3.4.1
bash $kafka_home_path/bin/kafka-server-start.sh -daemon $kafka_home_path/config/server.properties