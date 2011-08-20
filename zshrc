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

# add ~/bin to PATH if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# add super-user binaries to PATH
PATH="$PATH:/sbin:/usr/sbin"

# use vi editing mode
bindkey -v

# break default vi insert mode character deletion behaviour (like 'set backspace+=start' in vim)
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line

# changing viins keymap's default '^W' binding seems to break vi-mode word delimiter settings
# the following somewhat fixes this
autoload -U select-word-style && select-word-style bash

# enable backwards search in insert mode
bindkey -M viins '^R' history-incremental-search-backward

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

# enable colours in less for man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# list processes which are using a deleted map file after a system update and need to be restarted
alias dm="sudo lsof | grep 'DEL.*lib' | cut -d ' ' -f 1 | sort -u"

# allows java graphical programs to run in tiling window managers by impersonating
# a window manager in JVM's list of allowed non-re-parenting window managers
if [ -x /usr/bin/wmname ]; then
    wmname LG3D 2> /dev/null
fi
