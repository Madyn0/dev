#!/usr/bin/env bash

# Import Current Theme
theme="$HOME/.config/rofi/applets/shared/theme.rasi"

# Get Spotify status
status=$(playerctl --player=spotify status 2>/dev/null)
if [[ -z "$status" ]]; then
    prompt='Offline'
    mesg="Spotify is Offline"
else
    prompt=$(playerctl --player=spotify metadata artist)
    mesg="$(playerctl --player=spotify metadata title) :: $(playerctl --player=spotify metadata album)"
fi

list_col='1'
list_row='6'

# Options
layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    if [[ ${status} == "Playing" ]]; then
        option_1=" Pause"
    else
        option_1=" Play"
    fi
    option_2=" Stop"
    option_3=" Previous"
    option_4=" Next"
else
    if [[ ${status} == "Playing" ]]; then
        option_1=""
    else
        option_1=""
    fi
    option_2=""
    option_3=""
    option_4=""
fi

# Toggle Actions
active=''
urgent=''

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        ${active} ${urgent} \
        -markup-rows \
        -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        playerctl --player=spotify play-pause
    elif [[ "$1" == '--opt2' ]]; then
        playerctl --player=spotify stop
    elif [[ "$1" == '--opt3' ]]; then
        playerctl --player=spotify previous
    elif [[ "$1" == '--opt4' ]]; then
        playerctl --player=spotify next
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
        run_cmd --opt1
        ;;
    $option_2)
        run_cmd --opt2
        ;;
    $option_3)
        run_cmd --opt3
        ;;
    $option_4)
        run_cmd --opt4
        ;;
esac

