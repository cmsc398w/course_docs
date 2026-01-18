---
theme: default
background: https://source.unsplash.com/collection/9948714/1920x1080
title: 'CMSC398W: Shell Application Day'
info: |
  ## Shell Application Day
  Building a Command-Line TODO List Manager
class: text-center
highlighter: shiki
drawings:
  persist: false
transition: slide-left
mdc: true
---

# CMSC398W

Application Day: Shell

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space to get started <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: center
---

# TODO List App

<v-clicks>

Today, we will create a **command-line todo list manager** that allows users to:
- ✅ Add tasks
- 👀 View tasks
- ✔️ Complete tasks
- 🗑️ Remove tasks
- 🧹 Clean up completed tasks

</v-clicks>

---
layout: two-cols
---

# Assignment Details

<v-clicks>

- **Due:** Saturday @ 11:59 PM
- **Time:** Should be completable in class
- **Grading:** Good-faith attempt

</v-clicks>

::right::

<div v-click>

## What You'll Build

A shell script (`todo.sh`) that manages a simple text-based todo list

**Format:**
- `[ ]` for incomplete tasks
- `[x]` for complete tasks

</div>

---
layout: cover
background: https://source.unsplash.com/collection/3178572/1920x1080
---

# Setup

Getting Started

---

# Initial Setup

<v-clicks depth="2">

1. **Copy the starter script** from the website into `todo.sh`

2. **Make it executable:**
   ```bash
   chmod +x todo.sh
   ```

3. **We'll build functionality incrementally:**
   - First: Add tasks
   - Then: View tasks
   - Then: Complete tasks
   - Then: Remove tasks
   - Finally: Clean up

</v-clicks>

---
layout: section
---

# Feature 1: Add Tasks

Adding items to your TODO list

---

# Add Function Specification

<v-clicks>

**Command syntax:**
```bash
./todo.sh add <task description>
```

**Requirements:**
- Store tasks in `$TODO_FILE`
- Use checkbox format: `[ ]` for new tasks
- Confirm task was added

</v-clicks>

---

# Add Function: Example Usage

```bash {all|1-2|4-5|7-8|all}
$ ./todo.sh add "Buy groceries"
Added: Buy groceries

$ ./todo.sh add "Finish homework"
Added: Finish homework

$ ./todo.sh add "Call dentist"
Added: Call dentist
```

<v-clicks>

After running these commands, your TODO file should contain:
```
[ ] Buy groceries
[ ] Finish homework
[ ] Call dentist
```

</v-clicks>

---

# Add Function: Useful Hints

<v-clicks>

**Key concepts:**

1. **`$*`** - gives you all parameters as a string
   - Example: `./todo.sh add Buy milk` → `$*` = "Buy milk"

2. **`echo` and `>>`** - append to file
   ```bash
   echo "something" >> $TODO_FILE
   ```

3. **Task format:** Start with `[ ]` checkbox
   ```bash
   echo "[ ] $*" >> $TODO_FILE
   ```

</v-clicks>

---

# Add Function: Implementation Tips

```bash
add() {
    # TODO: Get the task description from $*
    # TODO: Echo the task with [ ] to $TODO_FILE using >>
    # TODO: Confirm the task was added
}
```

<v-clicks>

**Think about:**
- How do you capture the task description?
- How do you format it with the checkbox?
- How do you append (not overwrite) the file?
- What message do you show the user?

</v-clicks>

---
layout: section
---

# Feature 2: Show Tasks

Viewing your TODO list

---

# Show Function Specification

<v-clicks>

**Command syntax:**
```bash
./todo.sh
```
(no parameters)

**Requirements:**
- Display all tasks with line numbers
- Replace `[ ]` with ⬜ (empty checkbox emoji)
- Replace `[x]` with ✅ (check mark emoji)
- Format nicely with consistent spacing

</v-clicks>

---

# Show Function: Example Output

```bash
$ ./todo.sh
     1  ⬜ Buy groceries
     2  ⬜ Finish homework
     3  ⬜ Call dentist
```

<v-clicks>

If some tasks are completed:
```bash
$ ./todo.sh
     1  ✅ Buy groceries
     2  ⬜ Finish homework
     3  ⬜ Call dentist
```

</v-clicks>

---

# Show Function: Useful Hints

<v-clicks depth="2">

**Key concepts:**

1. **Case statement wildcard**
   ```bash
   case "$command" in
       add)  add_function ;;
       done) done_function ;;
       *)    show_function ;;  # Default case
   esac
   ```

2. **`cat -n`** - adds line numbers
   ```bash
   cat -n $TODO_FILE
   ```

3. **`sed` substitution** - replace text
   ```bash
   sed 's/\[ \]/⬜/g'    # Replace [ ] with ⬜
   sed 's/\[x\]/✅/g'    # Replace [x] with ✅
   ```

</v-clicks>

---

# Show Function: Implementation Tips

```bash
show() {
    # TODO: Use cat -n to show the file with line numbers
    # TODO: Pipe to sed to replace [ ] with ⬜
    # TODO: Pipe to another sed to replace [x] with ✅
}
```

<v-clicks>

**Remember:**
- Escape brackets in sed: `\[` and `\]`
- Can chain multiple sed commands with pipes
- Or use multiple `-e` flags: `sed -e 's/...//' -e 's/...//'`

</v-clicks>

---

# Pipeline Example

```bash
cat -n $TODO_FILE | sed 's/\[ \]/⬜/g' | sed 's/\[x\]/✅/g'
```

<v-clicks>

This creates a pipeline:
1. `cat -n` → reads file with line numbers
2. First `sed` → replaces `[ ]` with ⬜
3. Second `sed` → replaces `[x]` with ✅

**Output flows left to right through the pipes!**

</v-clicks>

---
layout: section
---

# Feature 3: Complete Tasks

Marking tasks as done

---

# Complete Function Specification

<v-clicks>

**Command syntax:**
```bash
./todo.sh done <task_number>
```

**Requirements:**
- Find the task by line number
- Change `[ ]` to `[x]`
- Modify the file in-place
- Confirm the completion

</v-clicks>

---

# Complete Function: Example Usage

```bash {all|1-2|4-8|all}
$ ./todo.sh done 1
Completed task #1

$ ./todo.sh
     1  ✅ Buy groceries
     2  ⬜ Finish homework
     3  ⬜ Call dentist
```

<v-clicks>

Notice: Task #1 changed from ⬜ to ✅

</v-clicks>

---

# Complete Function: Useful Hints

<v-clicks depth="2">

**Key concepts:**

1. **`sed -i`** - edit file in-place
   ```bash
   sed -i 's/old/new/' file.txt
   ```
   
2. **Addressing in sed** - target specific lines
   ```bash
   sed '3s/old/new/' file.txt  # Only line 3
   ```

3. **macOS note:** May need `sed -i ""` instead of `sed -i`
   ```bash
   sed -i "" "s/old/new/" file.txt
   ```

</v-clicks>

---

# Complete Function: Implementation Tips

```bash
done_task() {
    task_num=$1
    # TODO: Use sed with -i flag to edit in-place
    # TODO: Use line addressing to target specific task
    # TODO: Replace [ ] with [x] on that line only
    # TODO: Confirm completion
}
```

<v-clicks>

**Think about:**
- How do you get the task number from arguments?
- How do you tell sed to only edit line N?
- What's the sed substitution pattern?

</v-clicks>

---

# Sed Addressing Example

```bash {all|1-2|4-5|7-8|all}
# Edit line 2 only
sed '2s/\[ \]/[x]/' file.txt

# Edit line stored in variable
sed "${task_num}s/\[ \]/[x]/" file.txt

# Edit in-place
sed -i "${task_num}s/\[ \]/[x]/" $TODO_FILE
```

<v-clicks>

**Note:** Use double quotes to allow variable expansion!

</v-clicks>

---
layout: section
---

# Feature 4: Remove Tasks

Deleting specific tasks

---

# Remove Function Specification

<v-clicks>

**Command syntax:**
```bash
./todo.sh rm <task_number>
```

**Requirements:**
- Find the task by line number
- Delete that line from the file
- Modify the file in-place
- Confirm the removal

</v-clicks>

---

# Remove Function: Example Usage

```bash {all|1-2|4-7|all}
$ ./todo.sh rm 3
Removed task #3

$ ./todo.sh
     1  ✅ Buy groceries
     2  ⬜ Finish homework
```

<v-clicks>

Notice: Task #3 ("Call dentist") is gone, and line numbers adjusted

</v-clicks>

---

# Remove Function: Useful Hints

<v-clicks depth="2">

**Key concepts:**

1. **`sed` delete command** - remove lines
   ```bash
   sed '3d' file.txt  # Delete line 3
   ```

2. **Combine with `-i`** for in-place edit
   ```bash
   sed -i '3d' file.txt
   ```

3. **Use variable for line number**
   ```bash
   sed -i "${task_num}d" $TODO_FILE
   ```

</v-clicks>

---

# Remove Function: Implementation Tips

```bash
remove_task() {
    task_num=$1
    # TODO: Use sed with -i flag and delete command
    # TODO: Use line addressing to target specific task
    # TODO: Confirm removal
}
```

<v-clicks>

**Key difference from `done`:**
- `done` uses substitution: `s/old/new/`
- `rm` uses deletion: `d`

Both use the same addressing: `${task_num}`

</v-clicks>

---

# Sed Commands Comparison

```bash
# Substitution (for 'done' command)
sed "${task_num}s/\[ \]/[x]/" $TODO_FILE

# Deletion (for 'rm' command)
sed "${task_num}d" $TODO_FILE
```

<v-clicks>

**Pattern:**
- `${task_num}` - address (which line)
- `s/.../.../ ` - substitution command
- `d` - delete command

</v-clicks>

---
layout: section
---

# Feature 5: Clean Completed Tasks

Removing all finished tasks

---

# Clean Function Specification

<v-clicks>

**Command syntax:**
```bash
./todo.sh clean
```

**Requirements:**
- Remove all lines with `[x]`
- Keep all lines with `[ ]`
- Report how many tasks were cleaned
- Maintain file structure

</v-clicks>

---

# Clean Function: Example Usage

```bash {all|1-2|4-6|8-10|all}
$ ./todo.sh
     1  ✅ Buy groceries
     2  ⬜ Finish homework
     3  ✅ Call dentist

$ ./todo.sh clean
Cleaned up 2 completed tasks

$ ./todo.sh
     1  ⬜ Finish homework
```

---

# Clean Function: Useful Hints

<v-clicks depth="2">

**Key concepts:**

1. **`grep -v`** - inverted match (show lines that DON'T match)
   ```bash
   grep -v "pattern" file.txt  # Show lines without pattern
   ```

2. **Strategy:** Filter out completed tasks
   ```bash
   grep -v "\[x\]" $TODO_FILE > temp_file
   mv temp_file $TODO_FILE
   ```

3. **Count tasks:** Before and after, or count `[x]` matches

</v-clicks>

---

# Clean Function: Implementation Tips

```bash
clean_completed() {
    # TODO: Count completed tasks (optional but nice)
    # TODO: Use grep -v to filter out lines with [x]
    # TODO: Save to temporary file
    # TODO: Replace original file with temp file
    # TODO: Report how many were cleaned
}
```

<v-clicks>

**Alternative approaches:**
- Use `sed` with deletion: `sed -i '/\[x\]/d' $TODO_FILE`
- Use `awk` to filter
- Temporary file method is most straightforward

</v-clicks>

---

# Counting Completed Tasks

```bash {all|1-2|4-5|7-8|all}
# Count lines with [x]
completed=$(grep -c "\[x\]" $TODO_FILE)

# Or count before filtering
completed=$(grep "\[x\]" $TODO_FILE | wc -l)

# Use in message
echo "Cleaned up $completed completed tasks"
```

<v-clicks>

**Note:** Handle case where count is 0 gracefully!

</v-clicks>

---

# Complete Clean Implementation Example

```bash {all|2-3|5-6|8-9|11-12|all}
clean_completed() {
    # Count completed tasks
    completed=$(grep -c "\[x\]" $TODO_FILE 2>/dev/null || echo 0)
    
    # Filter out completed tasks
    grep -v "\[x\]" $TODO_FILE > "$TODO_FILE.tmp"
    
    # Replace original file
    mv "$TODO_FILE.tmp" $TODO_FILE
    
    # Report
    echo "Cleaned up $completed completed tasks"
}
```

---
layout: two-cols
---

# Putting It All Together

<v-clicks>

Your script should handle:
1. `./todo.sh add "task"` → Add
2. `./todo.sh` → Show all
3. `./todo.sh done N` → Complete
4. `./todo.sh rm N` → Remove
5. `./todo.sh clean` → Clean up

</v-clicks>

::right::

<div v-click>

## Script Structure

```bash
#!/bin/bash

TODO_FILE="$HOME/.todos.txt"

add() { ... }
show() { ... }
done_task() { ... }
remove_task() { ... }
clean_completed() { ... }

case "$1" in
    add)   add "$2" ;;
    done)  done_task "$2" ;;
    rm)    remove_task "$2" ;;
    clean) clean_completed ;;
    *)     show ;;
esac
```

</div>

