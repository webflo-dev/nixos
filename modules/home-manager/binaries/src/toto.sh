#!/bin/bash

function handle {
	echo "$@"
	# if [[ ${1:0:10} == "focusedmon" ]]; then
	# 	if [[ ${1:12:4} == "DP-1" ]]; then
	# 		hyprctl keyword general:gaps_out 20
	# 	else
	# 		hyprctl keyword general:gaps_out 30
	# 	fi
	# fi
}

socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
