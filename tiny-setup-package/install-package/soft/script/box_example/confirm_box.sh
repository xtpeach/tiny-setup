#!/bin/bash
# whiptail --title --yesno 演示示例
# whiptail 弹窗确认信息
whiptail --title "Yes/No Box" --yesno "Choose between Yes and No." 10 60

# 获取上面 whiptail 弹窗选择了 yes 还是 no
confirm_status=$?

# confirm 选择了yes或者no之后的数值不同
# yes - 0 / no - 1
if [[ $confirm_status -eq 0 ]]; then
  # 选择了 yes 之后走到这里
  echo "You chose Yes. Exit status was $?."
else
  # 选择了 no 之后走到这里
  echo "You chose No. Exit status was $?."
fi
