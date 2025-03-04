# note: `lightdm` executes this with user's default shell, as set via `chsh`

xrdb -merge ~/.Xresources & # load X resource preferences
xmodmap ~/.xmodmaprc &      # load custom keyboard mappings
xsetroot -solid black &     # set root window background
xset r rate 250 40 &        # set keyboard delay and repeat rate
xset b off &                # disable system bell
xset dpms 0 300 600 &       # seconds before screen is in standby/suspend/off state

redshift -Pc ~/etc/redshift.conf &
nm-applet &
pasystray &
for bin in xfce4-power-manager blueman-applet; do
    if command -v $bin >/dev/null; then
        $bin &
    fi
done

epoch_ts_s=$(date +%s)

# ~/bin scripts
tp off &    # disable touchpad
sys-usage-ctl start &

# required for qtconfig to load gtk theme
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

awesomewm_log_dir=~/var/log/awesomewm
mkdir -p "$awesomewm_log_dir"
exec awesome >"${awesomewm_log_dir}/${epoch_ts_s}" 2>&1

#  vim: set ft=zsh :
