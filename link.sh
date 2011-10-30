#!/bin/bash

### configurable settings
SOURCE_DIR=$HOME/etc
BACKUP_DIR=$SOURCE_DIR.bak

# files to be managed
#   index 2k is key (source)
#   index 2k+1 is value (destination)
FILES=(
    "awesome" "$HOME/.config/awesome"
    "bash_profile" "$HOME/.bash_profile"
    "bashrc" "$HOME/.bashrc"
    "dircolors" "$HOME/.dircolors"
    "emacs" "$HOME/.emacs"
    "gitconfig" "$HOME/.gitconfig"
    "gtkrc-2.0" "$HOME/.gtkrc-2.0"
    "inputrc" "$HOME/.inputrc"
    "pentadactylrc" "$HOME/.pentadactylrc"
    "profile" "$HOME/.profile"
    "screenrc" "$HOME/.screenrc"
    "shellrc" "$HOME/.shellrc"
    "ssh/config" "$HOME/.ssh/config"
    "tmux.conf" "$HOME/.tmux.conf"
    "vim" "$HOME/.vim"
    "vimrc" "$HOME/.vimrc"
    "Xcolours" "$HOME/.Xcolours"
    "xmodmaprc" "$HOME/.xmodmaprc"
    "Xresources" "$HOME/.Xresources"
    "xsession" "$HOME/.xsession"
    "zprofile" "$HOME/.zprofile"
    "zshrc" "$HOME/.zshrc"
)

### functions
FSIZE=$(( ${#FILES[@]} / 2 ))
declare -a ARG_FILES

OPTIONS=0
ALL=1

FFLAG=0
BFLAG=0
DFLAG=0
RFLAG=0
WFLAG=0

check_options() {
    if [[ $OPTIONS == 1 ]]; then
        echo >&2 "$(basename $0): error: too many options specified"
        usage
    fi
}

check_arg_files() {
    if [[ -n $@ ]]; then
        read -ra ARG_FILES <<< "$@"
        FSIZE=$(( ${#ARG_FILES[@]} ))
        ALL=0
    fi
}

get_value() {
    KEY=$1

    for (( i = 0; i < ${#FILES[@]}; i++ )); do
        if [[ $KEY == ${FILES[2 * $i]} ]]; then
            echo ${FILES[2 * $i + 1]}
            return 0
        fi
    done

    echo >&2 "$(basename $0): error: key \`$KEY' not found"
    return 1
}

backup() {
    if [[ -e $BACKUP_DIR && $FFLAG == 0 ]]; then
        echo >&2 "$(basename $0): error: backup directory already exists"
        exit 1
    else
        if [[ -e $BACKUP_DIR ]]; then
            rm -rf $BACKUP_DIR
        fi
        mkdir -v $BACKUP_DIR
    fi

    for (( i = 0; i < $FSIZE; i++ )); do
        # $SRC and $DST are reversed since we're backing up
        SRC=${FILES[2 * $i + 1]}
        DST=${FILES[2 * $i]}

        if [[ $(echo $DST | grep "/") && -e $SRC ]]; then
            mkdir -p $BACKUP_DIR/$(dirname $DST)
        fi
        if [[ -e $SRC ]]; then
            cp -vrd $SRC $BACKUP_DIR/$DST
        fi
    done
}

remove_parents() {
    SRC=$1
    DST=$2

    # use $SRC to keep track of how many directories to remove
    while [[ $(echo $SRC | grep "/") ]]; do
        SRC=$(dirname $SRC)
        DST=$(dirname $DST)
        if [[ -e $DST ]]; then
            rmdir -v $DST
        fi
    done
}

delete() {
    for (( i = 0; i < $FSIZE; i++ )); do
        if [[ $ALL == 1 ]]; then
            SRC=${FILES[2 * $i]}
            DST=${FILES[2 * $i + 1]}
        else
            SRC=${ARG_FILES[$i]}
            DST=$(get_value $SRC)
            if [[ $? == 1 ]]; then
                exit
            fi
        fi

        if [[ -L $DST ]]; then
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
        if [[ $ALL == 1 ]]; then
            DST=${FILES[2 * $i + 1]}
        else
            DST=$(get_value ${ARG_FILES[$i]})
            if [[ $? == 1 ]]; then
                exit
            fi
        fi

        if [[ -L $DST ]]; then
            echo -e "[${LIGHT_CYAN}LINK${RESET}]\t$DST"
        elif [[ -f $DST ]]; then
            echo -e "[${LIGHT_GREEN}FILE${RESET}]\t$DST"
        elif [[ -d $DST ]]; then
            echo -e "[${LIGHT_BLUE}DIR ${RESET}]\t$DST"
        elif [[ ! -e $DST ]]; then
            echo -e "[${LIGHT_RED}NONE${RESET}]\t$DST"
        else
            echo -e "[OTHER]\t$DST"
        fi
    done
}

restore() {
    if [[ ! -d $BACKUP_DIR ]]; then
        echo >&2 "$(basename $0): error: backup directory does not exist"
        exit 1
    fi

    for (( i = 0; i < $FSIZE; i++ )); do
        if [[ $ALL == 1 ]]; then
            SRC=${FILES[2 * $i]}
            DST=${FILES[2 * $i + 1]}
        else
            SRC=${ARG_FILES[$i]}
            DST=$(get_value $SRC)
            if [[ $? == 1 ]]; then
                exit
            fi
        fi

        if [[ -e $DST ]]; then
            rm -rf $DST
        fi
        if [[ -e $BACKUP_DIR/$SRC ]]; then
            if [[ $(echo $SRC | grep "/") ]]; then
                mkdir -p $(dirname $DST)
            fi
            if [[ $ALL == 1 ]]; then
                mv -v $BACKUP_DIR/$SRC $DST
            else
                cp -Pv $BACKUP_DIR/$SRC $DST
            fi
        fi
        remove_parents $SRC $BACKUP_DIR/$SRC
    done

    if [[ $ALL == 1 ]]; then
        if [[ $(ls -A $BACKUP_DIR) ]]; then
            echo >&2 "$(basename $0): warning: backup directory not empty; not removing"
        else
            rmdir -v $BACKUP_DIR
        fi
    fi
}

write() {
    for (( i = 0; i < $FSIZE; i++ )); do
        if [[ $ALL == 1 ]]; then
            SRC=$SOURCE_DIR/${FILES[2 * $i]}
            DST=${FILES[2 * $i + 1]}
        else
            SRC=$SOURCE_DIR/${ARG_FILES[$i]}
            DST=$(get_value ${ARG_FILES[$i]})
            if [[ $? == 1 ]]; then
                exit
            fi
        fi

        if [[ ! -e $DST || $FFLAG == 1 ]]; then
            if [[ -e $DST ]]; then
                rm -rf $DST
            elif [[ $(echo $SRC | grep "/") ]]; then
                mkdir -p $(dirname $DST)
            fi
            ln -vfs $SRC $DST
        else
            echo >&2 "$(basename $0): warning: \`$DST' already exists"
        fi
    done
}

usage() {
    echo -e >&2 "\nusage: $(basename $0) [-b] [-d [files]] [-r [files]] [-w [files]] [-f]"
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
        echo >&2 "$(basename $0): error: FILES array is missing a key or value"
        exit 1
    fi
}

### main
check_array

# process flags
while getopts bdfhrw OPT; do
    case "$OPT" in
        h)
            usage
            ;;
        f)
            FFLAG=1
            ;;
        b)
            check_options && OPTIONS=1
            BFLAG=1
            ;;
        d)
            check_options && OPTIONS=1
            DFLAG=1
            ;;
        r)
            check_options && OPTIONS=1
            RFLAG=1
            ;;
        w)
            check_options && OPTIONS=1
            WFLAG=1
            ;;
        ?)
            usage
            ;;
    esac
done

# process any optional arguments
shift $(( $OPTIND - 1 ))
check_arg_files "$@"

if [[ $BFLAG == 1 ]]; then
    backup
elif [[ $DFLAG == 1 ]]; then
    delete
elif [[ $RFLAG == 1 ]]; then
    restore
elif [[ $WFLAG == 1 ]]; then
    write
else
    list
fi
