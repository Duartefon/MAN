#!/bin/sh
printf '\033c\033]0;%s\a' MAN
base_path="$(dirname "$(realpath "$0")")"
"$base_path/MAN.x86_64" "$@"
