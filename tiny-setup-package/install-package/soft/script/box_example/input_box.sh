#!/bin/bash
# whiptail --title --inputbox 演示示例
# whiptail 弹窗输入信息
NAME=$(whiptail --title "Free-form Input Box" --inputbox "What is your pet's name?" 10 60 Peter 3>&1 1>&2 2>&3)

# 获取上面 whiptail 弹窗是否选择了退出
exit_status=$?

# 判断 whiptail 是否选择了退出
if [[ $exit_status -eq 0 ]]; then
  # 如果 whiptail 没有选择退出，则 exit_status 值为 0
  echo "Your name is:" $NAME
else
  # 如果 whiptail 选择了退出，则 exit_status 不为 0
  echo "You chose Cancel."
fi
