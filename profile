# ~/.profile - for login shells
# used as shell agnostic file for session wide settings since some login
# managers don't source ~/.bash_profile or ~/.zprofile.
# note: file not read by bash if ~/.bash_profile or ~/.bash_login exists

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export EDITOR=vim
export BROWSER=firefox

PATH="$HOME/bin:$PATH"
PATH="$PATH:/sbin:/usr/sbin"    # add super-user binaries to PATH
PATH="$PATH:/usr/local/go/bin"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$PATH:$HOME/bin-work"

# give vim-plug managed fzf preference over any system version
PATH="$HOME/.vim/plugged/fzf/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

# first path in GOPATH is used as target for `go get` downloads
export GOPATH="$HOME/var/go-dist:$HOME/src/go"

if command -v fdfind >/dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f'
fi

if [[ $OSTYPE == "darwin"* ]]; then
    export HOMEBREW_NO_ANALYTICS=1

    # see `LESS=+/LSCOLORS man ls`
    export CLICOLOR=1
    # mimic GNU dircolors $LS_COLORS for simple filetypes
    #   note: combining `dA` seems to yield `DA` (compare with `dx`)
    export LSCOLORS="ExGxfxdxCxDADAxbadacec"

    PATH="$PATH:/usr/local/sbin"            # brew installs certain tools here
    PATH="/usr/local/opt/libpq/bin:$PATH"   # for postgres binaries
fi

export PATH
