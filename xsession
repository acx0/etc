#!/bin/bash

SESSION=awesome

xrdb -merge ~/.Xresources & # load X resource preferences
xmodmap ~/.xmodmaprc &      # load custom keyboard mappings
xsetroot -solid black &     # set root window background
xset r rate 250 40 &        # set keyboard delay and repeat rate
xset b off &                # disable system bell
xset dpms 0 300 600 &       # seconds before screen is in standby/suspend/off state

urxvtd -q -o -f &
redshift -l 50.0:-114.1 &   # calgary
# redshift -l 40.7:-74.0 &    # nyc
# redshift -l 43.7:-79.3 &    # toronto
# redshift -l 47.6:-122.3 &   # seattle
xfce4-power-manager &
nm-applet &
blueman-applet &

# ~/bin scripts
tp off &    # disable touchpad

# required for qtconfig to load gtk theme
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if [ "$SESSION" = "awesome" ]; then
    exec awesome
elif [ "$SESSION" = "dwm" ]; then
    trayer --edge bottom --widthtype request &

    while true; do
        xsetroot -name "$(date +"%a %b %d %H:%M %Z %Y")"
        sleep 10
    done &

    exec ~/etc/dwm/dwm
fi
