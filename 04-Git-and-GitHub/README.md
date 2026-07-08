# Day 2: Git and GitHub Basics

This module covers version control with Git and collaboration using GitHub.

## What You Will Learn

By the end of this module, you will be able to:

- Initialize and manage a Git repository
- Commit changes with meaningful messages
- Create branches and merge them
- Push code to GitHub
- Open and review pull requests
- Apply `.gitignore` and best practices

## Time Estimate

Approximately **6 hours** (including hands-on exercises).

## Prerequisites

- Completion of [Day 1](../00-course-roadmap.md#day-1-linux-bash-scripting-and-python-fundamentals)
- Git installed (`git --version`)
- GitHub account

## Guide Sequence

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [guide_01_git_basics.md](guide_01_git_basics.md) | Init, add, commit, status, log | 90 min |
| Guide 2 | [guide_02_github_basics.md](guide_02_github_basics.md) | Remotes, push, clone, pull | 90 min |
| Guide 3 | [guide_03_branching_and_pr.md](guide_03_branching_and_pr.md) | Branches, merge, pull requests | 120 min |

## Day 2 Narrative

You will take the `~/ncc-labs/day1/` toolkit created on Day 1 and commit it to a new GitHub repository called `ncc-labs`. This repository will be reused on Day 3 when you containerize the Python app.

## Key Artifact

A public GitHub repository `ncc-labs` containing your Day 1 scripts and reports.

---

## Setup Checklist

Before starting, verify your environment:

```bash
git --version
git config --list
```

If needed, configure Git:

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@example.com"
```

For easier authentication with GitHub, set up SSH keys or use GitHub CLI.

Run these commands to verify your setup:

```bash
# Check Git version (should be 2.x or higher)
git --version

# Verify your configuration
git config user.name
git config user.email

# Test GitHub connectivity (if using SSH)
ssh -T git@github.com
```

## Optional Enhancements

### Git GUI Tools

While command line is recommended for learning, these tools can help visualize Git history:

- **GitKraken** (cross-platform, visual)
- **SourceTree** (macOS/Windows, free)
- **GitHub Desktop** (macOS/Windows, beginner-friendly)
- **VS Code Git integration** (built into VS Code)

### Terminal Enhancements

**Show Git branch in prompt:**

**Bash** (~/.bashrc or ~/.bash_profile):
```bash
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\u@\h \W \$(parse_git_branch) $ "
```

**Zsh** (~/.zshrc):
```bash
autoload -Uz vcs_info
precmd() { vcs_info }
zshrc=('${vcs_info_msg_0_} %~ $ ')
setopt PROMPT_SUBST
```

## Workshop Preparation

Before the session starts:

1. **Create a workspace directory:**
   ```bash
   mkdir ~/git-workshop
   cd ~/git-workshop
   ```

2. **Test creating a repository:**
   ```bash
   mkdir test-repo
   cd test-repo
   git init
   ```

3. **Make a test commit:**
   ```bash
   echo "# Test" > README.md
   git add README.md
   git commit -m "Initial commit"
   ```

4. **Clean up test:**
   ```bash
   cd ..
   rm -rf test-repo
   ```

If all these steps work, you're ready for the workshop!

## Troubleshooting

### Git Command Not Found

- Ensure Git is installed
- Restart your terminal after installation
- Check that Git is in your system PATH

### Authentication Issues

**HTTPS authentication:**
- Use Personal Access Token instead of password
- Generate token at GitHub → Settings → Developer settings → Personal access tokens

**SSH authentication:**
- Generate SSH key: `ssh-keygen -t ed25519 -C "your.email@example.com"`
- Add to GitHub: Settings → SSH and GPG keys → New SSH key
- Paste contents of `~/.ssh/id_ed25519.pub`

### Permission Denied

If you get permission errors:
```bash
# Fix repository permissions
sudo chown -R $USER:$USER ~/git-workshop
```

## Getting Help

During the workshop, remember these commands:

```bash
# Get help for any Git command
git help <command>
git <command> --help

# Quick reference
git <command> -h
```

## Ready to Begin!

Once your setup is verified, you're ready to learn:
- Creating and cloning repositories
- Making commits and tracking changes
- Working with branches
- Collaborating via pull requests
- Using Git in DevOps workflows

See you in the workshop!
