#!/bin/bash
# whiptail --title --yes-button --no-button --yesno 演示示例
# whiptail 弹窗确认信息
whiptail --title "Yes/No Box" --yes-button "Man" --no-button "Woman" --yesno "What is your gender?" 10 60

# 获取上面 whiptail 弹窗选择了 yes 还是 no
# 这边的和 confirm 类型，只是把 yes 和 no 换成了另外两个选项
# 在 yes 位置的选项对应的数值为0，在 no 位置的选项对应的数值为 1
choose_status=$?

# confirm 选择了yes或者no之后的数值不同
# yes位置（左） - 0 / no位置（右） - 1
if [[ $choose_status -eq 0 ]]; then
  # 选择了 yes位置（左） 之后走到这里
  echo "You chose Man Exit status was $?."
else
  # 选择了 no位置（右） 之后走到这里
  echo "You chose Woman. Exit status was $?."
fi
