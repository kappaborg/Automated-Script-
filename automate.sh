#!/bin/bash
open -a "Cursor"
sleep 2
# Defining file name
file_name="automatedSC.sh"
# Create an empty file (if it doesn't exist)
touch "$file_name"
code='
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
'
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
# Here we are humanizing the typing animation
type_in_cursor() {
    text="$1"
    osascript -e 'tell application "Cursor" to activate' 
    sleep 0.5 
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

echo "Writing code to the file..."
type_animation_silent "$code" > "$file_name"

open -a "Cursor" "$file_name"
sleep 2
echo "Typing in the Cursor..."
type_in_cursor "$code"

echo -e "\nFile '$file_name' has been created, code has been written, and typed into the editor."
#Making our script executable
chmod +x "$file_name" 
echo "Executing the script..."
./"$file_name"