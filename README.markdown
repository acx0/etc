## Installation

    git clone git://github.com/acx0/etc.git

Configurations files may be placed in a location other than `~/etc`. To do so,
rename the folder and update the value of `SOURCE_DIR` in `link.sh` to reflect
this change.

To setup the symlinks, run the provided shell script:

    ./link.sh

If the script warns of existing files, back them up with:

    ./link -b

Then force write the symlinks using:

    ./link -f

Use the `-h` flag to see an overview of all available options:

    ./link -h

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
