#!/bin/bash
# 进度条
sleep_time=2
# 刷新 testProgressBar.log 放入 “start” 字符串到首行
echo "start" > /home/testProgressBar.log
{
	# 需要执行的逻辑
	{
		# 中间的执行步骤
		sleep $sleep_time
		echo "1"
		sleep $sleep_time
		echo "2"
		sleep $sleep_time
		echo "3"
		sleep $sleep_time

		# 最后打印 success
		echo "success"

	} >> /home/testProgressBar.log 2>&1 &

	# 进度条显示
    for ((i = 0; i <= 100 ; i+=10)); do
        sleep $sleep_time
		# 判断执行日志最后一行是否打印的成功标志“success”
		lastLine=`sed -n '$p' /home/testProgressBar.log`
		if [[ "$lastLine"x = "success"x ]]; then
		    # 若已成功直接进度到达100
			sleep_time=0.5
			#i=100
		fi
        echo $i
    done
} | whiptail --gauge "Please wait while installing" 6 60 0