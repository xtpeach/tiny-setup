#!/bin/bash
# 该脚本检查一个子网中有哪些IP可以ping通，有哪些IP不可以ping通

subnet=$1

# 校验输入格式是否为X.X.X形式，X为0-255之间的数字
if ! [[ $subnet =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid subnet format. Please provide a subnet in the format X.X.X, where X is a number between 0 and 255."
  exit 1
fi

echo "-------------------------------------------------------"
echo "----------> ${subnet} <----------"
echo

# 创建一个文件夹，用于存放所有ping进程的结果
rm -rf ./subnet_ping_result
mkdir -p ./subnet_ping_result
# 先创建一个文件，将需要展示的IP地址位置先录入文件
rm -f ./subnet_ping_result/subnet_ping_result_tmp
touch ./subnet_ping_result/subnet_ping_result_tmp

column=1
for ip in $(seq 1 254); do
  echo -e "[${ip}]\t\c" >> ./subnet_ping_result/subnet_ping_result_tmp
  # 一行展示6个
  if [ $((column % 6)) -eq 0 ]; then
    echo "" >> ./subnet_ping_result/subnet_ping_result_tmp
  fi
  ((column++))
done

# 这一遍并行执行，并将结果录入各个IP的结果文件
for ip in $(seq 1 254); do
  {
    ping -c 1 -W 1 "$subnet.$ip" >/dev/null
    if [ $? -eq 0 ]; then
      echo -e "\e[32m$ip[√]\e[0m" > ./subnet_ping_result/$ip
    else
      echo -e "\e[31m$ip[X]\e[0m" > ./subnet_ping_result/$ip
    fi
  } &
done

# 等待上面所有的ping都执行完毕
wait

# 这一遍收集所有的结果
for ip in $(seq 1 254); do
    ip_result=$(cat ./subnet_ping_result/$ip)
    sed -i "s/\[$ip\]/$ip_result/g" ./subnet_ping_result/subnet_ping_result_tmp
done

cat ./subnet_ping_result/subnet_ping_result_tmp

# 最后把过程文件删除
rm -rf ./subnet_ping_result

echo
echo
echo "-------------------------------------------------------"