#!/bin/bash

# Open the Cursor app (adjust the path if necessary)
open -a "Cursor"

# Wait for the application to launch (optional)
sleep 2

# Define the file name
file_name="word_dance.sh"

# Create an empty file (if it doesn't exist)
touch "$file_name"

# Given code (or paragraph) to write to the file
code='
#!/bin/bash

# Function to display the menu UI
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

# Function to prompt for inputs
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

# Function to run the dance with smooth animation
run_dance() {
    local word=$1
    local duration=$2
    local colors=(31 32 33 34 35 36 37) # Array of color codes
    local cols=$(tput cols) # Terminal width
    local lines=$(tput lines)           # Terminal height
    local delay=0.05                    # Shorter delay for smoother animation

    local x=1  # Initial x position
    local y=1  # Initial y position
    local dx=1 # Change in x (direction)
    local dy=1 # Change in y (direction)
    local word_len=${#word} # Length of the word

    trap "tput cnorm; clear; exit" SIGINT SIGTERM # Clean up on exit
    tput civis # Hide cursor

    local start_time=$(date +%s) # Record the start time

    while true; do
        local current_time=$(date +%s)
        local elapsed_time=$((current_time - start_time))

        # Exit if the elapsed time exceeds the duration
        if [ "$elapsed_time" -ge "$duration" ]; then
            tput cnorm # Restore cursor
            clear
            echo "Simulation finished after $duration seconds!"
            sleep 2
            return
        fi

        # Clear the current position
        tput cup $y $x
        echo -ne ""

        # Update position with direction
        x=$((x + dx))
        y=$((y + dy))

        # Reverse direction if the word hits the edges
        if [ "$x" -le 1 ] || [ "$x" -ge $((cols - word_len)) ]; then
            dx=$((dx * -1))
        fi
        if [ "$y" -le 1 ] || [ "$y" -ge "$lines" ]; then
            dy=$((dy * -1))
        fi

        # Pick a random color
        local color=${colors[RANDOM % ${#colors[@]}]}

        # Draw the word at the new position
        tput cup $y $x
        echo -ne "\033[1;${color}m${word}\033[0m"

        sleep $delay # Wait for a short moment
    done
}

# Main loop for the menu
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
'

# Function to simulate typing animation in the terminal (word by word, without output)
type_animation_silent() {
    text="$1"
    while IFS= read -r -n 1 char; do
        case "$char" in
            " " | "." | "," | "!" | "?" | ";" | ":" | "(" | ")" | "'" | '"' )
                sleep $(( RANDOM % 3 + 3 ))/100.0  # Longer pause
                ;;
            *)
                sleep $(( RANDOM % 4 + 1 ))/100.0 # Shorter pause with slight variation
                ;;
        esac
        echo -n "$char" > /dev/null
    done <<< "$text"
}

# Function to simulate human typing in Cursor app
type_in_cursor() {
    text="$1"
    osascript -e 'tell application "Cursor" to activate' # Activate Cursor Application
    sleep 0.5 # slight delay before typing
    IFS=$'\n'
    for line in $text; do
        IFS=' '
         for word in $line; do
            for (( i=0; i<${#word}; i++ )); do
                 char="${word:i:1}"
                  osascript -e "tell application \"System Events\" to keystroke \"$char\""
                     case "$char" in
                      " " | "." | "," | "!" | "?" | ";" | ":" | "(" | ")" | "'" | '"' )
                           sleep $(( RANDOM % 3 + 3 ))/100.0  # Longer pause
                           ;;
                       *)
                          sleep $(( RANDOM % 4 + 1 ))/100.0 # Shorter pause with slight variation
                         ;;
                    esac
             done
             osascript -e "tell application \"System Events\" to keystroke \" \"" # space
               sleep $(( RANDOM % 4 + 2 ))/100.0 # slight word delay
           done
           osascript -e "tell application \"System Events\" to key code 36" # new line
           sleep $(( RANDOM % 4 + 3 ))/100.0 # slight line delay
    done
}

# Write code to the file with silent typing animation (word by word)
echo "Writing code to the file..."
type_animation_silent "$code" > "$file_name"

# Open the file in Cursor
open -a "Cursor" "$file_name"
sleep 2
# Simulate writing in cursor
echo "Typing in the Cursor..."
type_in_cursor "$code"

# Optionally, print a message after writing is complete
echo -e "\nFile '$file_name' has been created, code has been written, and typed into the editor."

# Execute the code in the file (if it's executable and valid)
chmod +x "$file_name"  # Make sure the file is executable
echo "Executing the script..."
./"$file_name"