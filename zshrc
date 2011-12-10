# ~/.zshrc

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt APPEND_HISTORY
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt MENU_COMPLETE
#setopt PROMPT_SUBST
setopt SHARE_HISTORY

unsetopt BEEP
unsetopt CHECK_JOBS
unsetopt HUP

if [ -f "$HOME/.shellrc" ]; then
    source "$HOME/.shellrc"
fi

# use vi editing mode
bindkey -v

# break default vi insert mode character deletion behaviour (like 'set backspace+=start' in vim)
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
#bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line

# changing viins keymap's default '^W' binding seems to break vi-mode word delimiter settings
# the following somewhat fixes this
#autoload -U select-word-style && select-word-style bash

# enable backwards search in insert mode
bindkey -M viins '^R' history-incremental-search-backward

# set alternative keys for tab completion
bindkey -M viins '^N' menu-complete
bindkey -M viins '^P' reverse-menu-complete

# set alternative keys for history navigation
bindkey -M viins '^J' down-history
bindkey -M viins '^K' up-history

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
