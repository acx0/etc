# ~/.profile - for login shells
# used as shell agnostic file for session wide settings since some login
# managers don't source ~/.bash_profile or ~/.zprofile.
# note: file not read by bash if ~/.bash_profile or ~/.bash_login exists

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export EDITOR=vim
export BROWSER=firefox
export PAGER=sensible-pager # tmp: until ranger 'sensible-paper' bug fixed

# add ~/bin to PATH if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# add super-user binaries to PATH
PATH="$PATH:/sbin:/usr/sbin"
