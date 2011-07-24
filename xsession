#!/bin/bash

SESSION=awesome

xrdb -merge .Xresources &
urxvtd -q -o -f &

# use theme settings from gnome; not needed if settings in .gtkrc-2.0
#gnome-settings-daemon &
gnome-power-manager &

wicd-client &
xflux -l 43 &

xsetroot -solid black   # set root window background

if [ "$SESSION" = "awesome" ]; then
    exec awesome
elif [ "$SESSION" = "dwm" ]; then
    while true; do
        xsetroot -name "$(date +"%a %b %d %H:%M %Z %Y")"
        sleep 60
    done &

    exec ~/etc/dwm/dwm
fi
