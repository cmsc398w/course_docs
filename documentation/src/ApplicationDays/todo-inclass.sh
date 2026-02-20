#!/bin/bash
# todo - Simple todo list manager

TODO_FILE="$HOME/.todos"

add_todo() {
    echo "[ ] $*" >> $TODO_FILE
	echo "Added: $*"
}
show_todos() {
	cat -n "$TODO_FILE"
}

complete_todo() {
	sed -i "" "${1}s/\[ \]/\[x\]/" "$TODO_FILE"
	echo "Completed task ${1}"
}

remove_todo() {
	sed -i "" "${1}d" "$TODO_FILE"
	echo "Removed task #$1"
}

cleanup() {
	local count=$(grep -c "\[x\]" "$TODO_FILE")
	grep -v "\[x\]" "$TODO_FILE" > temp
	mv temp $TODO_FILE
	echo "Cleaned up $count tasks"
}


touch $TODO_FILE

case "$1" in
    add)    shift; add_todo "$@" ;;
	done) shift; complete_todo "$@" ;;
	rm) remove_todo "$2" ;;
	clean) cleanup ;;
	*) show_todos ;;
    # add other cases here...
esac
