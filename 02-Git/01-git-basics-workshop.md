# Git & Version Control Workshop

## Goal
Learn the full lifecycle of code versioning using Git and GitHub: creating a repo, cloning, branching, committing, pushing, and reviewing Pull Requests (PRs).

## 1. Setup & Configuration
Before we begin, tell Git who you are:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 2. Creating a Repository
1.  Go to GitHub.com and log in.
2.  Click the **+** icon in the top-right corner -> **New repository**.
3.  **Name:** `ncc-git-lab`
4.  **Public/Private:** Public (easier for today).
5.  **Initialize:** Check "Add a README file".
6.  Click **Create repository**.

## 3. Cloning the Repository
Get the code to your local machine.
1.  Click the green **Code** button -> Copy the URL (HTTPS).
2.  In your terminal:
    ```bash
    cd ~
    git clone https://github.com/YOUR_USERNAME/ncc-git-lab.git
    cd ncc-git-lab
    ```

## 4. The Workflow: Add, Commit, Push
Let's add some code.

1.  **Create a file:**
    ```bash
    # Create a simple script
    echo '#!/bin/bash' > hello.sh
    echo 'echo "Hello from Git!"' >> hello.sh
    chmod +x hello.sh
    ```

2.  **Check Status:**
    ```bash
    git status
    # You should see hello.sh in red (untracked).
    ```

3.  **Add (Stage):**
    ```bash
    git add hello.sh
    # git status will now show it in green (staged).
    ```

4.  **Commit (Save):**
    ```bash
    git commit -m "Add hello world script"
    ```

5.  **Push (Upload):**
    ```bash
    git push origin main
    ```
    *Go to GitHub and refresh the page. You should see your file!*

## 5. Branching & Workflow
**Rule:** Never push directly to `main` in a team setting. Use branches!

1.  **Create a Branch:**
    ```bash
    git checkout -b feature/update-script
    ```

2.  **Make Changes:**
    ```bash
    # Modify the script
    echo 'echo "This is a new feature."' >> hello.sh
    ```

3.  **Commit & Push:**
    ```bash
    git add hello.sh
    git commit -m "Update script with new feature"
    git push origin feature/update-script
    ```

## 6. Pull Requests (PR) & Code Review
1.  Go to your GitHub repo. You should see a yellow banner: "feature/update-script had recent pushes".
2.  Click **Compare & pull request**.
3.  **Title:** "Update Hello Script".
4.  **Description:** "Added a new echo line."
5.  Click **Create pull request**.

### The Review Process
*   In a real team, a colleague would review your code here.
*   They can leave comments on specific lines.
*   Once approved, you can click **Merge pull request**.

## 7. Branch Protection (Instructor Demo)
To enforce this workflow, we use Branch Protection Rules.

1.  Go to **Settings** -> **Branches**.
2.  Click **Add branch protection rule**.
3.  **Branch name pattern:** `main`
4.  Check **Require a pull request before merging**.
5.  Check **Require approvals**.
6.  Click **Create**.

**Try it:** Now, try to push directly to main (`git push origin main`) after making a change. It will be rejected!
