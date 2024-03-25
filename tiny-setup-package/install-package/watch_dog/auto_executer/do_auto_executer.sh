#!/bin/bash
# 监控间隔时间
sleep_seconds=1s

# 执行日志存放目录
log_path=/data/logs/auto_executer

# 自动执行
log_file=$log_path/auto_executer.log

# 执行器存放执行脚本根目录
root_path=/home/auto_executer

# 还未执行的脚本存放目录
unexecuted_path=$root_path/unexecuted

# 已执行的脚本存放目录
executed_path=$root_path/executed

# 创建上面需要用到的目录
mkdir -p $log_path
mkdir -p $root_path
mkdir -p $unexecuted_path
mkdir -p $executed_path

##日志文件目录不存在则创建
if [[ ! -d "${log_path}/" ]]; then
  ##	echo "日志文件目录不存在,创建${log_path}"
  mkdir $log_path
  chmod 777 -R $log_path
  touch $log_path/auto_executer.log
  chmod 777 $log_path/auto_executer.log
fi

# 日志文件不存在则创建
if [[ ! -f "${log_path}/auto_executer.log" ]]; then
  touch $log_path/auto_executer.log
  chmod 777 $log_path/auto_executer.log
fi

# 容器执行脚本根目录不存在则创建
if [[ ! -d "${root_path}/" ]]; then
  now=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${now}  执行器存放,创建${root_path}" >>$log_path/auto_executer.log
  mkdir $root_path
  chmod 777 -R $root_path
fi

# 还未执行的脚本存放目录不存在则创建
if [ ! -d "${root_path}/unexecuted/" ]; then
  now=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${now}  还未执行的脚本存放目录录不存在,创建${root_path}/unexecuted" >>$log_path/auto_executer.log
  mkdir $root_path/unexecuted
  chmod 777 -R $root_path/unexecuted
fi

# 已执行的脚本存放目录不存在则创建
if [ ! -d "${root_path}/executed/" ]; then
  now=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${now}  已执行的脚本存放目录录不存在,创建${root_path}/executed" >>$log_path/auto_executer.log
  mkdir $root_path/executed
  chmod 777 -R $root_path/executed
fi

# 遍历目录
traverse_dir() {
  # 接收文件路径
  filepath=$1

  # 循环文件路径
  for file in $(ls -a $filepath); do

    # 循环文件路径下面的文件，如果是文件不是目录则调用执行
    if [[ ! -d "${filepath}/${file}" ]]; then

      # 调用指定后缀文件
      exec_sh_suffix $filepath $file

    fi
  done
}

# 执行后缀为sh的文件
exec_sh_suffix() {
  # 接收文件路径
  filepath=$1

  # 接收文件名称
  filename=$2

  # 拼出完整的文件路径
  file="${filepath}/${filename}"

  # 判断该需要执行的文件名是否是 .sh 结尾
  if [[ "${file##*.}"x = "sh"x ]]; then
    # 获取文件的行数
    line_total=$(cat ${file} | wc -l)

    # 需要执行的 shell 文件不能只有1行
    if [[ $line_total -ge 1 ]]; then
      # 先打印开始执行
      echo "$(date +"%Y-%m-%d %H:%M:%S") 执行脚本${root_path}/executed/${filename}" >>$log_path/auto_executer.log

      # 添加可执行权限
      chmod +x $file

      # 到文件路径下
      cd $filepath

      # 先移动文件
      mv $filename ../executed/$filename

      # 再执行文件
      bash ../executed/$filename >>$log_path/auto_executer.log 2>&1 &
    fi
  fi
}

# 循环执行检查
while (true); do

  # 开始执行
  traverse_dir $unexecuted_path

  # 执行时间间隔
  sleep $sleep_seconds

done
