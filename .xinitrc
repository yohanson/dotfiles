#!/bin/bash

TOP_OFFSET=630
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

xrandr --output VGA-0 --rotate left --pos 0x0 \
       --output DVI-I-1 --pos 1080x$TOP_OFFSET --primary

setxkbmap -layout us,ru -option grp:ctrl_shift_toggle,grp_led:scroll,compose:caps,lv3:ralt_switch,misc:typo,nbsp:level3n

xset -b
feh --bg-tile .bg.jpg &
gxkb &
~/.local/share/TelegramDesktop/Telegram &
slack &
skypeforlinux &
xscreensaver -no-splash &
parcellite &
pasystray &
claws-mail &
[ -x ~/bin/screensaver-watch ] && ~/bin/screensaver-watch &
xfce4-notifyd || /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd &
exec i3
#exec $session

