#!/bin/bash

# Get cliphist list and show with rofi
selected=$(cliphist list | rofi -dmenu -theme ~/.config/rofi/launchers/clip-theme.rasi -p "Clipboard")

# If something was selected, decode and copy to clipboard
[ -n "$selected" ] && echo "$selected" | cliphist decode | wl-copy

