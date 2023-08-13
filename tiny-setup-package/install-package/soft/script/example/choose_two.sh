#!/bin/bash
if (whiptail --title "Yes/No Box" --yes-button "Man" --no-button "Woman"  --yesno "What is your gender?" 10 60) then
    echo "You chose Man Exit status was $?."
else
    echo "You chose Woman. Exit status was $?."
fi
