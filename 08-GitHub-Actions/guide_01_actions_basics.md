# Day 4, Guide 7: GitHub Actions Basics

## Goal
Understand GitHub Actions workflow structure and run your first workflow.

## Time
Approximately **60 minutes**.

## Prerequisites

- GitHub repository `ncc-labs`
- Basic Git knowledge

---

## 1. What is GitHub Actions?

GitHub Actions is a CI/CD platform built into GitHub. It lets you automate build, test, and deployment workflows directly from your repository.

## 2. Key Concepts

| Term | Meaning |
|------|---------|
| Workflow | A YAML file that defines automation |
| Job | A set of steps that run on the same runner |
| Step | A single task inside a job |
| Action | A reusable unit of code (from GitHub Marketplace) |
| Runner | A virtual machine that executes workflows |
| Event | A trigger like `push`, `pull_request`, or `schedule` |

## 3. Workflow File Structure

Workflows live in `.github/workflows/`.

```yaml
name: Hello World

on:
  push:
    branches: [main]

jobs:
  say-hello:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Print message
        run: echo "Hello from GitHub Actions!"
```

## 4. Common Triggers

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:  # Manual trigger
```

---

## Hands-On: Create Your First Workflow

### Step 1: Create the workflow directory

```bash
cd ~/ncc-labs
mkdir -p .github/workflows
```

### Step 2: Create hello-world.yml

```bash
cat > .github/workflows/hello-world.yml << 'EOF'
name: Hello World

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Say hello
        run: echo "Hello, GitHub Actions!"

      - name: List files
        run: ls -la
EOF
```

### Step 3: Commit and push

```bash
git add .
git commit -m "Add hello world workflow"
git push origin main
```

### Step 4: View the run

1. Go to your repository on GitHub
2. Click **Actions**
3. Click the latest workflow run
4. Expand the steps to see output

---

## Check Your Understanding

1. Where do GitHub Actions workflow files live?
2. What does `runs-on: ubuntu-latest` mean?
3. What is the difference between `uses` and `run` in a step?
4. How do you manually trigger a workflow?

---

## Next Step

Continue to [guide_02_ecr_workflow.md](guide_02_ecr_workflow.md) to build a workflow that pushes a Docker image to ECR.
