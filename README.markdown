## Installation

    git clone git://github.com/acx0/etc.git

Configurations files may be placed in a location other than `~/etc`. To do so,
rename the folder and update the value of `SOURCE_DIR` in `link.sh` to reflect
this change.

Run the provided shell script without any arguments (or with the `-l` flag) to
see the current status of the files defined in `HOME_DIR_FILES` and
`CONFIG_DIR_FILES`:

    ./link.sh

If the script shows existing files, back them up with:

    ./link.sh -b

The default backup directory is `~/dotfiles.bak`; modify the value of
`BACKUP_DIR` to change this.

To write the symlinks for files that don't exist, use the `-w` flag, otherwise,
force write them by adding the `-f` flag:

    ./link.sh -w
    ./link.sh -wf

To restore the backed up files, use:

    ./link.sh -r

Use the `-h` flag to see an overview of all available options:

    ./link.sh -h

## Vim Setup
Instead of managing [Vim] plugins as git submodules, [Vundle] is used to
download and update them. For this reason the `vim/bundle` folder is ignored in
the `.gitignore` file.

Initialize and update [Vundle] submodule:

    cd ~/etc
    git submodule init
    git submodule update

Install plugins using `BundleInstall` command:

    vim -c BundleInstall

[Vim]:http://vim.org
[Vundle]:http://github.com/gmarik/vundle
