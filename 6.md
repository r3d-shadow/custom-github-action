# Creating and Publishing a Custom GitHub Action

[Github Repo Link](https://github.com/r3d-shadow/custom-github-action)

GitHub Actions enables workflow automation within repositories, allowing developers to build, test, and deploy applications efficiently. This guide provides a step-by-step approach to creating a custom GitHub Action, testing it locally, and publishing it to the GitHub Marketplace.

## Step 1: Setting Up a Custom GitHub Action

Start by creating a new repository on GitHub to store the action. Inside the repository, maintain the following folder structure:

```bash
├── .github
│   └── workflows
│       └── greet-action.yml
├── action.yml
├── Dockerfile
├── entrypoint.sh
└── README.md
```

### Defining the Action

Every GitHub Action requires a metadata file `action.yml` to define its behavior:

```yaml
name: "Greet Action"
description: "A GitHub Action that prints a personalized greeting message."
author: "Safeer S"
branding:
  icon: "activity"
  color: "blue"
inputs:
  message:
    description: "The message to display in logs"
    required: true
  name:
    description: "The recipient's name."
    required: true
runs:
  using: "docker"
  image: "Dockerfile"
  args:
    - ${{ inputs.name }}
    - ${{ inputs.message }}
```

This configuration defines essential metadata, including the action's name, description, and author details. It accepts two required input parameters: message and name. The message input specifies the text to be displayed in the logs, while name represents the recipient. The action runs inside a custom Docker container, as specified by the `Dockerfile`, and passes the inputs as arguments during execution. Branding details enhance visibility when published to the GitHub Marketplace.

### Writing the Dockerfile

```bash
FROM alpine:3.18.3
# Default Environment Variables
ENV GITHUB_REPOSITORY=${GITHUB_REPOSITORY}
ENV GITHUB_SHA=${GITHUB_SHA}
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh  
ENTRYPOINT ["/entrypoint.sh"]
```

This configuration utilizes a minimal Alpine image, ensuring a lightweight runtime. It sets necessary GitHub environment variables and designates `entrypoint.sh` as the execution script. The script is responsible for executing the action logic:

### The Entrypoint Script

```bash
#!/bin/sh
set -eo pipefail
# $1 - First argument (name)
# $2 - Second argument (message)
echo "Hello, $1! $2"
```

This script takes two arguments: a name and a message. The script then prints a personalized greeting using these inputs, forming the core functionality of the action.

### Testing the Action

To test our Action, we define `greet-action.yml` inside `.github/workflows/`

```yaml
name: greet-action
on:
  workflow_dispatch:
jobs:
  greet:
    name: "Test: Greet Action"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      - name: Run Greet Action
        uses: ./
        with:
          name: "Safeer"
          message: "Welcome to GitHub Actions!"
```

This workflow tests the Greet Action by invoking it with predefined inputs by using a local reference.

Go to GitHub Actions, select "Greet Action," and click "Run Workflow."

![/assets/1.png](/assets/1.png)

After execution, navigate to the logs to verify the output message.

![/assets/2.png](/assets/2.png)

## Step 2: Publishing to the GitHub Marketplace

To make the Action publicly available, open [GitHub Marketplace](https://github.com/marketplace) and select **"Create a new extension."**

![/assets/3.png](/assets/3.png)

Choose the action created earlier and click **"Publish Action."**

![/assets/4.png](/assets/4.png)

Draft a new release

![/assets/5.png](/assets/5.png)

Check the **"Publish this release to GitHub Marketplace"** option, ensure all requirements are met, select appropriate categories, and proceed with publishing.

![/assets/6.png](/assets/6.png)

Before that, accept the **GitHub Marketplace Developer Agreement.**

![/assets/7.png](/assets/7.png)

After publishing, the release page will display a **Marketplace** label.

![/assets/8.png](/assets/8.png)

Click on it to view the listed action in GitHub Marketplace.

![/assets/9.png](/assets/9.png)

### Testing the Published Action

To verify the published action, create a workflow referencing it directly from GitHub Marketplace:

```yaml
name: greet-action
on:
  workflow_dispatch:
jobs:
  greet:
    name: "Test: Greet Action"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      - name: Greet Action
        uses: r3d-shadow/custom-github-action@1.0.1
        with:
          name: "Safeer"
          message: "Testing the Released GitHub Action!"
```

Trigger the workflow from the **Actions** tab, select **"Greet Action,"** and manually start it. Once it runs, review the logs to confirm the expected output message.

![/assets/10.png](/assets/10.png)