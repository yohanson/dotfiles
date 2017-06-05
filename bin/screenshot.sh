#!/bin/bash
dir=$HOME/Pictures/Screenshots

(
flock -n 9 || exit 1

filename=$(date +%F-%H%M%S).png

if [ $# -eq 1 ] && [ $1 = 'current' ]; then
	import -frame -border -window $(xdotool getwindowfocus) $dir/$filename
    echo -e "Shot window:\n$(xdotool getwindowfocus getwindowname)" | osd
elif [ $# -eq 1 ] && [ $1 = 'select' ]; then
    sleep 0.5
    echo "Select a region." | osd
    scrot -e "echo $urlbase/\$n | xsel" -d1 -s $dir'/%Y-%m-%d-%H%M%S.png' && echo "Screenshot saved" | osd
else
	import -window root $dir/$filename && echo "Screenshot saved" | osd
fi

beep -f 400 -l 50

sleep 2
) 9>/tmp/screenshot.lock

