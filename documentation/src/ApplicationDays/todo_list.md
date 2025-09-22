# Application Day: ToDo List App

## Overview

Create a command-line todo list manager that allows users to add, view, complete, and manage their tasks. The application should store todos persistently.

## Requirements

Your todo manager must implement the following features:

1. **Add Tasks**: Allow users to add new todo items to their list
2. **Display Tasks**: Show all current todos with visual indicators for completion status
3. **Mark Complete**: Enable users to mark one or more tasks as completed
4. **Remove Tasks**: Allow deletion of specific tasks by their position/number
5. **Clean Up**: Provide functionality to remove all completed tasks at once
6. **Persistent Storage**: Store todos in a file that persists between sessions

### Technical Specifications

#### File Storage

- Store todos in a hidden file in the user's home directory (e.g., `~/.todos`)
- Use a simple text format with checkboxes: `[ ]` for incomplete, `[x]` for complete
- Each todo should be on its own line

#### Command Interface

Implement a command-line interface that supports:

- `todo add <task description>` - Add a new task
    - Useful tools: `echo`
- `todo done <task_number(s)>` - Mark task(s) as complete
  - Useful tools: `sed`
- `todo rm <task_number>` - Remove a specific task
  - Useful tools: `sed`
- `todo clean` - Remove all completed tasks
  - Useful tools: `grep`, input output redirection via `>` and `>>`
- `todo` (no arguments) - Display all current todos
  - Useful tools: `cat -n`

#### Display Format

- Show todos with line numbers
- Use visual indicators for task status:
  - Incomplete tasks: ⬜ (must use this emoji)
  - Completed tasks: ✅ (must use this emoji)
- Number each todo for easy reference

### Implementation Guidelines

```bash
# Add some tasks
$ todo add "Buy groceries"
Added: Buy groceries

$ todo add "Finish homework"
Added: Finish homework

$ todo add "Call dentist"
Added: Call dentist

# View current todos
$ todo
     1  ⬜ Buy groceries
     2  ⬜ Finish homework
     3  ⬜ Call dentist

# Mark task as complete
$ todo done 1
Completed task #1

# View updated list
$ todo
     1  ✅ Buy groceries
     2  ⬜ Finish homework
     3  ⬜ Call dentist

# Remove a task
$ todo rm 3
Removed task #3

# Clean up completed tasks
$ todo clean
Cleaned up 1 completed tasks
```

## Submission Requirements

- Source code consisting of runnable bash script called todo.sh.
- Your output must exactly match that of the example above.

## Evaluation Criteria (5 pts)

- 5 pts awarded per correct function.

## Starter Code

```bash
#!/bin/bash
# todo - Simple todo list manager

TODO_FILE="$HOME/.todos"

add_todo() {
    echo "IMPLEMENT ME!!"
}

# Write other functions here...

touch $TODO_FILE

case "$1" in
    add)    shift; add_todo "$@" ;;
    # add other cases here...
esac
```
