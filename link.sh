#!/bin/bash

### configurable settings
SOURCE_DIR=$HOME/etc
BACKUP_DIR=$SOURCE_DIR.bak

# files to be managed
#   index 2k is source
#   index 2k+1 is destination
FILES=(
    "awesome" "$HOME/.config/awesome"
    "bashrc" "$HOME/.bashrc"
    "dircolors" "$HOME/.dircolors"
    "emacs" "$HOME/.emacs"
    "gitconfig" "$HOME/.gitconfig"
    "gtkrc-2.0" "$HOME/.gtkrc-2.0"
    "inputrc" "$HOME/.inputrc"
    "pentadactylrc" "$HOME/.pentadactylrc"
    "profile" "$HOME/.profile"
    "screenrc" "$HOME/.screenrc"
    "ssh/config" "$HOME/.ssh/config"
    "tmux.conf" "$HOME/.tmux.conf"
    "vim" "$HOME/.vim"
    "vimrc" "$HOME/.vimrc"
    "Xcolours" "$HOME/.Xcolours"
    "xmodmaprc" "$HOME/.xmodmaprc"
    "Xresources" "$HOME/.Xresources"
    "xsession" "$HOME/.xsession"
    "zshrc" "$HOME/.zshrc"
)
FSIZE=$(( ${#FILES[@]} / 2 ))

### functions
BFLAG=0
DFLAG=0
FFLAG=0
LFLAG=0
RFLAG=0
WFLAG=0

backup() {
    if [ -e "$BACKUP_DIR" -a "$FFLAG" = 0 ]; then
        echo >&2 "$(basename $0): error: backup directory already exists"
        exit 1
    else
        if [ -e "$BACKUP_DIR" ]; then
            rm -rf $BACKUP_DIR
        fi
        mkdir -v $BACKUP_DIR
    fi

    for (( i = 0; i < $FSIZE; i++ )); do
        # $SRC and $DST are reversed since we're backing up
        SRC=${FILES[2 * $i + 1]}
        DST=${FILES[2 * $i]}

        if [ "$(echo $DST | grep "/")" -a -e "$SRC" ]; then
            mkdir -p $BACKUP_DIR/$(dirname $DST)
        fi
        if [ -e "$SRC" ]; then
            cp -vrd $SRC $BACKUP_DIR/$DST
        fi
    done
}

remove_parents() {
    SRC=$1
    DST=$2

    # use $SRC to keep track of how many directories to remove
    while [ "$(echo $SRC | grep "/")" ]; do
        SRC=$(dirname $SRC)
        DST=$(dirname $DST)
        if [ -e "$DST" ]; then
            rmdir -v $DST
        fi
    done
}

delete() {
    for (( i = 0; i < $FSIZE; i++ )); do
        SRC=${FILES[2 * $i]}
        DST=${FILES[2 * $i + 1]}

        if [ -L "$DST" ]; then
            rm -v $DST
        fi
        remove_parents $SRC $DST
    done
}

list() {
    LIGHT_RED=$(tput bold ; tput setaf 1)
    LIGHT_GREEN=$(tput bold ; tput setaf 2)
    LIGHT_BLUE=$(tput bold ; tput setaf 4)
    LIGHT_CYAN=$(tput bold ; tput setaf 6)
    RESET=$(tput sgr0)

    for (( i = 0; i < $FSIZE; i++ )); do
        DST=${FILES[2 * $i + 1]}

        if [ -L "$DST" ]; then
            echo -e "[${LIGHT_CYAN}LINK${RESET}]\t$DST"
        elif [ -f "$DST" ]; then
            echo -e "[${LIGHT_GREEN}FILE${RESET}]\t$DST"
        elif [ -d "$DST" ]; then
            echo -e "[${LIGHT_BLUE}DIR ${RESET}]\t$DST"
        elif [ ! -e "$DST" ]; then
            echo -e "[${LIGHT_RED}NONE${RESET}]\t$DST"
        else
            echo -e "[OTHER]\t$DST"
        fi
    done
}

restore() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo >&2 "$(basename $0): error: backup directory does not exist"
        exit 1
    fi

    for (( i = 0; i < $FSIZE; i++ )); do
        SRC=${FILES[2 * $i]}
        DST=${FILES[2 * $i + 1]}

        if [ -e "$DST" ]; then
            rm -rf $DST
        fi
        if [ -e "$BACKUP_DIR/$SRC" ]; then
            if [ "$(echo $SRC | grep "/")" ]; then
                mkdir -p $(dirname $DST)
            fi
            mv -v $BACKUP_DIR/$SRC $DST
        fi
        remove_parents $SRC $BACKUP_DIR/$SRC
    done

    if [ "$(ls -A $BACKUP_DIR)" ]; then
        echo >&2 "$(basename $0): warning: backup directory not empty; not removing"
    else
        rmdir -v $BACKUP_DIR
    fi
}

write() {
    for (( i = 0; i < $FSIZE; i++ )); do
        SRC=$SOURCE_DIR/${FILES[2 * $i]}
        DST=${FILES[2 * $i + 1]}

        if [ ! -e "$DST" -o "$FFLAG" = 1 ]; then
            if [ -e "$DST" ]; then
                rm -rf $DST
            elif [ "$(echo $SRC | grep "/")" ]; then
                mkdir -p $(dirname $DST)
            fi
            ln -vfs $SRC $DST
        else
            echo >&2 "$(basename $0): warning: \`$DST' already exists"
        fi
    done
}

usage() {
    echo -e >&2 "usage: $(basename $0) [-bdhrw] [-f]"
    echo -e >&2 "\t-b  backup existing files"
    echo -e >&2 "\t-d  delete symlinks"
    echo -e >&2 "\t-f  force removal of existing files"
    echo -e >&2 "\t-r  restore from backup"
    echo -e >&2 "\t-w  write symlinks"

    echo -e >&2 "\n\t-h  display this help and exit"

    echo -e >&2 "\nnote: files to be managed must be defined in FILES array"
    exit 1
}

check_array() {
    if (( ${#FILES[@]} % 2 != 0 )); then
        echo >&2 "$(basename $0): error: FILES array is missing a source or destination"
        exit 1
    fi
}

### main
check_array

while getopts bdfhrw OPT; do
    case "$OPT" in
        h)  usage;;
        b)  BFLAG=1;;
        d)  DFLAG=1;;
        f)  FFLAG=1;;
        r)  RFLAG=1;;
        w)  WFLAG=1;;
        ?)  usage;;
    esac
done

if [ "$BFLAG" = 1 ]; then
    backup
elif [ "$DFLAG" = 1 ]; then
    delete
elif [ "$RFLAG" = 1 ]; then
    restore
elif [ "$WFLAG" = 1 ]; then
    write
else
    list
fi
