#!/bin/bash
dir=$HOME/Pictures/Screenshots
if [ "$1" == "--help" ]; then
    echo "Usage: $0 [mode]"
    echo "mode can be one of:"
    echo "  current - capture current window"
    echo "  select  - select rectangle to capture"
    echo "  screen  - capture full screen"
    exit
fi

die()
{
    echo "$1"
    exit 1
}

timeout()
{
    seconds="$1"
    message="$2"
    echo "$message" | osd || exit
    while [ $seconds -gt 0 ]; do
        echo "$seconds..."
        sleep 1
        let seconds--
    done | osd
}

(
flock -n 9 || die "Already locked"

filename=$(date +%F-%H%M%S).png
success=true

case "$1" in
current)
    import -window $(xdotool getwindowfocus) $dir/$filename
    echo -e "Shot window:\n$(xdotool getwindowfocus getwindowname)" | osd
    ;;
select)
    echo "Select a region." | osd
    crop=$(xrectsel) || die "xrectsel error"
    [ "$crop" != "" ] || die "xrectsel empty result"
    crop=$(echo $crop | awk -F: '{print $1 "x" $2 "+" $3 "+" $4}')
    timeout 3 "Capturing in..."


    import -window root -crop "$crop" $dir/$filename && echo "Screenshot saved" | osd
    ;;
screen)
	import -window root $dir/$filename && echo "Screenshot saved" | osd
    ;;
*)
    success=false
    ;;
esac

$success && sleep 1
) 9>/tmp/screenshot.lock

