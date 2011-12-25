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

[link.sh]:http://github.com/acx0/link.sh
[Vim]:http://vim.org
[Vundle]:http://github.com/gmarik/vundle
