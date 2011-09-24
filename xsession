#!/bin/bash

SESSION=awesome

xrdb -merge ~/.Xresources & # load X resource preferences
xmodmap ~/.xmodmaprc &      # load custom keyboard mappings
xsetroot -solid black &     # set root window background

urxvtd -q -o -f &
wicd-client &
xflux -l 43 &
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
