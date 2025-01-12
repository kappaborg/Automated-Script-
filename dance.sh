#!/bin/bash

show_menu() {
    clear
    echo "#############################################"
    echo "#            Welcome to Word Dance          #"
    echo "#############################################"
    echo
    echo "1. Start Word Dance"
    echo "2. Exit"
    echo
    echo "Enter your choice:"
}
get_inputs() {
    clear
    echo "#############################################"
    echo "#           Configure Word Dance            #"
    echo "#############################################"
    echo
    read -p "Enter the word to dance: " word
    if [ -z "$word" ]; then
        echo "Error: Word cannot be empty. Returning to menu."
        sleep 2
        return 1
    fi

    read -p "Enter the duration (in seconds): " duration
    if ! [[ "$duration" =~ ^[0-9]+$ ]]; then
        echo "Error: Duration must be a positive integer. Returning to menu."
        sleep 2
        return 1
    fi

    return 0
}

run_dance() {
    local word=$1
    local duration=$2
    local colors=(31 32 33 34 35 36 37) 
    local cols=$(tput cols) # Terminal width
    local lines=$(tput lines)           # Terminal height
    local delay=0.05                    

    local x=1  
    local y=1  
    local dx=1 
    local dy=1 
    local word_len=${#word} 

    trap 'tput cnorm; clear; exit' SIGINT SIGTERM 
    tput civis 

    local start_time=$(date +%s) 

    while true; do
        local current_time=$(date +%s)
        local elapsed_time=$((current_time - start_time))

        if [ "$elapsed_time" -ge "$duration" ]; then
            tput cnorm 
            clear
            echo "Simulation finished after $duration seconds!"
            sleep 2
            return
        fi

        tput cup $y $x
        echo -ne ""

        x=$((x + dx))
        y=$((y + dy))

        if [ "$x" -le 1 ] || [ "$x" -ge $((cols - word_len)) ]; then
            dx=$((dx * -1))
        fi
        if [ "$y" -le 1 ] || [ "$y" -ge "$lines" ]; then
            dy=$((dy * -1))
        fi

        local color=${colors[RANDOM % ${#colors[@]}]}

        tput cup $y $x
        echo -ne "\033[1;${color}m${word}\033[0m"

        sleep $delay 
    done
}

while true; do
    show_menu
    read -r choice
    case $choice in
        1)
            if get_inputs; then
                clear
                run_dance "$word" "$duration"
            fi
            ;;
        2)
            clear
            echo "Exiting Word Dance. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            sleep 2
            ;;
    esac
done