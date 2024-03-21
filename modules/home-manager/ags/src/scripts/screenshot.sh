#!/usr/bin/env bash

function restore() {
  hyprctl reload &> /dev/null
}

hyprctl --batch "keyword decoration:blur:enabled 0; keyword decoration:active_opacity 1; keyword decoration:inactive_opacity 1" &> /dev/null

workspaces="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
windows="$(hyprctl clients -j | jq -r --argjson workspaces "$workspaces" 'map(select([.workspace.id] | inside($workspaces)))')"
geometry=$(echo "$windows" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)

if [[ "$?" -ne "0" ]]; then
  restore
  exit 1
fi

if [[ -n $XDG_PICTURES_DIR ]]; then
  target_dir=$XDG_PICTURES_DIR/screenshots
  mkdir -p $target_dir
else
  target_dir=$HOME
fi

file_name="screenshot_$(date '+%Y-%m-%d__%H-%M-%S.png')"

file="${target_dir}/${file_name}"

grim -g "$geometry" "$file"

restore

echo "$file"