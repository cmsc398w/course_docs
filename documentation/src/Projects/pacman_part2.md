# Pac-Man Project - Part 2: Updates, Git Workflow, and Securing Sensitive Information

## **Overview**

In Part 2 of the Pac-Man Project, you will work with your team to implement updates and enhancements to the Pac-Man game. This part focuses on:

1. Updating code and assets (e.g., renaming elements, adding new features).
2. Collaborating with your team using Git, including Git rebasing and handling branches.
3. Securing sensitive information, such as private assets, and cleaning up the Git history to ensure no sensitive data is exposed.

---

## **Objectives**

1. **Rename components and implement updates**
2. **Rebase your branches**
3. **Sensitive Information Handling**
4. **Write a working CI/CD pipeline to automate testing**
5. **Pull requests and code reviews**

---

## **Steps for Part 2**

### **1. Update and Rename Components - 20 points**

Uh oh, we forgot that player should actually be named Pacman. Rename all appropriate files, branches, code, and dependencies to reflect this name change. Ensure you maintain a clean Git history in this process.

### **2. Merge Upstream Changes - 30 points**

In the past week we've found numerous bugs (thanks to your help!) from the original codebase and squashed them. Merge these changes from the upstream repository into your own repository to incorporate these bug fixes. **Hint**: This is why it was important to set the base repository as the upstream remote.

Steps to merge:

1. Ensure your upstream remote is properly configured
2. Fetch the latest changes from upstream
3. Merge the upstream changes into your main branch
4. Resolve any merge conflicts if they arise
5. Test your game to ensure the bug fixes are working as expected

### **3. Sensitive Information Handling - 40 points**

Uh oh! We've accidentally included a .env file containing sensitive information about PacMan that in the repositories. To make sure that evil Ghosts online can't learn this sensitive information you must modify your repository to ensure that the .env file is no longer tracked by Git. Additionally, you need to clean up your Git history so Ghosts online can't go to a previous commit and find the .env file.

Note: In the real world, if you end up pushing sensitive material to GitHub, especially if it's a public repository, consider those credentials lost, invalidate them immediately, follow whatever security reporting procedures your company follows. Even if you completely scrub your Git history, there are automated scrapers for things like API keys, if the code was accessible for even an hour.

### **4. GitHub Actions Workflow - 25 points**

The project uses GitHub Actions for continuous integration. You will make a CI file `.github/workflows/ci.yml`, and you need to fill it in to make it functional.

Your Goals:

1. **Triggering Events**
    * The workflow should run in response to the following events:
        * **Push**: When code is pushed to the main branch.
        * **Pull Request**: When a pull request is opened that targets the main branch.
2. **Job Setup**
    * The job should run on an `ubuntu-latest` runner.
    * Run the job for Python 3.10

3. **Steps**
    1. Checkout the Code
        * Use the `actions/checkout` action to check out the repository's code.

    2. Setup Python Environment
        * Use the `actions/setup-python` action to set up the Python version
    3. Install System Dependencies
        * Install the following system dependencies:
            1. **python3-pygame**: A library used for game development in Python.
            2. **xvfb**: A virtual framebuffer required for running tests in a headless environment.
        ```bash
        sudo apt-get update
        sudo apt-get install -y python3-pygame
        sudo apt-get install -y xvfb
        ```
    4. Install Python Dependencies
        ```bash
        python -m pip install --upgrade pip
        pip install pytest
        pip install pytest-cov
        pip install flake8
        pip install black
        pip install pygame
        ```
    5. Check Code Formatting with Black
        * If the code is not properly formatted, it should fail the CI run and display the differences
        ```bash
        black --check --diff .
        ```
    6. Lint the Code with Flake8
        * Run flake8 to check for Python syntax errors and undefined names. Ensure the build fails if any critical issues are found. Additionally, run flake8 again with more lenient rules to check for complexity, line length, and general style.
        ```bash
        # stop the build if there are Python syntax errors or undefined names
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        # exit-zero treats all errors as warnings
        flake8 . --count --exit-zero --max-complexity=30 --max-line-length=100 --statistics
        ```
    7. Run tests with pytest
        * Use pytest to run the tests and generate a coverage report in XML format. Since the project involves graphical elements, use xvfb-run to run the tests in a virtual framebuffer, ensuring the tests can be executed in a headless environment.
        ```bash
        xvfb-run -a pytest --cov=./ --cov-report=xml
        ```

    **Notes**
    * The commands for installing dependencies and running tests are provided, but your focus is on writing the correct workflow structure in the YML file.
    * Make sure the pipeline runs in the right order and follows best practices for CI configuration.


### 5. **Pull requests and code reviews - 10 points**: 

If needed, make sure you make pull requests and conduct code reviews for this project.