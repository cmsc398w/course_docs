# Debugging and Profiling

## The Diagnostic Mindset

Software will execute exactly as instructed, regardless of the programmer's intentions. Debugging bridges the gap between intended and actual behavior, and while this process can be time-intensive, there are effective techniques for identifying and resolving issues in buggy or resource-intensive code. Often times, debugging can be seen as a reactive process that slows down development, but implementing systematic debugging practices accelerates development cycles and reduces time spent tracking down issues.

### A Systematic Approach (Observe, Hypothesize, Test)

Effective debugging follows a methodical process rather than random trial and error. The systematic approach consists of five key steps:

1. **Reproduce consistently** - If you can't reliably reproduce the bug, you can't verify your fix. Document the exact steps, inputs, and environment that trigger the issue.
2. **Isolate the problem** - Use binary search through your code. Comment out half the functionality, see if the bug persists, and narrow down the problematic section.
3. **Form a hypothesis** - Based on symptoms and isolated code, develop a theory about what's wrong. "I think the null pointer occurs because the API returns empty data."
4. **Test the hypothesis** - Add logging, use a debugger, or write a minimal test case to prove or disprove your theory. Make one change at a time.
5. **Fix and verify** - Once confirmed, implement the fix and verify it resolves the issue without breaking other functionality. Run related tests.

Example: Suppose your web app crashes when processing user uploads. You reproduce it (step 1), isolate it to the file parsing function (step 2), hypothesize that large files cause memory issues (step 3), confirm by testing with various file sizes (step 4), and implement streaming processing instead of loading entire files into memory (step 5).

## Debugging Fundamentals

### Print Debugging & Logging

As Brian Kernighan noted in "Unix for Beginners" (1979), "The most effective debugging tool is still careful thought, coupled with judiciously placed print statements." The simplest approach to debugging involves adding print statements near suspected problem areas and iterating until sufficient information is gathered to identify the root cause. This method's simplicity and ease of implementation make it a preferred choice for many software engineers.

Print debugging can be enhanced by implementing proper logging instead of simple print statements. Logging systems offer several advantages over basic printing: they can output to multiple destinations including files, sockets, and remote servers, making log review more convenient than scanning terminal output. They also support severity levels (INFO, DEBUG, WARN, ERROR) for filtered output, and they establish a logging infrastructure that can serve both immediate debugging needs and long-term monitoring requirements.

If used correctly, logging can significantly increase development velocity. Below, are a few tips to help make logs more useful:

* Set log levels properly to allow you to filter out unnecessary messages (ex. diagnostic messages) to help you narrow down to the actual issue.
* Many libraries support structured logging, a method of organizing log data into a structured format, making it easier to analyze and interpret. Instead of recording raw text, structured logging uses key-value pairs which provide context and additional information about the logged event. The structured nature makes it easier to search, filter and analyze logs.
* You want to always be able to find the source code for any given log entry. This means using unique messages, prefixes, etc. which will help you trace a code path using log messages. This is more difficult if multiple places create the same log entry.
* Use a log viewer to make it easier to process and view logs
* It can be useful (especially in a web-development context) to use a correlation id to track a request throughout the entire transaction.
* Logging should not be competing with your software for resources. Use logging levels strategically as well as opting for accumulated metrics over textual logs as needed.
* Never log sensitive information.
* Only log what you need but finding out what you actually need is an iterative process.

Here's a practical example demonstrating different log levels:

```python
import logging

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

def process_user_data(user_id, data):
    logger.debug(f"Starting to process data for user {user_id}")

    if not data:
        logger.warning(f"User {user_id} submitted empty data")
        return None

    try:
        # Simulate processing
        result = {"user_id": user_id, "processed": len(data)}
        logger.info(f"Successfully processed {len(data)} items for user {user_id}")
        return result
    except Exception as e:
        logger.error(f"Failed to process data for user {user_id}: {e}")
        raise

# Run with different scenarios
process_user_data(123, ["item1", "item2", "item3"])
process_user_data(456, [])
```

Run this script to see all log levels:
```bash
$ python logging_demo.py
```

You can change the logging level to `logging.INFO` to filter out DEBUG messages:
```bash
# Edit the script to change level=logging.DEBUG to level=logging.INFO
# Then run again to see only INFO, WARNING, and ERROR messages
$ python logging_demo.py
```

Or set to `logging.WARNING` to see only warnings and errors. This makes it easy to control verbosity in development vs. production environments.

#### External Logging

When working with external dependencies like web servers, databases, or containerized services, you'll often need to check their logs since client-side error messages may not provide enough detail. Most programs write logs to `/var/log` on UNIX systems, and modern containerized applications expose logs through commands like `docker logs <container-name>`.

### Interactive Debuggers

When print debugging is not enough you should use a debugger. Debuggers are programs that let you interact with the execution of a program, allowing the following:

* Halt execution of the program when it reaches a certain line.
* Step through the program one instruction at a time.
* Inspect values of variables after the program crashed.
* Conditionally halt the execution when a given condition is met.
* And many more advanced features

Many programming languages come with some form of debugger.

#### Core Concepts (Stepping, State Inspection, Call Stack)

Debuggers allow you to pause program execution at breakpoints, then step through code line by line. Key operations include "Step Over" (execute the current line including any function calls), "Step Into" (enter a function to debug its internals), and "Step Out" (continue until the current function returns). While paused, you can inspect the call stack (the sequence of function calls that led to the current point), examine and modify variable values, and set watch expressions to monitor specific values as the program executes.

#### Advanced Breakpoints (Conditional, Hit Count, Logpoints)

Conditional breakpoints extend the basic breakpoint concept by adding programmable conditions. Instead of stopping every time a particular line is reached, the debugger only halts execution when the specified condition is true. For example, a conditional breakpoint might only trigger when a variable reaches a certain value or when a specific error condition occurs. This capability is especially valuable when debugging issues that only manifest under specific circumstances or when dealing with code that executes frequently but only occasionally exhibits problematic behavior.

**Hit count breakpoints** pause execution only after a line has been hit a certain number of times. This is useful when debugging loops - for example, breaking only on the 100th iteration when you suspect an issue occurs after many iterations.

**Logpoints** (also called tracepoints) allow you to log messages to the console without stopping execution and without modifying your source code. Instead of adding print statements and rerunning your program, you can inject logging at any point during a debugging session.

#### Hands-On: Using Python's pdb

Python's built-in debugger `pdb` provides an interactive debugging experience. Here's a buggy program and how to debug it:

```python
# buggy_calculator.py
def calculate_average(numbers):
    total = 0
    for num in numbers:
        total += num
    return total / len(numbers)

def process_data(data):
    results = []
    for item in data:
        avg = calculate_average(item['values'])
        results.append({'name': item['name'], 'average': avg})
    return results

if __name__ == '__main__':
    data = [
        {'name': 'dataset1', 'values': [1, 2, 3, 4, 5]},
        {'name': 'dataset2', 'values': []},  # This will cause an error!
        {'name': 'dataset3', 'values': [10, 20, 30]}
    ]
    print(process_data(data))
```

To debug with pdb, you can either:
1. Run with `python -m pdb buggy_calculator.py`
2. Add `import pdb; pdb.set_trace()` where you want to break

```python
def calculate_average(numbers):
    import pdb; pdb.set_trace()  # Execution will pause here
    total = 0
    for num in numbers:
        total += num
    return total / len(numbers)
```

Common pdb commands:
- `l` (list) - Show current code context
- `n` (next) - Execute current line (step over)
- `s` (step) - Step into function calls
- `c` (continue) - Continue execution until next breakpoint
- `p variable_name` - Print variable value
- `pp variable_name` - Pretty-print variable value
- `w` (where) - Show call stack
- `b line_number` - Set breakpoint at line number
- `b function_name` - Set breakpoint at function
- `condition bp_number condition` - Make breakpoint conditional


### Specialized Tools

#### System Call Tracers (strace, dtrace)

Even if what you are trying to debug is a black box binary there are tools that can help you with that. Whenever programs need to perform actions that only the kernel can, they use [System Calls](https://en.wikipedia.org/wiki/System_call). There are commands that let you trace the syscalls your program makes. In Linux there's [`strace`](https://www.man7.org/linux/man-pages/man1/strace.1.html) and macOS and BSD have [`dtrace`](http://dtrace.org/blogs/about/). `dtrace` can be tricky to use because it uses its own `D` language, but there is a wrapper called [`dtruss`](https://www.manpagez.com/man/1/dtruss/) that provides an interface more similar to `strace` (more details [here](https://8thlight.com/blog/colin-jones/2015/11/06/dtrace-even-better-than-strace-for-osx.html)).

Below are some examples of using `strace` or `dtruss` to show [`stat`](https://www.man7.org/linux/man-pages/man2/stat.2.html) syscall traces for an execution of `ls`. For a deeper dive into `strace`, [this article](https://blogs.oracle.com/linux/strace-the-sysadmins-microscope-v2) and [this zine](https://jvns.ca/strace-zine-unfolded.pdf) are good reads.

```bash
# On Linux
sudo strace -e lstat ls -l > /dev/null
# On macOS
sudo dtruss -t lstat64_extended ls -l > /dev/null
```

Here's a practical example debugging why a Python script is slow. First, create a simple script:

```python
# slow_script.py
with open('/etc/hosts', 'r') as f:
    for line in f:
        pass
```

Now trace it with strace to see what system calls it makes:

```bash
$ strace -c python slow_script.py
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 34.21    0.000026          13         2           read
 23.68    0.000018           9         2           openat
 15.79    0.000012          12         1           write
  ...
```

The `-c` flag provides a summary. You can also see individual calls with `-e trace=openat,read` to focus on specific syscalls. This helps identify if your program is doing excessive file I/O, network calls, or other system operations.

#### Web Development Tools

Browser developer tools (Chrome DevTools, Firefox Developer Tools) are essential for web development debugging. Here's a practical walkthrough of common debugging scenarios:

**Debugging JavaScript:**
1. Open DevTools (F12 or Ctrl+Shift+I / Cmd+Option+I)
2. Go to the Sources tab
3. Find your JavaScript file in the file tree
4. Click on a line number to set a breakpoint
5. Refresh the page - execution will pause at your breakpoint
6. Use the controls to step through code, inspect variables in the Scope panel
7. Use the Console to evaluate expressions in the current context

**Debugging Network Requests:**
1. Open the Network tab
2. Perform the action that triggers the request (e.g., submit a form, click a button)
3. Click on the request to see:
   - Headers (request/response headers)
   - Preview (formatted response)
   - Response (raw response)
   - Timing (how long each phase took)
4. Right-click a request and select "Copy as cURL" to replay it from the command line
5. Use "Preserve log" to keep requests across page navigations

**Common Use Cases:**
- **API debugging**: Check if your frontend is sending the correct data, verify response structure
- **Performance issues**: Use the Network tab's timing column to find slow requests
- **Cookie/Storage issues**: Application tab shows cookies, localStorage, sessionStorage
- **JavaScript errors**: Console tab shows errors with stack traces; click to jump to the problematic line
- **Live editing**: Modify CSS in the Elements tab or JavaScript in Sources to test fixes without redeploying

## Performance Profiling

Even if your code functionally behaves as you would expect, that might not be good enough if it takes all your CPU or memory in the process. Algorithms classes often teach big _O_ notation but not how to find hot spots in your programs. Since [premature optimization is the root of all evil](http://wiki.c2.com/?PrematureOptimization), you should learn about profilers and monitoring tools. They will help you understand which parts of your program are taking most of the time and/or resources so you can focus on optimizing those parts.

### Key Profiling Areas

#### CPU Profiling (incl. Real/User/Sys Time)

##### Timing

Similarly to the debugging case, in many scenarios it can be enough to just print the wall clock time it took your code between two points. However, wall clock time can be misleading since your computer might be running other processes at the same time or waiting for events to happen. It is common for tools to make a distinction between _Real_, _User_ and _Sys_ time. In general, _User_ + _Sys_ tells you how much time your process actually spent in the CPU (more detailed explanation [here](https://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1)).

* _Real_ - Wall clock elapsed time from start to finish of the program, including the time taken by other processes and time taken while blocked (e.g. waiting for I/O or network)
* _User_ - Amount of time spent in the CPU running user code
* _Sys_ - Amount of time spent in the CPU running kernel code

For example, try running a command that performs an HTTP request and prefixing it with [`time`](https://www.man7.org/linux/man-pages/man1/time.1.html). Under a slow connection it can take over 2 seconds for the request to complete but the process itself will only take ~15ms of CPU user time and 12ms of kernel CPU time.

##### CPU Profilers

Most of the time when people refer to _profilers_ they actually mean _CPU profilers_,  which are the most common. There are two main types of CPU profilers: _tracing_ and _sampling_ profilers. Tracing profilers keep a record of every function call your program makes whereas sampling profilers probe your program periodically (commonly every millisecond) and record the program's stack. They use these records to present aggregate statistics of what your program spent the most time doing. [Here](https://jvns.ca/blog/2017/12/17/how-do-ruby---python-profilers-work-) is a good intro article if you want more detail on this topic.

In Python we can use the `cProfile` module to profile time per function call. Here is a simple example that implements a rudimentary grep in Python:

```python
#!/usr/bin/env python

import sys, re

def grep(pattern, file):
    with open(file, 'r') as f:
        print(file)
        for i, line in enumerate(f.readlines()):
            pattern = re.compile(pattern)
            match = pattern.search(line)
            if match is not None:
                print("{}: {}".format(i, line), end="")

if __name__ == '__main__':
    times = int(sys.argv[1])
    pattern = sys.argv[2]
    for i in range(times):
        for file in sys.argv[3:]:
            grep(pattern, file)
```

We can profile this code using the following command. Analyzing the output we can see that IO is taking most of the time and that compiling the regex takes a fair amount of time as well.

```
$ python -m cProfile -s tottime grep.py 1000 '^(import|\s*def)[^,]*$' *.py

[omitted program output]

 ncalls  tottime  percall  cumtime  percall filename:lineno(function)
     8000    0.266    0.000    0.292    0.000 {built-in method io.open}
     8000    0.153    0.000    0.894    0.000 grep.py:5(grep)
    17000    0.101    0.000    0.101    0.000 {built-in method builtins.print}
     8000    0.100    0.000    0.129    0.000 {method 'readlines' of '_io._IOBase' objects}
    93000    0.097    0.000    0.111    0.000 re.py:286(_compile)
    93000    0.069    0.000    0.069    0.000 {method 'search' of '_sre.SRE_Pattern' objects}
    93000    0.030    0.000    0.141    0.000 re.py:231(compile)
    17000    0.019    0.000    0.029    0.000 codecs.py:318(decode)
        1    0.017    0.017    0.911    0.911 grep.py:3(<module>)

[omitted lines]
```

Notice that `re.py:286(_compile)` is called 93,000 times! The regex is being recompiled on every line. Let's fix this:

```python
def grep(pattern, file):
    regex = re.compile(pattern)  # Compile once, outside the loop
    with open(file, 'r') as f:
        print(file)
        for i, line in enumerate(f.readlines()):
            match = regex.search(line)  # Use the compiled regex
            if match is not None:
                print("{}: {}".format(i, line), end="")
```

After the optimization, profiling again shows:

```
 ncalls  tottime  percall  cumtime  percall filename:lineno(function)
     8000    0.234    0.000    0.259    0.000 {built-in method io.open}
     8000    0.116    0.000    0.642    0.000 grep.py:5(grep)
    17000    0.098    0.000    0.098    0.000 {built-in method builtins.print}
    93000    0.067    0.000    0.067    0.000 {method 'search' of '_sre.SRE_Pattern' objects}
     8000    0.055    0.000    0.070    0.000 {method 'readlines' of '_io._IOBase' objects}
        8    0.026    0.003    0.029    0.004 {built-in method _sre.compile}
     ...
```

The `_sre.compile` calls dropped from 93,000 to 8 (once per file), and total time improved significantly. This demonstrates how profiling identifies bottlenecks and validates optimizations.

A caveat of Python's `cProfile` profiler (and many profilers for that matter) is that they display time per function call. That can become unintuitive really fast, especially if you are using third party libraries in your code since internal function calls are also accounted for.
A more intuitive way of displaying profiling information is to include the time taken per line of code, which is what _line profilers_ do.

For instance, the following piece of Python code performs a request to the class website and parses the response to get all URLs in the page:

```python
#!/usr/bin/env python
# urls.py
import requests
from bs4 import BeautifulSoup

# This is a decorator that tells line_profiler
# that we want to analyze this function
@profile
def get_urls():
    response = requests.get('https://missing.csail.mit.edu')
    s = BeautifulSoup(response.content, 'lxml')
    urls = []
    for url in s.find_all('a'):
        urls.append(url['href'])

if __name__ == '__main__':
    get_urls()
```

If we used Python's `cProfile` profiler we'd get over 2500 lines of output, and even with sorting it'd be hard to understand where the time is being spent. First install line_profiler (`pip install line_profiler`), then run it:

```bash
$ kernprof -l -v urls.py
Wrote profile results to urls.py.lprof
Timer unit: 1e-06 s

Total time: 0.636188 s
File: a.py
Function: get_urls at line 5

Line #  Hits         Time  Per Hit   % Time  Line Contents
==============================================================
 5                                           @profile
 6                                           def get_urls():
 7         1     613909.0 613909.0     96.5      response = requests.get('https://missing.csail.mit.edu')
 8         1      21559.0  21559.0      3.4      s = BeautifulSoup(response.content, 'lxml')
 9         1          2.0      2.0      0.0      urls = []
10        25        685.0     27.4      0.1      for url in s.find_all('a'):
11        24         33.0      1.4      0.0          urls.append(url['href'])
```

#### Memory Profiling

In languages like C or C++ memory leaks can cause your program to never release memory that it doesn't need anymore.
To help in the process of memory debugging you can use tools like [Valgrind](https://valgrind.org/) that will help you identify memory leaks.

In garbage collected languages like Python it is still useful to use a memory profiler because as long as you have pointers to objects in memory they won't be garbage collected.
Here's an example program and its associated output when running it with [memory-profiler](https://pypi.org/project/memory-profiler/) (note the decorator like in `line-profiler`). First, install it: `pip install memory-profiler`

```python
@profile
def my_func():
    a = [1] * (10 ** 6)
    b = [2] * (2 * 10 ** 7)
    del b
    return a

if __name__ == '__main__':
    my_func()
```

```bash
$ python -m memory_profiler example.py
Line #    Mem usage  Increment   Line Contents
==============================================
     3                           @profile
     4      5.97 MB    0.00 MB   def my_func():
     5     13.61 MB    7.64 MB       a = [1] * (10 ** 6)
     6    166.20 MB  152.59 MB       b = [2] * (2 * 10 ** 7)
     7     13.61 MB -152.59 MB       del b
     8     13.61 MB    0.00 MB       return a
```

Here's a more realistic example showing a memory leak in a web application:

```python
# memory_leak.py
cache = []  # Global cache that grows unbounded

@profile
def process_requests():
    for i in range(1000):
        data = fetch_data(i)  # Simulates fetching data
        cache.append(data)  # Memory leak: never cleaned up
        result = analyze(data)

def fetch_data(id):
    return [id] * 10000  # Simulate large data

def analyze(data):
    return sum(data)

if __name__ == '__main__':
    process_requests()
```

Running memory profiler reveals the leak:

```bash
$ python -m memory_profiler memory_leak.py
Line #    Mem usage  Increment   Line Contents
==============================================
     3                           @profile
     4     14.1 MB    0.0 MB    def process_requests():
     5     14.1 MB    0.0 MB        for i in range(1000):
     6     90.2 MB   76.1 MB            data = fetch_data(i)
     7     90.2 MB    0.0 MB            cache.append(data)  # Memory keeps growing!
     8     90.2 MB    0.0 MB            result = analyze(data)
```

The fix: implement a bounded cache or clear old entries:

```python
from collections import deque

cache = deque(maxlen=100)  # Only keep last 100 items
```

#### Event & I/O Profiling

As it was the case for `strace` for debugging, you might want to ignore the specifics of the code that you are running and treat it like a black box when profiling.
The [`perf`](https://www.man7.org/linux/man-pages/man1/perf.1.html) command abstracts CPU differences away and does not report time or memory, but instead it reports system events related to your programs.
For example, `perf` can easily report poor cache locality, high amounts of page faults or livelocks. Here is an overview of the command:

* `perf list` - List the events that can be traced with perf
* `perf stat COMMAND ARG1 ARG2` - Gets counts of different events related to a process or command
* `perf record COMMAND ARG1 ARG2` - Records the run of a command and saves the statistical data into a file called `perf.data`
* `perf report` - Formats and prints the data collected in `perf.data`

### Visualizing Performance: Flame Graphs

Flame graphs are a visualization technique for understanding where your program spends time. They show the call stack on the Y-axis and time/sample count on the X-axis, making it easy to identify hot paths in your code.

**How to read a flame graph:**
- Each box represents a function in the call stack
- Width of the box = how much time was spent (or how many samples)
- Height = call stack depth (functions calling other functions)
- Colors are usually random (for visual distinction)
- Look for wide boxes at the top - these are your bottlenecks

**Generating flame graphs with py-spy:**

```bash
# Install py-spy
pip install py-spy

# Profile a running Python program and generate flame graph
py-spy record -o profile.svg --duration 30 -- python your_script.py

# Or attach to a running process
py-spy record -o profile.svg --pid 12345
```

This creates an interactive SVG file you can open in your browser. Click on boxes to zoom in and see specific call paths.

**Example interpretation:**
If you see a wide box labeled `json.loads`, it means your program is spending significant time parsing JSON. You might optimize by:
- Parsing JSON once and caching the result
- Using a faster JSON library like `orjson`
- Reducing the amount of JSON data being parsed

Flame graphs work well with the `perf` command on Linux:

```bash
# Record performance data
perf record -F 99 -g python your_script.py

# Generate flame graph (requires flamegraph.pl from github.com/brendangregg/FlameGraph)
perf script | stackcollapse-perf.pl | flamegraph.pl > flame.svg
```

### Resource Monitoring

Sometimes, the first step towards analyzing the performance of your program is to understand what its actual resource consumption is. Programs often run slowly when they are resource constrained, e.g. without enough memory or on a slow network connection.

**Essential monitoring tools:**

**[`htop`](https://htop.dev/)** - Interactive process viewer showing CPU, memory, and process information in real-time
- Press `F6` to sort by different columns (CPU%, MEM%, TIME)
- Press `t` to show process tree hierarchy
- Press `h` for help with all keybindings
- Use this when: Your program is slow and you want to see if it's using all CPU or running out of memory

```bash
# Example: Find which process is using the most CPU
htop  # then press F6 and select CPU%
```

**[`du`](http://man7.org/linux/man-pages/man1/du.1.html)** - Disk usage analyzer
- `du -h` shows human-readable sizes
- `du -sh *` shows size of each item in current directory
- Use this when: Your disk is full and you need to find large directories

```bash
# Find largest directories in your home folder
du -h ~ | sort -h | tail -20
```

**[`lsof`](https://www.man7.org/linux/man-pages/man8/lsof.8.html)** - List open files and which processes have them open
- `lsof /path/to/file` shows which process is using a file
- `lsof -i :8080` shows what process is using port 8080
- Use this when: You get "file in use" errors or need to find what's using a port

```bash
# Find what's running on port 3000
lsof -i :3000

# Example output:
# COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# node    12345 user   23u  IPv4 123456      0t0  TCP *:3000 (LISTEN)
```
