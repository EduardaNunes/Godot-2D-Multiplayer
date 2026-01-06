#!/bin/sh
printf '\033c\033]0;%s\a' DCC148 - Protótipo Multiplayer
base_path="$(dirname "$(realpath "$0")")"
"$base_path/DCC148 - Protótipo Multiplayer.x86_64" "$@"
