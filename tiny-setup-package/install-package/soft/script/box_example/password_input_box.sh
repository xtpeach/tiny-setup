#!/bin/bash
# whiptail --title --passwordbox 演示示例
# whiptail 弹窗输入密码
PASSWORD=$(whiptail --title "Password Box" --passwordbox "Enter your password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3)

# 获取上面 whiptail 弹窗是否选择了退出
exit_status=$?

# 判断 whiptail 是否选择了退出
if [[ $exit_status -eq 0 ]]; then
  # 如果 whiptail 没有选择退出，则 exit_status 值为 0
  echo "Your password is:" $PASSWORD
else
  # 如果 whiptail 选择了退出，则 exit_status 不为 0
  echo "You chose Cancel."
fi
