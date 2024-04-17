#!/bin/bash
# 该脚本检查一个子网中有哪些IP可以ping通，有哪些IP不可以ping通

# 接受一个输入，X.X.X，一个IP地址的前三位
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

# 用于换行使用
column=1
for ip in $(seq 1 254); do
  # 将占位符输入到结果文件中，用于后面替换
  echo -e "[${ip}]\t\c" >>./subnet_ping_result/subnet_ping_result_tmp
  # 一行展示6个
  if [ $((column % 6)) -eq 0 ]; then
    # 6个一换行
    echo "" >>./subnet_ping_result/subnet_ping_result_tmp
  fi
  # 这边一直递增，用于取模运算，计算换行
  ((column++))
done

# 这一遍并行执行，并将结果录入各个IP的结果文件
for ip in $(seq 1 254); do
  {
    # ping 命令校验连通性，ping 1次，超时时间 1秒
    ping -c 1 -W 1 "$subnet.$ip" >/dev/null
    # 判断是否可以ping通
    if [ $? -eq 0 ]; then
      # 如果可以ping通就展示绿色
      echo -e "\e[32m$ip[√]\e[0m" >./subnet_ping_result/$ip
    else
      # 如果ping不同就展示红色
      echo -e "\e[31m$ip[X]\e[0m" >./subnet_ping_result/$ip
    fi
  } &
done

# 等待上面所有的ping都执行完毕
wait

# 这一遍收集所有的结果
for ip in $(seq 1 254); do
  # 获取并行执行的每一个进程的执行结果
  ip_result=$(cat ./subnet_ping_result/$ip)
  # 将执行结果写入最终的结果文件
  sed -i "s/\[$ip\]/$ip_result/g" ./subnet_ping_result/subnet_ping_result_tmp
done

# 将结果展示出来
cat ./subnet_ping_result/subnet_ping_result_tmp

# 最后把过程文件删除
rm -rf ./subnet_ping_result

echo
echo
echo "-------------------------------------------------------"
