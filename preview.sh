#!/usr/bin/env zsh
[[ -e "$1" ]] && file "$1" && exit 0
echo "$1"
