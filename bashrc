# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# see ~/.inputrc for more PS1 configuration
PS1='\u@\h:\W \$ '

HISTCONTROL=ignoreboth  # ignore lines starting with a space and consecutive duplicates
HISTSIZE=10000

shopt -s histappend   # append to the history file, don't overwrite it
shopt -s checkwinsize # update the values of LINES and COLUMNS after each command if altered
shopt -s no_empty_cmd_completion

if [[ "$BASH_VERSINFO" -gt 3 ]]; then
    shopt -s autocd   # cd by typing name of directory
fi

if [[ -f "$HOME/.shellrc" ]]; then
    source "$HOME/.shellrc"
fi

# enable bash completion
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

if [[ -d "$HOME/.vim/plugged/fzf/shell" ]]; then
    source "$HOME/.vim/plugged/fzf/shell/completion.bash"
    source "$HOME/.vim/plugged/fzf/shell/key-bindings.bash"
fi
