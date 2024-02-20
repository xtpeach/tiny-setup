#!/bin/bash
# whiptail --title --checklist 演示示例
# whiptail 弹窗确认信息
# 使用空格来进行多选
choices=$(whiptail --title "Multiple Selection Example" --checklist \
  "Choose your favorite programming languages:" 15 50 4 \
  "1" "Python" ON \
  "2" "Java" OFF \
  "3" "C" OFF \
  "4" "JavaScript" OFF \
  3>&1 1>&2 2>&3)

# 获取上面 whiptail 弹窗是否选择了退出
exit_status=$?

# 判断 whiptail 是否选择了退出
if [[ $exit_status -eq 0 ]]; then
  # 如果 whiptail 没有选择退出，则 exit_status 值为 0
  echo "Your favorite programming language is:"
  for choice in $choices; do
    echo "$choice"
  done
else
  # 如果 whiptail 选择了退出，则 exit_status 不为 0
  echo "You chose Cancel."
fi
