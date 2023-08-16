#!/bin/bash
NAME=$(whiptail --title "Free-form Input Box" --inputbox "What is your pet's name?" 10 60 Peter 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your name is:" $NAME
else
    echo "You chose Cancel."
fi

