#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# The latest version of tmux will be installed in $HOME/local/bin.
# It is assumed that standard compilation tools (a C/C++ compiler with autoconf) are available. If git is installed it will be used instead of curl.

# Modified from https://gist.github.com/ryin/3106801 and https://gist.github.com/ryin/3106801 to use the latest version from github.


# exit on error
set -e

get_from_github () {
  if type "git" &> /dev/null ; then
    git clone https://github.com/$1/$1
  else
    curl -L https://github.com/$1/$1/archive/master.tar.gz -o $1.tar.gz
    tar xvzf $1.tar.gz
  fi
}

# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
get_from_github tmux
get_from_github libevent
curl -L ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz -o ncurses.tar.gz
tar xvzf ncurses.tar.gz

#########################
# configure and compile #
#########################

# get the number of CPU cores for build
if [ -f /proc/cpuinfo ]; then
    CPUS=`grep processor /proc/cpuinfo | wc -l`
else
    CPUS=2
fi

# libevent
cd $HOME/tmux_tmp/libevent*
./autogen.sh
./configure --prefix=$HOME/local --disable-shared
make -j$CPUS
make install

# ncurses
cd $HOME/tmux_tmp/ncurses-*
export CPPFLAGS="-P" # otherwise ncurse fails to build on gcc 5.x (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61832)
./configure --prefix=$HOME/local --without-debug --without-shared --without-normal --without-ada
make -j$CPUS
make install

# tmux
cd $HOME/tmux_tmp/tmux*
./autogen.sh
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib"
make -j$CPUS
cp tmux $HOME/local/bin

# cleanup
rm -rf $HOME/tmux_tmp

echo -e "\n\n$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH.\n"
# e.g. to export path
# export PATH=$PATH:/path/to/dir1

