#!/bin/bash

# key和value的分隔符，即等号两边有没有空格
delimeter='='
#delimeter=' = '

# 操作参数
operate=$1
# 操作文件
file=$2
# 指定section
section=$3
# 指定key
key=$4
# value
value=$5

# 提示信息
msg="Please input the param <get|set> <file> <section> <key> [value]"

# 定制化shell输出
function custom_print() {
  echo -e "\033[5;34m ***** \033[0m"
  echo -e "\033[32m $@ ! \033[0m"
  echo -e "\033[5;34m ***** \033[0m"
}

# 获取配置文件指定section指定key的value
function get_opt() {
    file=$1
    section=$2
    key=$3

    # 设置IFS为等号，以便按照key=value对进行分割
    IFS="="

    # 读取文件内容，并逐行处理
    while read -r line; do
        # 如果行以#开头，则跳过
        if [[ $line =~ ^# ]]; then
            continue
        fi

        # 如果行以[section]开头，则设置flag为1，表示开始读取指定section的内容
        if [[ $line =~ ^\[$section\] ]]; then
            flag=1
            continue
        fi

        # 如果flag为1，表示已经进入指定section的内容区域
        if [[ $flag -eq 1 ]]; then
            # 如果行为空行，则表示已经读取完指定section的内容，退出循环
            if [[ -z $line ]]; then
                break
            fi

            # 将行按照等号分割为key和value
            read -r k v <<< "$line"

            # 去除key和value的前后空格
            k=$(echo "$k" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            v=$(echo "$v" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

            # 如果key等于指定的key，则输出对应的value并退出循环
            if [[ $k == $key ]]; then
                echo "$v"
                break
            fi
        fi
    done < "$file"
}

# 更新配置文件指定section指定key的value
function set_opt() {
  file=$1
  section=$2
  key=$3
  val=$4
  awk -F "$delimeter" '/\['${section}'\]/{a=1} (a==1 && "'${key}'"==$1){gsub($2,"'${val}'");a=0} {print $0}' ${file} 1<>${file}
}

# 判断输入参数
if [[ -z $operate || $operate == "help" || $operate == "-h" || -z $section || -z $key ]]; then
  custom_print $msg
elif [[ $operate == "get" ]]; then
  val=$(get_opt $file $section $key)
  echo $val
elif [[ $operate == "set" && $value ]]; then
  set_opt $file $section $key $value
  msg='update success'
  custom_print $msg
else
  custom_print $msg
fi
