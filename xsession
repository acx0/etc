#!/bin/bash

SESSION=awesome

xrdb -merge ~/.Xresources & # load X resource preferences
xmodmap ~/.xmodmaprc &      # load custom keyboard mappings
xsetroot -solid black &     # set root window background
xset r rate 580 40 &        # set keyboard delay and repeat rate

# move cursor to bottom right corner of screen
xdotool mousemove $(xrandr | grep '*' | awk '{ print $1 }' | tr 'x' ' ') &

urxvtd -q -o -f &
redshift -l 43.7:-79.3 &
xfce4-power-manager &

# required for qtconfig to load gtk theme
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if [ "$SESSION" = "awesome" ]; then
    exec awesome
elif [ "$SESSION" = "dwm" ]; then
    trayer --edge bottom --widthtype request &

    while true; do
        xsetroot -name "$(date +"%a %b %d %H:%M %Z %Y")"
        sleep 60
    done &

    exec ~/etc/dwm/dwm
fi
