#!/bin/bash
# 该脚本检查一个子网中有哪些IP可以ping通，有哪些IP不可以ping通

subnet=$1

if [ -z "$subnet" ]; then
    echo "Usage: $0 <subnet>"
    exit 1
fi

echo "-------------------------------------------------------"

column=1
for ip in $(seq 1 254); do
    ping -c 1 -W 1 "$subnet.$ip" > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "\e[32m$subnet.$ip[√]\e[0m\t\c"
    else
        echo -e "\e[31m$subnet.$ip[X]\e[0m\t\c"
    fi

    if [ $((column % 4)) -eq 0 ]; then
        echo
    fi

    ((column++))
done

echo
echo "-------------------------------------------------------"
