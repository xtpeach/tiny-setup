#!/bin/bash
redis_data_path=/data/redis
rm -rf $redis_data_path
log_note "[remove redis]" "rm -rf $redis_data_path"