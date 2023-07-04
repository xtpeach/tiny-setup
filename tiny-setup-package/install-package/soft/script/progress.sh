#!/bin/bash

echo " > install: [start]"

echo "" > install_cluster.log

{
  for i in {1..100}; do
    echo $i >> install_cluster.log
    sleep 0.5
  done

  echo "install:success" >> install_cluster.log
} &

# 基础行数
let log_row_num_total=100

# 实时行数，不停在获取当前行数
install_success_flag=
log_row_num_current=0
i=0
i_percent=0
bar=''
index=0
arr=("|" "/" "-" "\\")
while [ $i -le 99 ]; do
  install_success_flag=$(cat install_cluster.log | grep "install:success")
  log_row_num_current=$(sed -n '$=' install_cluster.log)
  let i_percent=(log_row_num_current * 100)/log_row_num_total
  if [ $i -le $i_percent ]; then
    if [ $i -le 98 ]; then
      let i++
      bar+='#'
    fi
  fi

  if [ "$install_success_flag"x != "x" ]; then
    i=100
    bar='####################################################################################################'
  fi

  let index=index%4
  let index++
  printf "[%-100s][%d%%][\e[43;46;1m%c\e[0m]\r" "$bar" "$i" "${arr[$index]}"
  usleep 300000
done

printf "\n"
echo " > install: [ok]"
