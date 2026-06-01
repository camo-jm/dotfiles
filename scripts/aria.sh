#! /usr/bin/env sh

aria2c -x 4 -s 4 -j 1 -c -d "${2:-$HOME/Downloads/ariascript}" -i "$1" & disown
