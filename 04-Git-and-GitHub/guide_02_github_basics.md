# Day 2, Guide 2: GitHub Basics

## Goal
Connect your local Git repository to GitHub and learn how to push, pull, and clone.

## Time
Approximately **90 minutes**.

## Prerequisites

- Completion of [guide_01_git_basics.md](guide_01_git_basics.md)
- GitHub account
- Git configured with your name and email

---

## 1. What is GitHub?

GitHub is a cloud-based platform for hosting Git repositories. It adds collaboration features like:

- Remote repositories
- Pull requests
- Issues
- Actions (CI/CD)
- Code review

## 2. Creating a Repository on GitHub

1. Log in to [github.com](https://github.com)
2. Click the **+** icon → **New repository**
3. Name it `ncc-labs`
4. Choose **Public**
5. Do **not** initialize with a README (you already have one locally)
6. Click **Create repository**

## 3. Connecting Local Repository to GitHub

After creating the empty repository, GitHub shows commands. Use the "push an existing repository" option:

```bash
cd ~/ncc-labs
git remote add origin https://github.com/YOUR_USERNAME/ncc-labs.git
git branch -M main
git push -u origin main
```

Verify the remote:

```bash
git remote -v
```

## 4. Pushing Changes

After making commits locally, push them to GitHub:

```bash
git add .
git commit -m "Add daily report"
git push origin main
```

## 5. Cloning a Repository

To download an existing repository:

```bash
git clone https://github.com/YOUR_USERNAME/ncc-labs.git
```

## 6. Pulling Changes

If someone else (or you on another machine) pushed changes:

```bash
git pull origin main
```

---

## Hands-On: Push Day 1 to GitHub

### Step 1: Create the GitHub repository

Follow the steps above to create `ncc-labs` on GitHub.

### Step 2: Connect and push

```bash
cd ~/ncc-labs
git remote add origin https://github.com/YOUR_USERNAME/ncc-labs.git
git branch -M main
git push -u origin main
```

### Step 3: Verify on GitHub

Open your repository in the browser. You should see:

- `day1/backup.sh`
- `day1/log_parser.py`
- `day1/run_day1.sh`
- `day1/sample.log`
- `day1/daily_report.txt`

---

## Check Your Understanding

1. What is the difference between `git commit` and `git push`?
2. What does `git remote -v` show?
3. Why should you run `git pull` before starting work on a shared branch?
4. What happens if you try to push without committing first?

---

## Next Step

Continue to [guide_03_branching_and_pr.md](guide_03_branching_and_pr.md) to learn branching and pull requests.
