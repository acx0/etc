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

# give vim-plug managed fzf preference over any system version
PATH="$HOME/.vim/plugged/fzf/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

# first path in GOPATH is used as target for `go get` downloads
export GOPATH="$HOME/var/go-dist:$HOME/src/go"
export PATH

if command -v fdfind >/dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f'
fi
