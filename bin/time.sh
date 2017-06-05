#!/bin/bash
# Account time window being active, per window name.
# Do I need this?
INTERVAL=1
FLUSHINTERVAL=300
OUTFILE=/tmp/time
declare -A seconds
counter=0
OLDOF=

function flush()
{
    counter=0
    > $OF
    for i in "${!seconds[@]}"; do
        echo  "${seconds[$i]}" $'\t' "$i" >> $OF
    done
}

while true; do
    xscreensaver-command -time | grep -q locked && locked=true || locked=false
    if ! $locked; then
        windowname=$(xdotool getactivewindow getwindowname | sed 's/`/\\`/g')
        if [[ -z $windowname ]]; then
           pid=$(xdotool getactivewindow getwindowpid)
           windowname=$(cat /proc/$pid/comm)
        fi
        OF=$OUTFILE-$(date --rfc-3339=date)
        if [ "$OLDOF" != "" ] && [ "$OF" != "$OLDOF" ]; then
            flush
            unset seconds
            declare -A seconds
        fi
        if [[ -z $windowname ]]; then
            let seconds["$windowname"]+=$INTERVAL
            let "counter+=$INTERVAL"
        fi
        if [ $(($counter % $FLUSHINTERVAL)) -eq 0 ]; then
            flush
        fi
        OLDOF=$OF
    fi
    sleep $INTERVAL
done


