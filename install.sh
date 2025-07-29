#!/bin/bash

# Menu options
options=("wget" "git" "exit")
selected=0

# Hide cursor
tput civis

# Cleanup on exit
trap "tput cnorm; clear; exit" SIGINT

draw_menu() {
    clear
    echo "Select an option using ↑ ↓ and press Enter:"
    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            echo -e "> \e[1;36m${options[$i]}\e[0m"
        else
            echo "  ${options[$i]}"
        fi
    done
}

while true; do
    draw_menu

    # Read arrow keys
    IFS= read -rsn1 key
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 -t 0.1 key
        case "$key" in
            "[A") ((selected--));;
            "[B") ((selected++));;
        esac
    elif [[ $key == "" ]]; then
        break
    fi

    ((selected < 0)) && selected=$((${#options[@]} - 1))
    ((selected >= ${#options[@]})) && selected=0
done

tput cnorm
clear

# Perform actions
case "${options[$selected]}" in
    wget)
        echo "Running wget..."
        wget https://github.com/WinstonAlt/WinstonAlt.github.io/archive/refs/heads/main.zip -O WinstonAlt
        unzip WinstonAlt -x logo.png
        rm WinstonAlt
        echo "Done!"
        ;;
    git)
        echo "Cloning git repo..."
        git clone https://github.com/WinstonAlt/WinstonAlt.github.io.git
        echo "Done!"
        ;;
    exit)
        echo "Goodbye!"
        exit 0
        ;;
esac

