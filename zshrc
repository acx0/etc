# ~/.zshrc

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt APPEND_HISTORY
setopt AUTO_CD
setopt AUTO_PUSHD
#setopt CORRECT_ALL
setopt EXTENDED_GLOB
setopt EXTENDED_HISTORY
setopt HASH_LIST_ALL
#setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt MENU_COMPLETE
#setopt PROMPT_SUBST
setopt SHARE_HISTORY

unsetopt BEEP
#unsetopt CHECK_JOBS
unsetopt HUP

if [ -f "$HOME/.shellrc" ]; then
    source "$HOME/.shellrc"
fi

# make zsh's 'time' output similar to bash's
TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# use vi editing mode
bindkey -v

# use jk to exit insert mode
bindkey -M viins 'jk' vi-cmd-mode

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

# search history based on first word in buffer
bindkey -M viins '^J' history-search-forward
bindkey -M viins '^K' history-search-backward

# leave menu selection and accept entire command line after '^M'
# default behaviour only leaves menuselect; doesn't execute command line
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line

# display current vi-mode in prompt string
VI_MODE="i"
function zle-line-init zle-keymap-select {
    VI_MODE="${${KEYMAP/vicmd/c}/(main|viins)/i}"
    if [ "$VI_MODE" = "i" ]; then
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
#zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' expand prefix
#zstyle ':completion:*' format 'completing: %d'
#zstyle ':completion:*' group-name ''    # organize completion list in groups
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%Sat %p: hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
#zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'   # with substring matching
zstyle ':completion:*' menu select=1    # shows highlight for selected completion item
zstyle ':completion:*' original true    # offer original string as possible match
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%Sscrolling active: current selection at %p%s'
zstyle ':completion:*' use-cache on
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit && compinit

# enable zsh colours
autoload -U colors && colors
