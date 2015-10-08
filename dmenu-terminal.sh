#!/bin/sh

# use the terminal emulator passed-in, or fall back to urxvt or xterm if installed
terminal="$(command -v urxvt)"

# make sure dmenu is installed
if [ ! -x "$(command -v dmenu)" ]; then
  echo "Requires dmenu"
  exit 69
fi

#FIXME: search multiple directories
choice=$(dmenu_path_c | dmenu $@)

if [ -x "$(command -v $choice)" ]; then
  $terminal -e $choice
fi
