## Installation
Clone the repository and initialize the submodules:

    git clone git://github.com/acx0/etc.git ~/etc
    cd ~/etc
    # public:
    git submodule update --init link.sh vim/vim-plug
    # all/private:
    git submodule update --init

## Setup
[link.sh] is used to link the dotfiles to their native locations.

## Vim Setup
[Vim] plugin files are not tracked since [vim-plug] is used to download and
update them. [vim-plug] itself is tracked as a git submodule.

Install plugins using the `PlugInstall` Vim command, and update them using
`PlugUpdate`:

    vim +PlugInstall

[vim-plug] will handle running any post-{install,update} commands required
for completing plugin setup. See `vimrc` for definition of hooks.

note: [YouCompleteMe] setup requires the following packages to be installed:

    # debian
    build-essential cmake python3-dev

    # add the following depending on which language servers are enabled
    default-jdk golang nodejs npm

[link.sh]:https://github.com/acx0/link.sh
[Vim]:https://vim.org
[YouCompleteMe]:https://github.com/Valloric/YouCompleteMe
[vim-plug]:https://github.com/junegunn/vim-plug
