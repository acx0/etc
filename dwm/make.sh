#!/bin/bash

LINE=$(grep -n 'static const char \*termcmd' config.h | awk -F ':' '{ print $1 }')

if [[ -e /usr/bin/urxvt ]]; then
    TERMCMD=urxvt
else
    TERMCMD=xterm
fi

sed -i "${LINE}s/\".*\"/\"$TERMCMD\"/" config.h
make
