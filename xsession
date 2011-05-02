#!/bin/bash

xrdb -merge .Xresources &
urxvtd -q -f &

# use theme settings from gnome; not needed if settings in .gtkrc-2.0
#gnome-settings-daemon &
gnome-power-manager &

wicd-client &
xflux -l 43 &

exec awesome
