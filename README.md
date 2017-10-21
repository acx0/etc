## Installation
Clone the repository and initialize the submodules:

    git clone git://github.com/acx0/etc.git ~/etc
    cd ~/etc
    git submodule update --init

## Setup
[link.sh] is used to link the dotfiles to their native locations.

## Vim Setup
[Vim] plugin files are not tracked since [Vundle] is used to download and
update them.

Install plugins using the `BundleInstall` Vim command, and update them using
`BundleInstall!`:

    vim -c BundleInstall
    :BundleInstall!

[YouCompleteMe] plugin installation requires additional step after `BundleInstall`:

    sudo aptitude install build-essential cmake python-dev python3-dev
    cd ~/.vim/bundle/YouCompleteMe
    /usr/bin/python3 install.py --clang-completer

[link.sh]:https://github.com/acx0/link.sh
[Vim]:http://vim.org
[Vundle]:https://github.com/gmarik/vundle
[YouCompleteMe]:https://github.com/Valloric/YouCompleteMe
