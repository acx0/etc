# ~/.zshrc

PS1='%n@%m:%1~ %{$VIMODE%}$ '

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt PROMPT_SUBST
setopt MENU_COMPLETE
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD
setopt EXTENDED_GLOB

unsetopt BEEP

# use Vi editing mode
bindkey -v

# update PS1 to show current Vi-mode
function zle-line-init zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/[$fg[green]c$reset_color]}/(main|viins)/[$fg[red]i$reset_color]}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# enable backwards search
bindkey '^R' history-incremental-search-backward

# completion settings
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' expand prefix
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle :compinstall filename '/home/sam/.zshrc'

autoload -Uz compinit
compinit

# enable zsh colours
autoload -U colors
colors

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

# temporary fix for screen's '$TERM too long' error for $TERM = 'rxvt-unicode-256color'
if [ "$TERM" = "rxvt-unicode-256color" ]; then
    screen () {
        ORIG=$TERM
        TERM=rxvt-unicode
        /usr/bin/screen
        TERM=$ORIG
    }
fi

# allows java graphical programs to run in tiling window managers by impersonating
# a window manager in JVM's list of allowed non-re-parenting window managers
if [ -x /usr/bin/wmname ]; then
    wmname LG3D
fi
