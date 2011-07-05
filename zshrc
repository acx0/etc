# ~/.zshrc

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt APPEND_HISTORY
setopt AUTO_CD
setopt EXTENDED_GLOB
#setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt MENU_COMPLETE
#setopt PROMPT_SUBST
setopt SHARE_HISTORY

unsetopt BEEP

# use vi editing mode
bindkey -v

# display current vi-mode in prompt string
VI_MODE="i"
function zle-line-init zle-keymap-select {
    VI_MODE="${${KEYMAP/vicmd/c}/(main|viins)/i}"
    if [ $VI_MODE = "i" ]; then
        PROMPT="%n@%m:%1~ [%{$fg[red]%}${VI_MODE}%{$reset_color%}]$ "
    else
        PROMPT="%n@%m:%1~ [%{$fg[green]%}${VI_MODE}%{$reset_color%}]$ "
    fi
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

PROMPT="%n@%m:%1~ [%{$fg[red]%}${VI_MODE}%{$reset_color%}]$ "

# enable backwards search
bindkey '^R' history-incremental-search-backward

# completion settings
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' expand prefix
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle :compinstall filename '/home/sam/.zshrc'

autoload -Uz compinit && compinit

# enable zsh colours
autoload -U colors && colors

# enable colour support of ls and add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# aliases
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -A'
alias llha='ls -lhA'
alias l='ls -CF'

alias g='git'
alias tm='tmux'

# list processes which are using a deleted map file after a system update and need to be restarted
alias dm="sudo lsof | grep 'DEL.*lib' | cut -d ' ' -f 1 | sort -u"

# allows java graphical programs to run in tiling window managers by impersonating
# a window manager in JVM's list of allowed non-re-parenting window managers
if [ -x /usr/bin/wmname ]; then
    wmname LG3D 2> /dev/null
fi
