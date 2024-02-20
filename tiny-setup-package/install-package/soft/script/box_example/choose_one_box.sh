#!/bin/bash
# whiptail --title --menu 演示示例
# whiptail 弹窗确认信息
option=$(whiptail --title "Menu Dialog" --menu "Choose your favorite programming language." 15 60 4 \
  "1" "Python" \
  "2" "Java" \
  "3" "C" \
  "4" "PHP" 3>&1 1>&2 2>&3)

# 获取上面 whiptail 弹窗是否选择了退出
exit_status=$?

# 判断 whiptail 是否选择了退出
if [[ $exit_status -eq 0 ]]; then
  # 如果 whiptail 没有选择退出，则 exit_status 值为 0
  echo "Your favorite programming language is:" $option
else
  # 如果 whiptail 选择了退出，则 exit_status 不为 0
  echo "You chose Cancel."
fi
