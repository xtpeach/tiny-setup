#!/bin/bash
# whiptail --title --textbox --scrolltext 演示示例
# whiptail 显示可以上下滚动的文本框对话框
# 创建一个临时文件，用于存放要展示的长文本内容
tempfile=$(mktemp)
echo "这是一个很长的文本内容，可以超出文本框的显示范围。" >$tempfile
for i in {1..20}; do
  echo "这是第 $i 行文本内容。" >>$tempfile
done

# 使用 whiptail 显示文本框对话框并启用滚动
whiptail --title "滚动文本框示例" --textbox $tempfile 20 60 --scrolltext
# 这边没必要去拿上面 whiptail 的执行结果了，因为只会拿到 0

# 删除临时文件
rm $tempfile