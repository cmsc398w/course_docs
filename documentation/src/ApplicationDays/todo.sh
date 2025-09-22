#!/bin/bash
# todo - Simple todo list manager

TODO_FILE="$HOME/.todos"

add_todo() {
    echo "[ ] $*" >> "$TODO_FILE"
    echo "Added: $*"
}

show_todos() {
    cat -n "$TODO_FILE" | sed 's/\[ \]/ ⬜/g' | sed 's/\[x\]/ ✅/g'
}

complete_todo() {
    for num in "$@"; do
        sed -i "" "${num}s/\[ \]/[x]/" "$TODO_FILE"
        echo "Completed task #$num"
    done
}

cleanup() {
    local count=$(grep -c "\[x\]" "$TODO_FILE")
    grep -v "\[x\]" "$TODO_FILE" > temp && mv temp "$TODO_FILE"
    echo "Cleaned up $count completed tasks"
}

remove_todo() {
    sed -i "" "${1}d" "$TODO_FILE"
    echo "Removed task #$1"
}

touch $TODO_FILE

case "$1" in
    add)    shift; add_todo "$@" ;;
    done)   shift; complete_todo "$@" ;;
    rm)     remove_todo "$2" ;;
    clean)  cleanup ;;
    *)      show_todos ;;
esac