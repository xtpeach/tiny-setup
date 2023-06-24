#!/bin/bash
ip_str=$1
domain_str=$2
if [[ "$ip_str"x != x && "$domain_str"x != x ]]; then
  echo "$1 $2" >> /etc/hosts
if