# Git & Version Control Session

## Prerequisites

To participate effectively in this Git workshop, please ensure you have the following:

### 1. Git Installation

**Check if Git is installed:**
```bash
git --version
```

**Install Git if needed:**

- **macOS:** 
  ```bash
  brew install git
  ```
  Or download from [git-scm.com](https://git-scm.com/)

- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt-get update
  sudo apt-get install git
  ```

- **Linux (Fedora/RHEL):**
  ```bash
  sudo dnf install git
  ```

- **Windows:**
  Download from [git-scm.com](https://git-scm.com/) or install via:
  ```powershell
  winget install Git.Git
  ```

### 2. GitHub Account

- Create a free account at [github.com](https://github.com/)
- Verify your email address
- (Optional but recommended) Set up SSH keys for easier authentication

### 3. Git Configuration

Configure your identity (required for commits):

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@example.com"
```

Verify configuration:
```bash
git config --list
```

### 4. Text Editor

You'll need a text editor for commit messages and file editing:

**Command-line options:**
- `nano` (easiest for beginners)
- `vim` or `emacs` (if you're comfortable with them)

**Set default editor:**
```bash
# For nano
git config --global core.editor "nano"

# For VS Code
git config --global core.editor "code --wait"

# For vim
git config --global core.editor "vim"
```

**GUI options:**
- VS Code (recommended)
- Sublime Text
- Atom
- Any text editor you're comfortable with

### 5. Basic Command Line Knowledge

You should be comfortable with:
- Navigating directories (`cd`, `pwd`, `ls`)
- Creating directories (`mkdir`)
- Creating and editing files

### 6. Internet Connection

Required for:
- Cloning repositories from GitHub
- Pushing and pulling changes
- Accessing GitHub web interface

## Setup Verification

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
