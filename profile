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

# first path in GOPATH is used as target for `go get` downloads
export GOPATH="$HOME/src/go-dist:$HOME/src/go:$HOME/src/server/go"
export PATH
