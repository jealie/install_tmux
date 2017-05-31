### Script for installing **tmux** where you don't have root access

It is assumed that standard compilation tools (a C/C++ compiler with autoconf) are available.

This script fetches and compiles the latest version of [**tmux**](https://github.com/tmux/tmux) from github, with its dependencies [**libevent**](https://github.com/libevent/libevent) and [**ncurses**](https://ftp.gnu.org/pub/gnu/ncurses/).

One-line install:

```bash
git clone https://github.com/jealie/install_tmux.git && ./install_tmux/install_tmux.sh
```

The latest version of tmux will be installed in `$HOME/local/bin/tmux`.

Note: if you are using this script to get the latest version of tmux on a fresh Ubuntu install, get the dependencies with:

`sudo apt-get install curl libtool pkg-config automake`
