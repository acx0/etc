# ~/.bash_profile - for login shells
# sourced by bash login shells

# set up session wide settings
if [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
fi

if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi
