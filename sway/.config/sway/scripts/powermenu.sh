#!/bin/bash

options="⏻ Power Off\n Reboot\n⏾ Suspend\n󰗽 Logout"

choice=$(echo -e "$options" | fuzzel --dmenu --prompt="Power  " -l 4 -w 25)

case "$choice" in
    "⏻ Power Off")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "⏾ Suspend")
        systemctl suspend
        ;;
    "󰗽 Logout")
        swaymsg exit
        ;;
    *)
        exit 0
        ;;
esac