#!/bin/bash
OPTION=$(whiptail --title "Menu Dialog" --menu "Choose your favorite programming language." 15 60 4 \
"1" "Python" \
"2" "Java" \
"3" "C" \
"4" "PHP"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your favorite programming language is:" $OPTION
else
    echo "You chose Cancel."
fi
