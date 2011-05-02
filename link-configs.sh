#!/bin/bash

SOURCE_DIR=~/etc
CONFIG_DIR=~/.config
HOME_DIR=~

# configuration files which reside in ~/.config
CONFIG_DIR_FILES=(
    awesome
)

# configuration files which reside in ~/
HOME_DIR_FILES=(
    bashrc
    emacs
    gitconfig
    gtkrc-2.0
    inputrc
    pentadactylrc
    profile
    screenrc
    vim
    vimrc
    Xresources
    xsession
)

for f in "${CONFIG_DIR_FILES[@]}"; do
    SRC=$SOURCE_DIR/$f
    DEST=$CONFIG_DIR/$f

    if [ ! -e $DEST ]; then
        ln -vs $SRC $DEST
    else
        echo "'$f' already exists"
    fi
done

for f in "${HOME_DIR_FILES[@]}"; do
    SRC=$SOURCE_DIR/$f
    DEST=$HOME_DIR/.$f

    if [ ! -e $DEST ]; then
        ln -vs $SRC $DEST
    else
        echo "'$f' already exists"
    fi
done
