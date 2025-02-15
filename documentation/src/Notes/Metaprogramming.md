## Build Systems

Imagine you have a set of files that you want to turn into binary exectuables, 
how would you go about doing such? Maybe you would write some commands and execute them?
But what if making there are hundreds of dependencies for that singular file.
Now, you have to execute commands for all of those files that had been updated since your
late build, and then finally build it. This is long and tedious. Is there a way we can automate, 
or at least semi-automate this process to make it easier for us programmers and collaboraters

Build systems are essentially a collection of software tools that is used to faciliate the build process. 
Essentially, they take your source code and convert it to a binary exectuable.
In CMSC 216, you were introduced to Makefiles, a very popular format many build systems use.


## Dependency Management

## Continuous integration systems
As your projects grow larger and more complex, you’ll quickly find that manual tasks pile up whenever you make a change. You might need to upload updated documentation, push a compiled version to a server, release the code to PyPI, run your test suite, and perform various other tasks. Every time someone opens a pull request, you may want their code to be style-checked, or perhaps you need to run benchmarks to make sure performance hasn’t degraded. When you start managing these repetitive tasks, it’s a good idea to explore continuous integration (CI).

Continuous integration, or CI, is a broad term that refers to automating various actions that should occur whenever your code changes. CI helps streamline the development process by running predefined tasks automatically whenever changes happen in your codebase. It allows you to continuously test, build, and deploy your project with minimal manual intervention. These tasks could include running unit tests, checking code quality, compiling code, and even deploying updates to production or staging environments.

Several services provide CI tools, often with free offerings for open-source projects. Popular CI services include Travis CI, Azure Pipelines, GitHub Actions, CircleCI, and Jenkins. These services work similarly, but each offers its unique features and integrations. For example, GitHub Actions integrates seamlessly with GitHub repositories, while Travis CI is known for its simplicity and ease of setup.

Setting up a CI system usually involves adding a configuration file to your repository. This file describes the actions to perform when specific events occur, such as pushing code or opening a pull request. For example, you might configure your CI to run your test suite automatically whenever a new commit is pushed to the repository. The CI service then spins up virtual machines or containers, runs your tests, and provides feedback on whether the tests pass or fail. Some CI systems also provide the option to notify you via email or messaging platforms like Slack if something goes wrong.

## GitHub Actions Workflow Configuration Breakdown
### 1. Trigger Section
```yaml
name: Continuous Integration

on:
  push:
    branches:
      - main  # Trigger the CI on push events to the main branch
  pull_request:
    branches:
      - main  # Trigger the CI when a pull request is opened against the main branch
```
#### Explanation:
- The `name` section specifies the name of the workflow, in this case, `Continuous Integration`
- The `on` section defines when the workflow should be triggered. In this case:
  - `push`: The workflow will run whenever there is a push to the `main` branch.
  - `pull_request`: The workflow will also run when a pull request is created or updated targeting the `main` branch.
- This ensures that both direct code changes (pushes) and changes made via pull requests are tested.

---

### 2. Job Definition and Runner
```yaml
jobs:
  test:
    runs-on: ubuntu-latest  # The job will run on the latest Ubuntu runner provided by GitHub Actions
```
#### Explanation:
- `jobs`: This section defines the jobs that will run as part of the workflow. Each job contains a set of steps.
- `test`: This is the name of the job.
- `runs-on`: Specifies the virtual machine (VM) environment for the job. In this case, `ubuntu-latest` is used, meaning the job will run on the latest version of Ubuntu available.

---

### 3. Checking Out the Code
```yaml
steps:
  - name: Checkout code
    uses: actions/checkout@v2  # This action checks out the repository code into the runner's workspace
    with:
      ref: ${{ github.sha }}  # Ensure the exact commit is checked out
```
#### Explanation:
- `steps`: A job consists of a series of steps that define the individual tasks to be run.
- `Checkout Code`: This step uses the `actions/checkout@v2` action, which checks out the code from the repository so that it can be used in subsequent steps.
- `ref: ${{ github.sha }}`: Ensures the exact commit that triggered the workflow is used (based on the SHA of the commit). This is especially useful in pull requests or when working with multiple branches.

---

### 4. Setting Up Python
```yaml
  - name: Set up Python
    uses: actions/setup-python@v2  # This action sets up a specific Python version
    with:
      python-version: 3.8  # Specify the Python version to install
      cache: 'pip'  # Enables caching of pip dependencies
```
#### Explanation:
- `Set up Python`: This step uses the `actions/setup-python@v2` action to install the specified Python version (in this case, Python 3.8).
- `python-version: 3.8`: This ensures the environment has Python 3.8 installed, which is necessary for running the tests.
- `cache: 'pip'`: Enabling pip caching will speed up future builds by storing installed dependencies in the cache, so they don’t have to be reinstalled every time the workflow runs.

---

### 5. Installing Dependencies
```yaml
  - name: Install dependencies
    run: |
      python -m pip install --upgrade pip  # Upgrade pip to the latest version
      pip install -r requirements.txt  # Install all dependencies from requirements.txt
```
#### Explanation:
- `Install dependencies`: This step runs a series of shell commands to install the necessary Python packages.
  - `python -m pip install --upgrade pip`: Upgrades pip to the latest version to ensure compatibility with the latest Python packages.
  - `pip install -r requirements.txt`: Installs the dependencies listed in the `requirements.txt` file, which is typically where you specify the Python packages required for the project.

---

### 6. Running Tests
```yaml
 - name: Run tests
    run: |
      pytest --maxfail=1 --disable-warnings --cov=my_module  # Run tests with additional options
    env:
      PYTHONPATH: .  # Set the PYTHONPATH to the root of the repository (optional, based on project structure)
```
#### Explanation:
- `Run tests`: This step runs the pytest testing framework to execute tests in the repository.
  - `--maxfail=1`: This option makes pytest stop after the first failure, which can help you quickly identify issues without waiting for the entire test suite to run.
  - `--disable-warnings`: Suppresses warnings during the test run, making the output cleaner and easier to read.
  - `--cov=my_module`: This tracks code coverage for the specified module (in this case, `my_module`). Replace it with your actual module to gather coverage data.
- `env: PYTHONPATH: .`: This ensures the Python path is set to the root of the repository. This is useful if the project structure requires it (e.g., for modules in subdirectories).

---

### 7. Uploading Test Results (Optional)
```yaml
  - name: Upload test results
    if: always()  # Ensures this step runs even if tests fail
    uses: actions/upload-artifact@v3  # Uploads test results as artifacts for debugging
    with:
      name: test-results
      path: pytest-report.xml  # Path to your pytest XML report
```
#### Explanation:
- `Upload test results`: This step uploads test results as artifacts, making them available for later review.
  - `if: always()`: This condition ensures that this step will run even if the tests fail, which is useful for debugging.
  - `uses: actions/upload-artifact@v3`: Uses the upload-artifact action to upload files as build artifacts.
  - `name: test-results`: This names the artifact to be uploaded.
  - `path: pytest-report.xml`: This specifies the path to the file containing test results (e.g., a pytest XML report).

---
### 8. Sending Slack Notifications (Optional):
```yaml
## 8. Sending Slack Notifications (Optional)
  - name: Send test results to Slack (optional)
    if: success()  # Only run if the tests pass
    uses: 8398a7/action-slack@v3  # Sends a Slack notification about the success of the tests
    with:
      slack_webhook_url: ${{ secrets.SLACK_WEBHOOK_URL }}  # The Slack webhook URL to post the message
      status: success  # Customize the message (use 'failure' for failed builds)
```
#### Explanation:
- `Send Slack notifications`: This step sends a notification to a Slack channel when the tests pass.
  - `if: success()`: The notification is only sent if the tests are successful.
  - `uses: 8398a7/action-slack@v3`: This action sends messages to Slack.
  - `slack_webhook_url: ${{ secrets.SLACK_WEBHOOK_URL }}`: The Slack webhook URL is stored as a secret for security reasons.
  - `status: success`: Specifies the message to be sent (in this case, `success`). You can change it to 'failure' for a failed build.

---

### 9. Clean Up
```yaml
  - name: Clean up
    run: |
      rm -rf .pytest_cache  # Clean up pytest cache to keep the workspace tidy
```
#### Explanation:
- `Clean up`: This step removes temporary files or caches created during the workflow run.
  - `rm -rf .pytest_cache`: Removes the pytest cache, which can grow in size over time and isn’t needed after the tests have completed.

---
Each of these steps ensures that your CI pipeline is thorough, efficient, and easy to debug, with added capabilities like notifications and result uploads.
