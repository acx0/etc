#!/bin/bash

### configurable settings
SOURCE_DIR=~/etc
CONFIG_DIR=~/.config
HOME_DIR=~
BACKUP_DIR=$HOME_DIR/dotfiles.bak

# configuration files which reside in ~/.config
CONFIG_DIR_FILES=(
    awesome
)

# configuration files which reside in ~/
HOME_DIR_FILES=(
    bashrc
    dircolors
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

### functions
BFLAG=0
DFLAG=0
FFLAG=0
LFLAG=0
RFLAG=0
WFLAG=0

backup() {
    if [ -d "$BACKUP_DIR" -a "$FFLAG" == 0 ]; then
        echo >&2 "$(basename $0): error: backup directory already exists"
        exit 1
    elif [ ! -d "$BACKUP_DIR" ]; then
        mkdir -v $BACKUP_DIR
    fi

    for f in "${CONFIG_DIR_FILES[@]}"; do
        SRC=$CONFIG_DIR/$f

        cp -vrd $SRC $BACKUP_DIR
    done

    for f in "${HOME_DIR_FILES[@]}"; do
        SRC=$HOME_DIR/.$f

        cp -vrd $SRC $BACKUP_DIR
    done
}

delete() {
    for f in "${CONFIG_DIR_FILES[@]}"; do
        FILE=$CONFIG_DIR/$f

        if [ -L "$FILE" ]; then
            rm -v $FILE
        fi
    done

    for f in "${HOME_DIR_FILES[@]}"; do
        FILE=$HOME_DIR/.$f

        if [ -L "$FILE" ]; then
            rm -v $FILE
        fi
    done
}

list() {
    LIGHT_RED=$(tput bold ; tput setaf 1)
    LIGHT_GREEN=$(tput bold ; tput setaf 2)
    LIGHT_BLUE=$(tput bold ; tput setaf 4)
    LIGHT_CYAN=$(tput bold ; tput setaf 6)
    ATTR_RESET=$(tput sgr0)

    # add all files to a single array
    ALL_FILES=( )

    for f in "${CONFIG_DIR_FILES[@]}"; do
        ALL_FILES[${#ALL_FILES[*]}]=$CONFIG_DIR/$f
    done

    for f in "${HOME_DIR_FILES[@]}"; do
        ALL_FILES[${#ALL_FILES[*]}]=$HOME_DIR/.$f
    done

    for f in "${ALL_FILES[@]}"; do
        if [ -L "$f" ]; then
            echo -e "[${LIGHT_CYAN}LINK${ATTR_RESET}]\t$f"
        elif [ -f "$f" ]; then
            echo -e "[${LIGHT_GREEN}FILE${ATTR_RESET}]\t$f"
        elif [ -d "$f" ]; then
            echo -e "[${LIGHT_BLUE}DIR${ATTR_RESET}]\t$f"
        elif [ ! -e "$f" ]; then
            echo -e "[${LIGHT_RED}NONE${ATTR_RESET}]\t$f"
        else
            echo -e "[OTHER]\t$f"
        fi
    done
}

restore() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo >&2 "$(basename $0): error: backup directory does not exist"
        exit 1
    fi

    for f in "${CONFIG_DIR_FILES[@]}"; do
        SRC=$BACKUP_DIR/$f
        DST=$CONFIG_DIR/$f

        if [ -e $DST ]; then
            rm -rf $DST
        fi
        mv -v $SRC $DST
    done

    for f in "${HOME_DIR_FILES[@]}"; do
        SRC=$BACKUP_DIR/.$f
        DST=$HOME_DIR/.$f

        if [ -e $DST ]; then
            rm -rf $DST
        fi
        mv -v $SRC $DST
    done

    if [ "$(ls -A $BACKUP_DIR)" ]; then
        echo >&2 "$(basename $0): warning: backup directory not empty; not removing"
    else
        rmdir -v $BACKUP_DIR
    fi
}

write() {
    for f in "${CONFIG_DIR_FILES[@]}"; do
        SRC=$SOURCE_DIR/$f
        DST=$CONFIG_DIR/$f

        if [ ! -e $DST -o "$FFLAG" == 1 ]; then
            if [ -e $DST ]; then
                rm -rf $DST
            fi
            ln -vfs $SRC $DST
        else
            echo >&2 "$(basename $0): warning: \`$DST' already exists"
        fi
    done

    for f in "${HOME_DIR_FILES[@]}"; do
        SRC=$SOURCE_DIR/$f
        DST=$HOME_DIR/.$f

        if [ ! -e $DST -o "$FFLAG" == 1 ]; then
            if [ -e $DST ]; then
                rm -rf $DST
            fi
            ln -vfs $SRC $DST
        else
            echo >&2 "$(basename $0): warning: \`$DST' already exists"
        fi
    done
}

usage() {
    echo -e >&2 "usage: $(basename $0) [-bdhlrw] [-f]"
    echo -e >&2 "\t-b  backup existing files"
    echo -e >&2 "\t-d  delete symlinks"
    echo -e >&2 "\t-f  force removal of existing files"
    echo -e >&2 "\t-l  list file types and exit"
    echo -e >&2 "\t-r  restore from backup if it exists"
    echo -e >&2 "\t-w  write symlinks"

    echo -e >&2 "\n\t-h  display this help and exit"

    echo -e >&2 "\nnote: files must be defined in HOME_DIR_FILES and CONFIG_DIR_FILES arrays"
    exit 1
}

### main
while getopts bdfhlrw OPT; do
    case "$OPT" in
        h)  usage;;
        b)  BFLAG=1;;
        d)  DFLAG=1;;
        f)  FFLAG=1;;
        l)  LFLAG=1;;
        r)  RFLAG=1;;
        w)  WFLAG=1;;
        ?)  usage;;
    esac
done

if [ "$BFLAG" == 1 ]; then
    backup
elif [ "$DFLAG" == 1 ]; then
    delete
elif [ "$LFLAG" == 1 ]; then
    list
elif [ "$RFLAG" == 1 ]; then
    restore
elif [ "$WFLAG" == 1 ]; then
    write
else
    list
fi
