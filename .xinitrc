#!/bin/bash

session=$1

[ -z "$session" ] && session=x-session-manager

export PATH=~/bin:$PATH
export GTK_IM_MODULE=xim
export LC_TIME=ru_RU.UTF-8
export LC_PAPER=ru_RU.UTF-8
export LC_ADDRESS=ru_RU.UTF-8
export LC_MEASUREMENT=ru_RU.UTF-8
export LANGUAGE=en_US.UTF-8
export MAILER=claws-mail

xrdb -load ~/.Xresources

. $HOME/.config/my_scripts.conf

xrandr --output VGA-0 --rotate normal --output DVI-I-1 --right-of VGA-0 --primary

setxkbmap -layout us,ru -option grp:ctrl_shift_toggle,grp_led:scroll,compose:caps,lv3:ralt_switch,misc:typo,nbsp:level3n

xset -b
feh --bg-tile .bg.jpg &
gxkb &
~/.local/share/TelegramDesktop/Telegram &
slack &
xautolock &
parcellite &
pasystray &
claws-mail &
xfce4-notifyd || /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd &
arbtt-capture &
exec i3
#exec $session

