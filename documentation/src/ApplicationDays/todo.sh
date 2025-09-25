#!/bin/bash
# todo - Simple todo list manager

TODO_FILE="$HOME/.todos"

if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MAC=true
else
    IS_MAC=false
fi

function add_todo() {           # with 'function'
    echo "[ ] $*" >> "$TODO_FILE"
    echo "Added: $*"
}

show_todos() {                  # or without is the same
    cat -n "$TODO_FILE" | sed 's/\[ \]/ ⬜/g' | sed 's/\[x\]/ ✅/g'
}

complete_todo() {
    for num in "$@"; do
        if [[ $IS_MAC == true ]]; then
            sed -i "" "${num}s/\[ \]/[x]/" "$TODO_FILE"
        else
            sed -i "${num}s/\[ \]/[x]/" "$TODO_FILE"
        fi
        echo "Completed task #$num"
    done
}

cleanup() {
    local count=$(grep -c "\[x\]" "$TODO_FILE")
    grep -v "\[x\]" "$TODO_FILE" > temp
    mv temp "$TODO_FILE"
    echo "Cleaned up $count completed tasks"
}

remove_todo() {
    if [[ $IS_MAC == true ]]; then
        sed -i "" "${1}d" "$TODO_FILE"
    else
        sed -i "${1}d" "$TODO_FILE"
    fi
    echo "Removed task #$1"
}

# only create the file if it isn't present
if [[ ! -e $TODO_FILE ]]; then
    touch $TODO_FILE
fi

case "$1" in
    add)    shift; add_todo "$@" ;;
    done)   shift; complete_todo "$@" ;;
    rm)     remove_todo "$2" ;;
    clean)  cleanup ;;
    *)      show_todos ;;
esac