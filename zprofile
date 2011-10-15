# ~/.zprofile - for login shells
# sourced by zsh login shells

# set up session wide settings
if [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
fi
