#!/bin/bash
# 监控间隔时间
sleep_seconds=5

# 执行日志存放目录
logPath=/data/logs/shellAutoExecuter

# 执行器存放执行脚本根目录
rootPath=/home/shellAutoExecuter

# 还未执行的脚本存放目录
unexecutedPath=$rootPath/unexecuted

# 已执行的脚本存放目录
executedPath=$rootPath/executed

# 创建上面需要用到的目录
mkdir -p $logPath
mkdir -p $rootPath
mkdir -p $unexecutedPath
mkdir -p $executedPath

##日志文件目录不存在则创建
if [[ ! -d "${logPath}/" ]]; then
  ##	echo "日志文件目录不存在,创建${logPath}"
  mkdir $logPath
  chmod 777 -R $logPath
  touch $logPath/shellAutoExecuter.log
  chmod 777 $logPath/shellAutoExecuter.log
fi

# 日志文件不存在则创建
if [[ ! -f "${logPath}/shellAutoExecuter.log" ]]; then
  touch $logPath/shellAutoExecuter.log
  chmod 777 $logPath/shellAutoExecuter.log
fi

# 容器执行脚本根目录不存在则创建
if [[ ! -d "${rootPath}/" ]]; then
  now=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${now}  执行器存放,创建${rootPath}" >>$logPath/shellAutoExecuter.log
  mkdir $rootPath
  chmod 777 -R $rootPath
fi

# 还未执行的脚本存放目录不存在则创建
if [ ! -d "${rootPath}/unexecuted/" ]; then
  now=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${now}  还未执行的脚本存放目录录不存在,创建${rootPath}/unexecuted" >>$logPath/shellAutoExecuter.log
  mkdir $rootPath/unexecuted
  chmod 777 -R $rootPath/unexecuted
fi

# 已执行的脚本存放目录不存在则创建
if [ ! -d "${rootPath}/executed/" ]; then
  now=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${now}  已执行的脚本存放目录录不存在,创建${rootPath}/executed" >>$logPath/shellAutoExecuter.log
  mkdir $rootPath/executed
  chmod 777 -R $rootPath/executed
fi

# 遍历目录
traverse_dir() {
  filepath=$1
  for file in $(ls -a $filepath); do
    if [[ ! -d "${filepath}/${file}" ]]; then
      # 调用查找指定后缀文件
      exc_sh_suffix $filepath $file
    fi
  done
}

# 执行后缀为sh的文件
exc_sh_suffix() {
  filepath=$1
  filename=$2
  file="${filepath}/${filename}"

  if [[ "${file##*.}"x = "sh"x ]]; then
    line_total=$(cat ${file} | wc -l)
    if [[ $line_total -ge 1 ]]; then
      now=$(date +"%Y-%m-%d %H:%M:%S")
      echo "${now}  执行脚本${rootPath}/executed/${filename}" >>$logPath/shellAutoExecuter.log
      chmod +x $file
      cd $filepath
      mv $filename ../executed/$filename
      bash ../executed/$filename >>$logPath/shellAutoExecuter.log 2>&1 &
    fi
  fi
}

# 循环执行检查
while (true); do
  # 执行时间间隔
  sleep $sleep_seconds
  ##开始执行
  traverse_dir $unexecutedPath
done
