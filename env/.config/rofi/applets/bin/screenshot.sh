#!/usr/bin/env bash

# Import Current Theme
theme="$HOME/.config/rofi/applets/shared/theme.rasi"

# Theme Elements
prompt='Screenshot'
mesg="DIR: ~/Screenshots"

list_col='1'
list_row='5'
win_width='520px'

# Options
layout=$(grep 'USE_ICON' ${theme} | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1=" Capture Desktop"
  option_2=" Capture Area"
  option_3=" Capture Window"
  option_4=" Capture in 5s"
  option_5=" Capture in 10s"
else
  option_1=""
  option_2=""
  option_3=""
  option_4=""
  option_5=""
fi

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
  }

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=$(date +%Y-%m-%d-%H-%M-%S)
dir="/home/madyn/Screenshots"
file="Screenshot_${time}.png"

if [[ ! -d "$dir" ]]; then
  mkdir -p "$dir"
fi

# Select window
select_window() {
  windows=$(hyprctl clients -j | jq -r '.[] | "[\(.workspace.id)] \(.title)"')
  selected_window=$(echo "$windows" | rofi -dmenu -i -p "Select Window" -theme ~/dots/.config/rofi/launchers/type-6/style-10.rasi)

  if [[ -n "$selected_window" ]]; then
    window_title=$(echo "$selected_window" | sed -E 's/^\[[0-9]+\] //')
    window_geometry=$(hyprctl clients -j | jq -r --arg title "$window_title" '.[] | select(.title == $title) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    hyprctl clients -j | jq -r --arg title "$window_title" '.[] | select(.title == $title) | .address' | xargs -I {} hyprctl dispatch focuswindow address:{} > /dev/null 2>&1
    echo "$window_geometry"
  else
    echo ""
  fi
}

# notify and view screenshot
notify_view() {
  local notify_cmd_shot='dunstify -u low --replace=699'
  $notify_cmd_shot "Copied to clipboard."
  imv "${dir}/${file}"
  if [[ -e "$dir/$file" ]]; then
    $notify_cmd_shot "Screenshot Saved."
  else
    $notify_cmd_shot "Screenshot Deleted."
  fi
}

# Copy screenshot to clipboard
copy_shot () {
  tee "$file" | wl-copy
}

# countdown
countdown () {
  for sec in $(seq $1 -1 1); do
    dunstify -t 1000 --replace=699 "Taking shot in : $sec"
    sleep 1
  done
}

# take shots
shotnow() {
  # Fetch the active monitor based on mouse position
  active_output=$(hyprctl monitors -j | jq -r '
  .[] | select(.focused == true) | "\(.x),\(.y) \(.width)x\(.height)"')

  if [[ -z "$active_output" ]]; then
    mouse_position=$(hyprctl cursorpos)
    mouse_x=$(echo "$mouse_position" | cut -d ',' -f 1)
    mouse_y=$(echo "$mouse_position" | cut -d ',' -f 2)

    active_output=$(hyprctl monitors -j | jq -r --arg mx "$mouse_x" --arg my "$mouse_y" '
    .[] | select((.x <= ($mx | tonumber)) and (.y <= ($my | tonumber)) and 
    (.x + .width > ($mx | tonumber)) and (.y + .height > ($my | tonumber))) |
      "\(.x),\(.y) \(.width)x\(.height)"')
  fi

  if [[ -n "$active_output" ]]; then
    cd "$dir" && sleep 0.5 && grim -g "$active_output" - | copy_shot
    sleep 0.5 && notify_view
  else
    dunstify -u critical "Error: Could not detect the active monitor."
  fi
}


shot5 () {
  countdown '5'
  shotnow
}

shot10 () {
  countdown '10'
  shotnow
}

shotwin() {
  window_geometry=$(select_window)
  if [[ -n "$window_geometry" ]]; then
    cd "$dir" && sleep 0.5 && grim -g "$window_geometry" - | copy_shot 
    notify_view
  else
    dunstify -u low --replace=699 "No window selected."
  fi
}

shotarea () {
  cd "$dir" && grim -g "$(slurp)" - | copy_shot
  notify_view
}

# Execute Command
run_cmd() {
  case "$1" in
    --opt1) shotnow ;;
    --opt2) shotarea ;;
    --opt3) shotwin ;;
    --opt4) shot5 ;;
    --opt5) shot10 ;;
  esac
}

# Actions
chosen=$(run_rofi)
case $chosen in
  $option_1) run_cmd --opt1 ;;
  $option_2) run_cmd --opt2 ;;
  $option_3) run_cmd --opt3 ;;
  $option_4) run_cmd --opt4 ;;
  $option_5) run_cmd --opt5 ;;
esac

