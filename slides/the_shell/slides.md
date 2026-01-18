---
theme: default
background: https://source.unsplash.com/collection/94734566/1920x1080
title: 'CMSC398W: The Shell'
info: |
  ## Course Overview and The Shell
  Practical Tools For Efficient Development
class: text-center
highlighter: shiki
drawings:
  persist: false
transition: slide-left
mdc: true
---

# CMSC398W

Course Overview and The Shell

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: two-cols
---

# About The Class

**CMSC398W: Practical Tools For Efficient Development**

<v-clicks>

- Overview of tools used in development
  - Command line, Git, debuggers, build systems
- Emphasis on breadth over depth
- Hands-on learning through projects

</v-clicks>

::right::

<div v-click>

## Goals

- Improve your computing ecosystem literacy
- Improve your efficiency
- Reduce cognitive load while developing

</div>

---

# About Us

## Mohammad Durrani

<v-clicks>

- **Year:** Senior
- **Major:** CS + Math, minor in Robotics
- **Experience:** SWE Intern at Google, TRX
- **Interests:** Rock climbing, Basketball, Robots

</v-clicks>

---

# Why These Tools Matter

<v-clicks>

## Experience

**AI Research**
- Bash scripts are essential for reproducible experiments
- Can't code without SSH and command line knowledge
- Docker is heavily used for model deployment

**Software Engineering**
- Vim and data wrangling make life easier
- CI/CD ensures software quality and simplifies testing
- Version control is fundamental to collaboration

</v-clicks>

---
layout: two-cols
---

# What To Expect

## In Class

<v-clicks>

1. Introduction of Topic
2. Motivation / Real World Examples
3. Technical Details

</v-clicks>

::right::

## Out of Class

<v-clicks>

- Projects focusing on application of what you learned
- **Best way to learn these tools is to use them**

</v-clicks>

<div v-click class="mt-8 text-orange-400 font-bold">
📚 Read the syllabus for all course-related information!
</div>

---

# Course Logistics

<v-clicks>

- All course communication through **Piazza**
- All assignments submitted through **Gradescope**
- Projects have a **10% per-day late penalty**
  - (except the last project)

</v-clicks>

---

# Grading

| Percentage | Component | Description |
|------------|-----------|-------------|
| **80%** | Projects | 4 Major Projects |
| **10%** | Application Days | Completion of Application Days assignments |
| **10%** | Participation | Asking/answering questions in class |

---

# Application Days

Based on feedback from previous iterations, we'll have days focused on using the tools we learn in class on toy problems

<v-clicks>

**Three application days (subject to change):**

1. **Shell** - 09/26
2. **Git** - 10/31
3. **Networking** - 12/05

</v-clicks>

---
layout: cover
background: https://source.unsplash.com/collection/8742796/1920x1080
---

# The Shell

Understanding the Command Line Interface

---

# Introduction

<v-clicks>

- Traditional computer interfaces have evolved:
  - Graphical UIs
  - Voice commands
  - AR/VR
- Modern interfaces are great for ~80% of common tasks
- **But they can be limiting:**
  - You cannot click a button that doesn't exist
  - You cannot give a voice command that hasn't been programmed
- **The shell provides:**
  - Powerful text-based interface
  - More flexibility and control
- We'll focus on **bash** (Bourne Again Shell)

</v-clicks>

---

# What is the Shell?

<v-clicks>

**Shell:** A program that allows you to execute commands and interface with your operating system

- Nearly all platforms have a shell (often multiple shells to choose from)
- Different types: bash, zsh, dash, fish, PowerShell
- **Core functionality remains the same:**
  - Run programs
  - Give them input
  - Inspect their output

**In this class:** We'll use **bash**
- One of the most widely used shells
- Default on Linux systems
- Similar syntax to many other shells

</v-clicks>

---

# Important Terminology

<v-clicks depth="2">

## 1. Traditional Terminal
- Historical computing device
- Physical keyboard and screen connected to shared computer
- Text-only interface (pre-mouse era)
- Used specific protocols to communicate
- Evolution included colors, fonts, extended character sets

## 2. Modern Terminal Emulator
- Software that emulates traditional terminals
- **Examples:**
  - Windows: CMD.exe, PowerShell, Windows Terminal
  - macOS: Terminal.app, iTerm2
  - Linux: xTerm, Gnome Terminal, Konsole, Kitty, Alacritty

</v-clicks>

---

# Important Terminology (continued)

<v-clicks>

## 3. Shell/Command-line Interface
- Program started when logging into terminal
- Interprets commands
- Provides interactive environment

## The Relationship
```
Terminal Emulator → Runs → Shell → Executes → Commands
```

</v-clicks>

---

# Motivation

<v-clicks>

## Why Learn the Command Line?

- **Essential for software development**
- **Improve efficiency** - automate repetitive tasks
- **Many development tools** are command line based
- **Access remote servers** and cloud platforms
- **Work across different operating systems**
- **Master it** and become much more productive

</v-clicks>

---

# The Prompt

```bash
username@domain directory$
```

<v-clicks>

**Components breakdown:**
- `username` - currently logged in user
- `@` - separator (convention)
- `domain` - machine name
- `directory` - current working directory
- `$` - user-level shell indicator
- `#` - root-level shell indicator

**Customizable** through environment variables
- Can include git status, time, colors, etc.

</v-clicks>

---

# Basic Commands

<v-clicks>

Commands are parsed by splitting on whitespace:
- First word = program to run
- Subsequent words = arguments to that program

**Important Notes:**
- Commands are case-sensitive
- Each command is usually a separate program
- Arguments modify command behavior
- Special characters need proper handling
- Flags/options typically start with `-`

</v-clicks>

---

# Command Examples

```bash
# Show current date and time
date

# Echo text to screen
echo hello

# Handle spaces in arguments
echo "Hello World"
echo Hello\ World

# Multiple arguments
echo first second third
```

<v-clicks>

**Question:** How does the shell know where to find the `date` or `echo` programs?

</v-clicks>

---

# The PATH Variable

<v-clicks>

When you run a command, the shell:
1. Checks if it's a built-in command
2. Searches directories listed in `$PATH`
3. Uses the first matching executable found

**PATH is a colon-separated list of directories:**

```bash
cmsc398w:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

cmsc398w:~$ which echo
/usr/bin/echo

cmsc398w:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
```

</v-clicks>

---

# Modifying PATH

You can add directories to your PATH:

```bash
export PATH="/Directory1:$PATH"
```

<v-clicks>

This prepends `/Directory1` to your existing PATH

**Order matters:** First match wins!

</v-clicks>

---

# Navigating the Shell: Paths

<v-clicks depth="2">

## Absolute Paths
- Start with `/` (Unix) or drive letter (Windows)
- Full path from root directory
- Work from any location
- Example: `/home/user/documents/file.txt`

## Relative Paths
- Relative to current directory
- More concise but context-dependent
- Example: `documents/file.txt`

</v-clicks>

---

# Special Directory Symbols

<v-clicks>

| Symbol | Meaning |
|--------|---------|
| `.` | Current directory |
| `..` | Parent directory |
| `~` | Home directory |
| `-` | Previous directory |

**Examples:**
```bash
cd .          # Stay in current directory
cd ..         # Go up one level
cd ~          # Go to home directory
cd -          # Go to previous directory
```

</v-clicks>

---

# Essential Navigation Commands

```bash {all|1-2|4-5|7-8|all}
# Print working directory
pwd

# List files
ls

# Change directory
cd /path/to/directory
```

<v-clicks>

**Common ls options:**
- `ls -l` - long format with details
- `ls -a` - show hidden files (starting with .)
- `ls -lh` - human-readable file sizes
- `ls -R` - recursive listing

</v-clicks>

---

# File Operations

```bash
# Create directory
mkdir directory_name

# Create file
touch filename.txt

# Copy files
cp source.txt destination.txt

# Move/rename files
mv old_name.txt new_name.txt

# Remove files
rm filename.txt

# Remove directory
rm -r directory_name
```

---

# Viewing File Contents

```bash {all|1-2|4-5|7-8|10-11|13-14|all}
# View entire file
cat filename.txt

# View with pagination
less filename.txt

# View first lines
head filename.txt

# View last lines
tail filename.txt

# Follow file updates
tail -f logfile.txt
```

---

# Standard Streams

<v-clicks>

Every program has three standard streams:

1. **stdin (Standard Input)** - Input stream (file descriptor 0)
2. **stdout (Standard Output)** - Output stream (file descriptor 1)
3. **stderr (Standard Error)** - Error messages (file descriptor 2)

By default:
- stdin reads from keyboard
- stdout and stderr write to screen

**But we can redirect them!**

</v-clicks>

---

# Input/Output Redirection

```bash {all|1-2|4-5|7-8|10-11|13-14|all}
# Redirect output to file (overwrite)
echo "Hello" > output.txt

# Redirect output to file (append)
echo "World" >> output.txt

# Redirect input from file
sort < unsorted.txt

# Redirect stderr
command 2> error.log

# Redirect both stdout and stderr
command > output.txt 2>&1
```

---

# Pipes

<v-clicks>

**Pipes** (`|`) connect the output of one program to the input of another

```bash
ls -l | grep ".txt" | wc -l
```

This command:
1. Lists files in long format
2. Filters for lines containing ".txt"
3. Counts the number of lines

**Pipes enable powerful command composition!**

</v-clicks>

---

# Common Pipe Patterns

```bash
# Find processes
ps aux | grep chrome

# Count files
ls | wc -l

# Sort and get unique values
cat file.txt | sort | uniq

# View large output
ls -la /usr/bin | less

# Chain multiple filters
cat access.log | grep "ERROR" | awk '{print $1}' | sort | uniq -c
```

---

# Wildcards and Globbing

<v-clicks>

**Wildcards** allow pattern matching in filenames:

| Pattern | Matches |
|---------|---------|
| `*` | Zero or more characters |
| `?` | Single character |
| `[abc]` | Any character in brackets |
| `[!abc]` | Any character NOT in brackets |
| `{a,b,c}` | Any of the comma-separated patterns |

```bash
ls *.txt          # All .txt files
ls file?.txt      # file1.txt, fileA.txt, etc.
ls [abc]*.txt     # Files starting with a, b, or c
rm *.{jpg,png}    # Remove all jpg and png files
```

</v-clicks>

---

# Finding Files

```bash {all|1-2|4-5|7-8|10-11|all}
# Find files by name
find /path -name "*.txt"

# Find files by type
find /path -type f  # files only

# Find files by size
find /path -size +100M  # larger than 100MB

# Execute command on found files
find /path -name "*.log" -exec rm {} \;
```

---

# Searching File Contents

```bash {all|1-2|4-5|7-8|10-11|all}
# Search for pattern in file
grep "pattern" filename.txt

# Case-insensitive search
grep -i "pattern" filename.txt

# Recursive search in directory
grep -r "pattern" /path/to/dir

# Show line numbers
grep -n "pattern" filename.txt
```

---

# Text Processing: sed

**sed** = Stream Editor for filtering and transforming text

```bash {all|1-2|4-5|7-8|all}
# Replace first occurrence
sed 's/old/new/' file.txt

# Replace all occurrences
sed 's/old/new/g' file.txt

# Edit file in-place
sed -i 's/old/new/g' file.txt
```

<v-clicks>

**Pattern:** `s/pattern/replacement/flags`

</v-clicks>

---

# Text Processing: awk

**awk** is a powerful pattern scanning and processing language

```bash {all|1-2|4-5|7-8|all}
# Print specific columns
awk '{print $1, $3}' file.txt

# Filter and print
awk '$3 > 100 {print $1, $3}' file.txt

# Sum a column
awk '{sum += $3} END {print sum}' file.txt
```

<v-clicks>

By default, awk splits on whitespace and uses `$1`, `$2`, etc. for columns

</v-clicks>

---

# Permissions

<v-clicks depth="2">

Unix file permissions have three categories:
- **User (u)** - file owner
- **Group (g)** - users in file's group
- **Others (o)** - everyone else

Each category has three permissions:
- **Read (r)** - view contents
- **Write (w)** - modify contents
- **Execute (x)** - run as program

</v-clicks>

---

# Understanding Permission Notation

```bash
-rw-r--r--  1 user group 4096 Jan 15 10:30 file.txt
drwxr-xr-x  2 user group 4096 Jan 15 10:30 folder
```

<v-clicks>

**First character:** file type
- `-` = regular file
- `d` = directory
- `l` = symbolic link

**Next 9 characters:** permissions (3 groups of 3)
- `rw-` = user permissions (read, write, no execute)
- `r--` = group permissions (read only)
- `r--` = other permissions (read only)

</v-clicks>

---

# Changing Permissions

```bash {all|1-2|4-5|7-8|10-11|all}
# Add execute permission for user
chmod u+x script.sh

# Remove write permission for group
chmod g-w file.txt

# Set specific permissions (numeric)
chmod 755 script.sh  # rwxr-xr-x

# Change ownership
chown user:group file.txt
```

<v-clicks>

**Numeric permissions:** Each digit is sum of r=4, w=2, x=1

</v-clicks>

---

# Root and Sudo

<v-clicks>

**Root user** - superuser with unlimited privileges
- Unrestricted access to entire system
- Indicated by `#` prompt

**sudo** - "superuser do"
- Execute commands as root
- Safer than logging in as root
- Requires password authentication

```bash
sudo apt update
sudo rm /etc/important-file
```

**Use with caution!** You can break your system.

</v-clicks>

---

# Package Management

<v-clicks depth="2">

Different distributions use different package managers:

**Debian/Ubuntu:**
```bash
sudo apt update
sudo apt install package-name
sudo apt remove package-name
```

**Red Hat/Fedora:**
```bash
sudo dnf install package-name
sudo dnf remove package-name
```

**macOS (Homebrew):**
```bash
brew install package-name
brew uninstall package-name
```

</v-clicks>

---

# Environment Variables

<v-clicks>

**Environment variables** store configuration and system information

```bash
# View variable
echo $HOME
echo $PATH

# Set variable (current session)
export MY_VAR="value"

# View all variables
env
```

**Common variables:**
- `$HOME` - home directory
- `$USER` - current username
- `$PATH` - executable search path
- `$SHELL` - current shell

</v-clicks>

---

# Job Control

<v-clicks>

**Run programs in background:**

```bash
# Run in background
long_running_command &

# List background jobs
jobs

# Bring job to foreground
fg %1

# Send running job to background
# (Ctrl-Z to suspend, then:)
bg %1
```

</v-clicks>

---

# Process Management

```bash {all|1-2|4-5|7-8|10-11|all}
# List all processes
ps aux

# Real-time process viewer
top

# Kill process by PID
kill 1234

# Force kill process
kill -9 1234
```

---

# SSH: Secure Shell

<v-clicks>

**SSH** allows secure remote access to other computers

```bash
# Connect to remote server
ssh username@hostname

# Run command on remote server
ssh username@hostname 'ls -la'

# Copy files to remote (scp)
scp file.txt username@hostname:/path/

# Copy files from remote
scp username@hostname:/path/file.txt .
```

**SSH keys** provide passwordless authentication (more secure than passwords)

</v-clicks>

---

# SSH Key Authentication

```bash {all|1-2|4-5|7-8|all}
# Generate SSH key pair
ssh-keygen -t ed25519

# Copy public key to remote server
ssh-copy-id username@hostname

# Now you can SSH without password
ssh username@hostname
```

<v-clicks>

**Benefits:**
- More secure than passwords
- No need to type password repeatedly
- Can use different keys for different servers

</v-clicks>

---

# Shell Scripting Basics

<v-clicks>

Shell scripts are text files containing shell commands

```bash
#!/bin/bash
# This is a comment

echo "Hello, World!"
name="Alice"
echo "Hello, $name!"
```

**Make it executable:**
```bash
chmod +x script.sh
./script.sh
```

</v-clicks>

---

# Variables and Command Substitution

```bash
#!/bin/bash

# Variables
name="John"
count=5

# Command substitution
current_date=$(date)
file_count=$(ls | wc -l)

# Using variables
echo "Hello, $name!"
echo "Today is $current_date"
echo "There are $file_count files"
```

---

# Conditionals

```bash
#!/bin/bash

if [ -f "file.txt" ]; then
    echo "File exists"
elif [ -d "directory" ]; then
    echo "Directory exists"
else
    echo "Neither exists"
fi
```

<v-clicks>

**Common test operators:**
- `-f file` - file exists
- `-d dir` - directory exists
- `-z string` - string is empty
- `$a -eq $b` - numbers equal
- `$a -gt $b` - a greater than b

</v-clicks>

---

# Loops

```bash
#!/bin/bash

# For loop
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# For loop with command
for file in *.txt; do
    echo "Processing $file"
done

# While loop
counter=0
while [ $counter -lt 5 ]; do
    echo "Counter: $counter"
    counter=$((counter + 1))
done
```

---

# Functions

```bash
#!/bin/bash

# Define function
greet() {
    local name=$1
    echo "Hello, $name!"
}

# Call function
greet "Alice"
greet "Bob"

# Function with return value
add() {
    local sum=$(($1 + $2))
    echo $sum
}

result=$(add 5 3)
echo "5 + 3 = $result"
```

---

# Command Line Arguments

```bash
#!/bin/bash

# $0 = script name
# $1, $2, ... = arguments
# $# = number of arguments
# $@ = all arguments

echo "Script name: $0"
echo "First argument: $1"
echo "Number of arguments: $#"
echo "All arguments: $@"

# Example usage:
# ./script.sh arg1 arg2 arg3
```

---

# Error Handling

```bash
#!/bin/bash

# Exit on error
set -e

# Check command success
if ! grep "pattern" file.txt; then
    echo "Pattern not found!"
    exit 1
fi

# Check exit status
some_command
if [ $? -eq 0 ]; then
    echo "Success!"
else
    echo "Failed!"
fi
```

---
layout: cover
background: https://source.unsplash.com/collection/1132127/1920x1080
---

# Terminal Multiplexing

Managing Multiple Terminal Sessions

---

# About Tmux

<v-clicks>

**tmux** = (t)erminal (mu)ltiple(x)er

Enables you to create multiple "pseudo terminals" from a single terminal

**Benefits:**
- Manage multiple programs in a single terminal
- Easy collaboration with others
- Switch between windows without using your mouse
- **Persistent sessions** - especially useful for remote machines
  - Sessions survive disconnections
  - No need for `nohup` tricks

</v-clicks>

---

# Tmux Concepts

<v-clicks depth="2">

## Sessions
- Independent workspaces
- Persist even when detached
- Can have multiple windows

## Windows
- Like browser tabs
- Multiple windows per session
- Each window has its own shell

## Panes
- Split windows into multiple sections
- Multiple panes per window
- Each pane runs independently

</v-clicks>

---

# Tmux Command Prefix

<v-clicks>

All tmux commands start with the **prefix key**

**Default prefix:** `Ctrl-b` (shown as `<C-b>`)

**Pattern:**
1. Press `Ctrl-b`
2. Release both keys
3. Press the command key

**Example:** Create new window
- Press `Ctrl` + `b`
- Release
- Press `c`

</v-clicks>

---

# Session Management

```bash
# Start new session
tmux

# Start named session
tmux new -s myproject

# List sessions
tmux ls

# Attach to session
tmux attach -t myproject

# Detach from current session (inside tmux)
# <C-b> d

# Kill session
tmux kill-session -t myproject
```

---

# Window Management

<v-clicks>

| Command | Action |
|---------|--------|
| `<C-b> c` | Create new window |
| `<C-b> w` | List windows |
| `<C-b> n` | Next window |
| `<C-b> p` | Previous window |
| `<C-b> 0-9` | Switch to window N |
| `<C-b> ,` | Rename window |
| `<C-b> &` | Kill window |

</v-clicks>

---

# Pane Management

<v-clicks>

| Command | Action |
|---------|--------|
| `<C-b> "` | Split horizontally |
| `<C-b> %` | Split vertically |
| `<C-b> arrow` | Navigate panes |
| `<C-b> z` | Toggle pane zoom |
| `<C-b> x` | Kill pane |
| `<C-b> {` | Move pane left |
| `<C-b> }` | Move pane right |

</v-clicks>

---

# Tmux Copy Mode

<v-clicks>

**Copy Mode** allows you to scroll and copy text

**Enter copy mode:** `<C-b> [`

**Navigation:**
- Arrow keys or vim keys (`h`, `j`, `k`, `l`)
- Page up/down

**Selection:**
1. Start selection: `Space`
2. Navigate to end
3. Copy selection: `Enter`

**Paste:** `<C-b> ]`

</v-clicks>

---

# Practical Tmux Workflow

```bash {all|1-2|4-5|7-8|10-11|13-14|all}
# Start a development session
tmux new -s dev

# Split vertically for code and output
<C-b> %

# Split horizontally for logs
<C-b> "

# Navigate between panes
<C-b> arrow-keys

# Zoom into one pane
<C-b> z
```

---
layout: cover
background: https://source.unsplash.com/collection/1319040/1920x1080
---

# Shell Customization

Making the Shell Your Own

---

# Aliases

<v-clicks>

**Aliases** create shortcuts for common commands

```bash
# Basic syntax
alias alias_name="command_to_alias"

# Common examples
alias ll="ls -lh"
alias la="ls -la"
alias gs="git status"
alias gc="git commit"
alias mv="mv -i"  # Safer defaults
```

**Note:** No spaces around `=`

</v-clicks>

---

# Using Aliases

```bash
# Create alias (temporary)
alias ll="ls -lh"

# Use it
ll

# Ignore alias temporarily
\ll

# Remove alias
unalias ll
```

<v-clicks>

**Important:** Aliases don't persist by default
- Need to add to shell config files (`.bashrc`, `.zshrc`)
- Loaded on shell startup

</v-clicks>

---

# Dotfiles

<v-clicks>

**Dotfiles** are plain-text configuration files

- Start with `.` (hidden by default)
- Configure programs and shells
- Examples:
  - `.bashrc` - bash configuration
  - `.vimrc` - vim configuration
  - `.gitconfig` - git configuration
  - `.tmux.conf` - tmux configuration
  - `.ssh/config` - SSH configuration

</v-clicks>

---

# Common Shell Dotfiles

<v-clicks depth="2">

## `.bashrc`
- Loaded for interactive non-login shells
- Aliases, functions, custom prompts

## `.bash_profile`
- Loaded for login shells
- Environment variables, PATH modifications

## `.profile`
- Generic login shell configuration
- Works with multiple shells

**Loading order can be complex!**
- See [this guide](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) for details

</v-clicks>

---

# Dotfile Organization

<v-clicks>

**Best practices:**

1. **Keep in version control** (Git repository)
2. **Store in dedicated folder** (`~/dotfiles/`)
3. **Use symlinks** to actual locations
4. **Create installation script**

**Benefits:**
- Easy installation on new machines
- Portable across systems
- Synchronized everywhere
- Track changes over time
- Share with others (GitHub)

</v-clicks>

---

# Dotfile Repository Structure

```
dotfiles/
├── bash/
│   ├── bashrc
│   └── bash_profile
├── git/
│   └── gitconfig
├── vim/
│   └── vimrc
├── tmux/
│   └── tmux.conf
├── install.sh
└── README.md
```

---

# Symlinking Dotfiles

```bash
# Create symlinks from home directory to dotfiles repo
ln -sf ~/dotfiles/bash/bashrc ~/.bashrc
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/vim/vimrc ~/.vimrc
ln -sf ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
```

<v-clicks>

**`ln -sf` options:**
- `-s` - symbolic link
- `-f` - force (overwrite existing)

</v-clicks>

---

# Sample Installation Script

```bash
#!/bin/bash

# Dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# Create symlinks
ln -sf "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Reload bash configuration
source "$HOME/.bashrc"

echo "Dotfiles installed successfully!"
```

---

# Sample .bashrc

```bash
# Aliases
alias ll='ls -lh'
alias la='ls -lha'
alias ..='cd ..'
alias gs='git status'

# Custom prompt
PS1='\[\e[36m\]\u@\h\[\e[m\]:\[\e[33m\]\w\[\e[m\]\$ '

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Environment variables
export EDITOR=vim
export PATH="$HOME/bin:$PATH"
```

---

# Finding Inspiration

<v-clicks>

**Learning resources:**
- Read documentation and man pages
- Search for blog posts about specific programs
- Browse other people's dotfiles on GitHub
  - [GitHub dotfiles topic](https://github.com/topics/dotfiles)
  - Popular repos have thousands of stars

**Warning:** Don't blindly copy configurations!
- Understand what each setting does
- Customize to your needs
- Start simple, add complexity gradually

</v-clicks>

---

# GitHub Dotfiles Integration

```bash
# Initialize git repository
cd ~/dotfiles
git init

# Create .gitignore
echo ".DS_Store" > .gitignore
echo "*.swp" >> .gitignore

# Stage and commit
git add .
git commit -m "Initial dotfiles commit"

# Create repo on GitHub, then:
git remote add origin git@github.com:username/dotfiles.git
git push -u origin main
```

---

# Shell Functions

```bash
# In .bashrc or .bash_profile

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive types
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz)  tar xzf "$1"   ;;
            *.zip)     unzip "$1"     ;;
            *.tar)     tar xf "$1"    ;;
            *)         echo "Unknown archive type" ;;
        esac
    fi
}
```

---

# Advanced Customization

<v-clicks>

**Custom prompt with git status:**
```bash
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1='\u@\h:\w\[\e[91m\]$(parse_git_branch)\[\e[00m\]$ '
```

**Color schemes**
```bash
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
```

**History settings**
```bash
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
```

</v-clicks>

---
layout: end
---

# Thank You!

Questions?

<div class="abs-br m-6 flex gap-2">
  <a href="https://github.com" target="_blank" alt="GitHub"
    class="text-xl slidev-icon-btn opacity-50 !border-none !hover:text-white">
    <carbon-logo-github />
  </a>
</div>

<!--
This is the end of the presentation. Feel free to ask questions about:
- Shell basics and commands
- Tmux usage and workflows
- Dotfiles and customization
- Any other shell-related topics
-->