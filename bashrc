# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

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

# see ~/.inputrc for more PS1 configuration
PROMPT_COMMAND=custom_bash_prompt
custom_bash_prompt() {
    # note: status capture must occur before anything else has a chance to overwrite it
    #   - using `local` here will mask return value
    __last_exit_status="$(get_last_exit_status)"

    PS1='\u@\h:\W '
    PS1+='$(get_git_branch)'
    PS1+='$(get_git_stash_count)'
    PS1+='$(get_python_venv)'
    PS1+='$__last_exit_status'
    PS1+='\$ '
}

# enable bash completion
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

if [[ -d "$HOME/etc/fzf" ]]; then
    source "$HOME/etc/fzf/completion.bash"
    source "$HOME/etc/fzf/key-bindings.bash"
fi
