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

---
layout: default
---

# A Systematic Approach: *Observe, Hypothesize, Test*

<v-clicks depth="2">

Debugging is *methodical*, not trial-and-error.

**Five steps:**

1. **Reproduce consistently**
   - If you can't reproduce, you can't fix
   - Record steps, inputs, environment

2. **Isolate the problem**
   - Use binary search strategy in code
   - Comment out or disable sections to narrow scope

3. **Form a hypothesis**
   - Develop a theory based on symptoms
   - Example: null pointer from empty API response

4. **Test the hypothesis**
   - Add logs, run debugger, or create a minimal test
   - Only change one thing at a time

5. **Fix and verify**
   - Apply fix, confirm it solves the issue
   - Run related tests to ensure nothing else broke

</v-clicks>

---
layout: default
---

# Example Walkthrough

<v-clicks>

**Scenario:** Web app crashes on file upload

- **Step 1:** Reproduce with user uploads
- **Step 2:** Isolate → file parsing function
- **Step 3:** Hypothesize → large files cause memory issue
- **Step 4:** Test → try different file sizes
- **Step 5:** Fix → switch to streaming instead of full load

</v-clicks>

---
layout: section
---

# Printf Debugging & Logging

---
layout: default
---

# Printf Debugging & Logging

<v-clicks>

- **Print Debugging** is simple, iterative debugging with print statements

- **Logging Debugging**
  - Log to files, sockets, or remote servers instead of standard output
  - Severity Levels
  - Demo

</v-clicks>

<div class="absolute bottom-10 right-10 w-80">
<img src="https://imgs.xkcd.com/comics/debugging.png" class="rounded shadow-lg" />
</div>

---
layout: default
---

# Printf Debugging

> *"The most effective debugging tool is still careful thought, coupled with judiciously placed print statements."*  
> — Brian Kernighan (1979)

<v-clicks>

- Print statements = simplest debugging method
- Iterate by adding prints near problem areas until root cause is clear
- Preferred because it's quick, easy, and effective

</v-clicks>

---
layout: default
---

# Logging: Enhanced Print Debugging

<v-clicks>

**Logging advantages:**

- Output to files, sockets, remote servers
- Easier to review than raw terminal output
- Severity levels: `INFO`, `DEBUG`, `WARN`, `ERROR`
- Long-term monitoring + immediate debugging

</v-clicks>

---
layout: default
---

# Tips for Effective Logging

<v-clicks depth="2">

- Set log levels properly to filter noise
- Use structured logging (key–value pairs) → searchable, filterable, analyzable
- Ensure each log entry is traceable to source code (unique messages/prefixes)
- Use log viewers for easier navigation
- Use correlation IDs to track requests end-to-end
- Don't let logging consume resources → be strategic, use metrics when better
- **Never log sensitive info**
- Only log what's needed (iterative refinement)

</v-clicks>

---
layout: default
---

# External Logging

When working with external dependencies like web servers, databases, or containerized services, you'll often need to check their logs since client-side error messages may not provide enough detail.

<v-clicks>

- Most programs write logs to `/var/log` on UNIX systems
- Modern containerized applications expose logs through commands like:
  ```bash
  docker logs <container-name>
  ```

</v-clicks>

---
layout: section
---

# Interactive Debuggers

---
layout: default
---

# Interactive Debuggers

When print debugging is not enough you should use a debugger. Debuggers are programs that let you interact with the execution of a program, allowing the following:

<v-clicks>

- Halt execution of the program when it reaches a certain line
- Step through the program one instruction at a time
- Inspect values of variables after the program crashed
- Conditionally halt the execution when a given condition is met
- And many more advanced features

**Should be covered basically in CMSC132!**

</v-clicks>

---
layout: default
---

# Debugger Concepts

Debuggers allow you to pause program execution at breakpoints, then step through code line by line.

<v-clicks>

**Key operations include:**

- **Step Over:** Execute the current line including any function calls
- **Step Into:** Enter a function to debug its internals
- **Step Out:** Continue until the current function returns

**While paused, you can:**

- Inspect the call stack (the sequence of function calls that led to the current point)
- Examine and modify variable values
- Set watch expressions to monitor specific values as the program executes

</v-clicks>

---
layout: default
---

# Conditional Breakpoints

Conditional breakpoints extend the basic breakpoint concept by adding programmable conditions.

<v-clicks>

- Instead of stopping every time a particular line is reached, the debugger only halts execution when the specified condition is true

- Example: A conditional breakpoint might only trigger when a variable reaches a certain value or when a specific error condition occurs

- This capability is especially valuable when:
  - Debugging issues that only manifest under specific circumstances
  - Dealing with code that executes frequently but only occasionally exhibits problematic behavior

</v-clicks>

---
layout: center
---

# Buggy Calculator Demo

**Python Debugger (pdb) Commands Reference**

---
layout: section
---

# Specialized Tools

---
layout: default
---

# Specialized Tools

<div class="grid grid-cols-2 gap-8">
<div>

**System Call Tracing**

<v-clicks>

- Monitor interactions between a program and the OS kernel
- Tools like **strace** (Linux) and **dtruss** (macOS) help trace system calls made by programs
- Useful for debugging programs where you cannot see the source code or when you're dealing with black box binaries

</v-clicks>

</div>
<div>

**Network Packet Analysis**

<v-clicks>

- Helps diagnose network-related issues by examining the traffic between systems
- Tools like **tcpdump** and **Wireshark** allow you to capture and filter network packets

</v-clicks>

</div>
</div>

---
layout: default
---

# System Call Tracing

Every time a program interacts with the operating system — whether it's reading from a file, allocating memory, or interacting with hardware — it makes a **system call**.

<v-clicks>

System call tracing allows us to monitor these interactions in real time.

**On Linux:** `strace` is commonly used for this purpose

- Shows every system call made by a program
- Displays arguments passed and returned results
- Particularly helpful when you can't access the program's source code or you're working with compiled binaries

**On macOS:** `dtruss` serves a similar role, tracing system calls in a readable and useful way for diagnosis

</v-clicks>

---
layout: center
---

# WebDev / Developer Tools

Modern browsers provide powerful debugging capabilities built-in

---
layout: section
---

# Profiling

---
layout: default
---

# Profiling

Even if your code functionally behaves as you would expect, that might not be good enough if it takes all your CPU or memory in the process.

<v-clicks>

- Algorithms classes often teach big O notation but not how to find hot spots in your programs
- Since **"premature optimization is the root of all evil"**, you should learn about profilers and monitoring tools
- They will help you understand which parts of your program are taking most of the time and/or resources
- You can then focus on optimizing those parts

</v-clicks>

---
layout: default
---

# Profiling via Internal Timing

<v-clicks>

- In many cases it is enough to print the wall clock time it took your code between two points

- Wall clock time can be misleading because your computer may be running other processes simultaneously or waiting for external events

**Types of timing:**

- **Real Time**
- **User Time**
- **Sys Time**

</v-clicks>

---
layout: default
---

# Types of Timing

When we measure how long a program takes to run, there are a few different types of time we might look at:

<v-clicks>

**Real Time** – This is the total time it takes for your program to run from start to finish, including everything: any waiting time for data, interactions with other programs, or delays from external factors like the internet or the file system. It's just like how long it feels like the program is running in the real world, from the moment you start it to when it finishes.

**User Time** – This is the time the computer's processor (CPU) actually spends running your program's code, excluding any time spent on system-level tasks (like talking to the operating system or doing I/O). This is usually the time spent performing the calculations or work you've asked your program to do.

**Sys Time** – This refers to the time the CPU spends running system-level tasks, such as making system calls or accessing hardware. These tasks are handled by the operating system and include things like reading from the disk or handling network requests.

</v-clicks>

---
layout: default
---

# Optimization Advice

<v-clicks>

If your program is spending a lot of time waiting for something external (like a server to respond or disk operations), improving the speed of the program might not be about making the code faster or using more threads.

**Instead, you might want to:**

- Reduce the number of times your program needs to wait
- Send fewer requests to the server
- Cache information to avoid re-checking the same files on the disk

</v-clicks>

---
layout: section
---

# CPU Profilers

---
layout: default
---

# CPU Profilers

<v-clicks>

- Tools used to analyze and measure how much CPU time is spent on different functions/code blocks

**Tracing vs Sampling:**

- **Tracing Profilers:** Track every function call your program makes
- **Sampling Profilers:** Periodically sample the program's stack to gather time usage data

**Demos:**

- cProfile Demo: function profiling
- Line profiler demo

</v-clicks>

---
layout: default
---

# CPU Profilers - Details

Most of the time when people refer to *profilers* they actually mean *CPU profilers*, which are the most common.

<v-clicks>

There are two main types of CPU profilers: *tracing* and *sampling* profilers.

- **Tracing profilers** keep a record of every function call your program makes
- **Sampling profilers** probe your program periodically (commonly every millisecond) and record the program's stack
- They use these records to present aggregate statistics of what your program spent the most time doing

In Python we can use the `cProfile` module to profile time per function call.

</v-clicks>

---
layout: section
---

# Memory Profilers

---
layout: default
---

# Memory Profilers

<v-clicks>

- Tools designed to track, measure, and analyze memory usage in programs to detect inefficiencies and prevent memory issues like leaks

**Types:**

- Heap
- Stack
- Reference Counting

**Demo:** Memory_profiler demo

</v-clicks>

---
layout: default
---

# Memory Profiling - Details

When developing software, managing memory efficiently is crucial to maintaining performance and stability. Memory profiling tools are essential for tracking, measuring, and analyzing how memory is used by a program.

<v-clicks>

By identifying inefficiencies such as memory leaks or excessive memory usage, these tools help developers optimize their applications and prevent costly runtime issues.

There are three primary types of memory profiling: **heap profiling**, **stack profiling**, and **reference counting**.

</v-clicks>

---
layout: default
---

# Reference Counting

**Reference counting** is a technique used to track how many references exist to an object in memory.

<v-clicks>

- Every time an object is referenced, its count is incremented
- When the reference is no longer in use, the count is decremented
- When the reference count reaches zero, the object can be safely freed
- This approach helps manage memory automatically but requires careful attention to ensure that circular references don't lead to memory leaks

</v-clicks>

---
layout: default
---

# Minimizing Memory Allocations

One important aspect to consider when optimizing memory usage is **avoiding unnecessary allocations**.

<v-clicks>

- Memory allocation, especially in languages with garbage collection, takes time and resources
- Garbage collection cycles, where unused memory is cleaned up, can introduce performance overhead
- Minimizing allocations by reusing memory, using memory pools, or using object pooling techniques can help reduce the need for frequent allocations and recouping during garbage collection
- By reusing memory, we avoid the costs associated with repeated allocations and deallocations, ensuring that the program runs more efficiently

In summary, effective memory profiling tools allow you to identify, manage, and optimize memory usage across the heap, stack, and reference counts. By minimizing unnecessary allocations, you can significantly improve the performance and stability of your application, particularly in memory-intensive environments.

</v-clicks>

---
layout: section
---

# Flame Graphs

---
layout: default
---

# Flame Graphs

<v-clicks>

- Hierarchical visualizations that show how much time a program spends in different functions, with the width of each bar representing the amount of time spent in a particular function or its descendants

- **Y axis:** call stack
- **X axis:** time/sample count proportions (NOT the passage of time)

**How to read:**

- Each box represents a function in the call stack
- Width = how much time was spent there
- Height = call stack depth

- Useful for getting a comprehensive view of your program

</v-clicks>

---
layout: default
---

# Reading Flame Graphs

Flame graphs are a visualization technique for understanding where your program spends time. They show the call stack on the Y-axis and time/sample count on the X-axis, making it easy to identify hot paths in your code.

<v-clicks>

**How to read a flame graph:**

- Each box represents a function in the call stack
- Width of the box = how much time was spent (or how many samples)
- Height = call stack depth (functions calling other functions)
- Colors are usually random (for visual distinction)
- **Look for wide boxes at the top** - these are your bottlenecks

</v-clicks>

---
layout: default
---

# Generating Flame Graphs with py-spy

```bash
# Install py-spy
pip install py-spy

# Profile a running Python program and generate flame graph
py-spy record -o profile.svg --duration 30 -- python your_script.py

# Or attach to a running process
py-spy record -o profile.svg --pid 12345
```

<v-click>

This creates an **interactive SVG file** you can open in your browser. Click on boxes to zoom in and see specific call paths.

</v-click>

---
layout: default
---

# Example Interpretation

**If you see a wide box labeled `json.loads`**, it means your program is spending significant time parsing JSON.

<v-clicks>

**You might optimize by:**

- Parsing JSON once and caching the result
- Using a faster JSON library like `orjson`
- Reducing the amount of JSON data being parsed

</v-clicks>

---
layout: default
---

# Flame Graphs with Linux perf

Flame graphs work well with the `perf` command on Linux:

```bash
# Record performance data
perf record -F 99 -g python your_script.py

# Generate flame graph
# (requires flamegraph.pl from github.com/brendangregg/FlameGraph)
perf script | stackcollapse-perf.pl | flamegraph.pl > flame.svg
```

---
layout: end
class: text-center
---

# Thank You!

CMSC398W - Debugging & Profiling