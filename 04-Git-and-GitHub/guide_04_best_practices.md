# Git Best Practices for DevOps Teams

## Introduction

Following Git best practices ensures code quality, facilitates collaboration, and prevents common pitfalls. These practices have been refined by thousands of teams and are especially important in DevOps environments where code changes trigger automated deployments.

---

## Commit Message Conventions

### Why Commit Messages Matter

Good commit messages:
- Help teammates understand changes quickly
- Make code reviews more efficient
- Enable automated changelog generation
- Facilitate debugging ("when was this bug introduced?")
- Provide project history documentation

### Conventional Commits Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type** (required):
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build config)
- `perf`: Performance improvements
- `ci`: CI/CD changes

**Scope** (optional): Component or module affected
- `(auth)`, `(api)`, `(ui)`, `(database)`

**Subject** (required): Brief summary
- Imperative mood: "add" not "added" or "adds"
- Lowercase first letter
- No period at the end
- Max 50 characters

**Body** (optional): Detailed explanation
- Explain what and why, not how
- Wrap at 72 characters
- Separate from subject with blank line

**Footer** (optional): References and breaking changes
- Reference issues: `Closes #123, #456`
- Breaking changes: `BREAKING CHANGE: description`

### Examples

**Good:**
```
feat(auth): implement JWT token refresh mechanism

Added automatic token refresh when token expires within 5 minutes
of expiration. Prevents users from being logged out during active
sessions. Refresh happens silently in the background.

Closes #234
```

**Good (simple fix):**
```
fix(ui): correct date formatting in dashboard
```

**Bad:**
```
fixed stuff
```

**Bad:**
```
Updated several files and made changes
```

### Automated Enforcement

Use tools to enforce conventions:

**commitlint** with husky:
```json
// .commitlintrc.json
{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "subject-case": [2, "never", ["upper-case"]],
    "type-enum": [
      2,
      "always",
      ["feat", "fix", "docs", "style", "refactor", "test", "chore"]
    ]
  }
}
```

**Git hooks** to validate locally:
```bash
#!/bin/sh
# .git/hooks/commit-msg

npx --no-install commitlint --edit $1
```

---

## Pull Request Best Practices

### Creating Effective PRs

**1. Focused Scope**
- One feature or fix per PR
- Avoid mixing refactoring with feature work
- Keep PRs small (< 400 lines of diff ideal)

**2. Descriptive Title**
```
Good: "Add user authentication with OAuth2"
Bad: "Updates"
```

**3. Comprehensive Description**

Template:
```markdown
## What does this PR do?
Brief summary of changes

## Why is this change needed?
Context and motivation

## How was this tested?
- [ ] Unit tests added
- [ ] Manual testing steps
- [ ] Integration tests pass

## Screenshots (if applicable)
[Before] [After]

## Related Issues
Closes #123
```

**4. Self-Review First**
Before requesting review:
- Review your own diff
- Remove debug code
- Check for commented-out code
- Verify tests pass
- Update documentation

**5. Request Specific Reviewers**
- Tag reviewers with relevant expertise
- Provide context in review request
- Don't assign >3 reviewers

### PR Size Guidelines

| Lines Changed | Review Time | Defect Rate |
|---------------|-------------|-------------|
| < 50 | 10 minutes | Very Low |
| 50-200 | 20 minutes | Low |
| 200-400 | 45 minutes | Moderate |
| 400-800 | 90+ minutes | High |
| 800+ | Several hours | Very High |

**Large PRs should be split!**

### Draft PRs

Use draft PRs for:
- Work in progress needing early feedback
- Large features developed over several days
- Design discussion before full implementation

Mark as "Ready for Review" when complete.

---

## Code Review Guidelines

### For Authors

**1. Respond to Feedback Promptly**
- Address comments within 24 hours
- Ask clarifying questions
- Don't take criticism personally

**2. Make Changes Clear**
- Respond to each comment
- Mark resolved comments
- Add commits for review feedback (don't force-push immediately)

**3. Be Open to Suggestions**
- Consider alternative approaches
- Explain your reasoning
- Adapt when reviewers have better ideas

### For Reviewers

**1. Review Quickly**
- Provide feedback within business day
- Blocks author's progress
- Context is fresh

**2. Be Constructive**
```
Bad: "This is wrong"
Good: "Consider extracting this into a separate function for better testability"
```

**3. Categorize Feedback**
- Must Fix: Bugs, security issues, breaking changes
- Should Fix: Best practices, maintainability
- Nit: Minor style preferences
- Question: Request for clarification

**4. Approve with Comments**
Don't block PRs for minor nits:
```
"Approving, but please consider renaming `x` to `userData` for clarity"
```

**5. Focus Areas**
- Correctness (does it work?)
- Tests (is it tested?)
- Security (any vulnerabilities?)
- Performance (major inefficiencies?)
- Readability (can others understand it?)
- Design (does it fit the architecture?)

### Review Checklist

#### Functionality
- [ ] Code does what PR description claims
- [ ] Edge cases handled
- [ ] Error handling is appropriate

#### Code Quality
- [ ] Follows project style guide
- [ ] No code duplication
- [ ] Functions are small and focused
- [ ] Variable names are clear

#### Tests
- [ ] New features have tests
- [ ] Bug fixes have regression tests
- [ ] Tests are meaningful, not just coverage
- [ ] All tests pass

#### Security
- [ ] No secrets committed
- [ ] Input validation present
- [ ] SQL injection prevention
- [ ] XSS prevention

#### Performance
- [ ] No obvious inefficiencies
- [ ] Database queries optimized
- [ ] No memory leaks

#### Documentation
- [ ] README updated if needed
- [ ] API documentation updated
- [ ] Comments explain "why" not "what"

---

## Branch Management

### Branch Naming Conventions

**Feature branches:**
```
feature/add-user-profile
feature/JIRA-123-payment-integration
```

**Bug fixes:**
```
bugfix/fix-login-redirect
bugfix/TICKET-456-date-parsing
```

**Hotfixes:**
```
hotfix/security-patch
hotfix/critical-crash-fix
```

**Chores:**
```
chore/update-dependencies
chore/improve-ci-pipeline
```

### Branch Lifecycle

**1. Creation**
```bash
# Create from updated main
git checkout main
git pull origin main
git checkout -b feature/my-feature
```

**2. Regular Updates**
```bash
# Keep branch updated (rebase preferred for feature branches)
git fetch origin
git rebase origin/main
```

**3. Cleanup After Merge**
```bash
# Delete local branch
git branch -d feature/my-feature

# Delete remote branch (usually auto-deleted by GitHub/GitLab)
git push origin --delete feature/my-feature
```

### Stale Branch Management

**Identify stale branches:**
```bash
# Branches not updated in 30 days
git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(committerdate:relative)'
```

**Automated cleanup:**
```bash
# Delete merged branches
git branch --merged main | grep -v "main" | xargs git branch -d
```

---

## Repository Organization

### .gitignore Best Practices

**Language-specific:**
```
# Python
__pycache__/
*.py[cod]
venv/
.env

# Node.js
node_modules/
npm-debug.log
.env

# Java
target/
*.class
```

**IDE files:**
```
# JetBrains
.idea/

# VSCode
.vscode/

# General
.DS_Store
Thumbs.db
```

**Build artifacts:**
```
dist/
build/
*.log
*.tmp
```

**Secrets (critical!):**
```
.env
*.key
*.pem
secrets.yml
credentials.json
```

Use templates: [github.com/github/gitignore](https://github.com/github/gitignore)

### README Structure

```markdown
# Project Name

Brief description

## Prerequisites
- Node.js 18+
- PostgreSQL 12+

## Installation
```bash
npm install
```

## Configuration
Environment variables needed...

## Running Locally
```bash
npm run dev
```

## Running Tests
```bash
npm test
```

## Deployment
Deployment instructions...

## Contributing
See CONTRIBUTING.md

## License
MIT
```

### Documentation Files

**CONTRIBUTING.md**: How to contribute
**CHANGELOG.md**: Version history
**LICENSE**: Project license
**docs/**: Detailed documentation
**examples/**: Usage examples

---

## Secret Management

### Never Commit Secrets!

**What to protect:**
- API keys
- Database credentials
- Private keys
- OAuth tokens
- Encryption keys

### Environment Variables

```bash
# .env file (gitignored)
DATABASE_URL=postgresql://user:pass@localhost/db
API_KEY=abc123

# Access in code
const apiKey = process.env.API_KEY
```

### Secret Scanning

**Pre-commit hooks:**
```bash
# Install git-secrets
brew install git-secrets

# Set up hooks
git secrets --install
git secrets --register-aws
```

**GitHub Secret Scanning** (automatic for public repos)

**GitGuardian** (third-party tool)

### Fixing Committed Secrets

If you accidentally commit secrets:
1. **Rotate the secret immediately** (make it invalid)
2. Remove from history:
```bash
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/secret.key' \
  --prune-empty --tag-name-filter cat -- --all
```
3. Force push (inform team first!)
4. Consider repository as compromised

---

## Merge vs. Rebase

### When to Merge

**Use merge for:**
- Integrating completed features into main
- Combining release branches
- Preserving complete history
- Public/shared branches

```bash
git checkout main
git merge --no-ff feature/my-feature
```

The `--no-ff` (no fast-forward) creates a merge commit even when possible to fast-forward, preserving the feature branch context.

### When to Rebase

**Use rebase for:**
- Updating feature branches with latest main
- Cleaning up local commit history
- Creating linear project history

```bash
git checkout feature/my-feature
git rebase main
```

**Interactive rebase for cleanup:**
```bash
git rebase -i HEAD~5  # Last 5 commits
# Squash, reword, reorder commits
```

### Golden Rule

**Never rebase public/shared branches!**

Once commits are pushed and others may have based work on them, rebasing rewrites history and creates conflicts.

---

## Tagging and Releases

### Semantic Versioning

Format: `MAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible API changes
- **MINOR**: New features, backwards-compatible
- **PATCH**: Bug fixes, backwards-compatible

Examples:
- `v1.0.0`: Initial release
- `v1.1.0`: Added new feature
- `v1.1.1`: Bug fix
- `v2.0.0`: Breaking change

### Creating Tags

```bash
# Annotated tag (recommended, includes metadata)
git tag -a v1.2.0 -m "Release version 1.2.0 with user authentication"

# Push tags
git push origin v1.2.0
# Or push all tags
git push --tags
```

### Release Notes

Include in tag message or GitHub release:
- New features
- Bug fixes
- Breaking changes
- Upgrade instructions
- Contributors

---

## Common Mistakes to Avoid

### 1. Committing Large Files
Binary files bloat repository. Use Git LFS for large assets.

### 2. Force Pushing to Shared Branches
Destroys others' work. Only force-push to your own feature branches.

### 3. Mixing Refactoring and Features
Makes reviews harder. Separate into different PRs.

### 4. Long-Lived Feature Branches
Increase merge conflict risk. Keep branches short-lived.

### 5. Insufficient Commit Granularity
Huge commits are hard to review and revert. Commit frequently.

### 6. Ignoring CI Failures
Don't merge broken builds. Fix failures immediately.

### 7. Not Pulling Before Pushing
Causes unnecessary merge commits. Always pull first.

---

## Automation and Tooling

### Pre-commit Hooks

```bash
#!/bin/sh
# .git/hooks/pre-commit

# Run linter
npm run lint || exit 1

# Run tests
npm test || exit 1

# Check for secrets
git secrets --scan
```

### Continuous Integration Checks

```yaml
# GitHub Actions example
name: PR Checks
on: [pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Lint
        run: npm run lint
      - name: Test
        run: npm test
      - name: Build
        run: npm run build
```

### Branch Protection Rules

Enable on main/production branches:
- Require pull request reviews (2+ approvers)
- Require status checks to pass
- Require branches to be up to date
- Restrict force pushes
- Restrict deletions

---

## Team Agreements

### Define in CONTRIBUTING.md

- Branching strategy
- Commit message format
- Code review process
- Testing requirements
- Definition of done

### Regular Retrospectives

Review:
- What's working well?
- What's causing friction?
- Which practices should we adjust?

Git workflows should evolve with the team.

---

## Conclusion

Git best practices create a foundation for effective collaboration and reliable software delivery. Key takeaways:

- **Write clear commit messages** using conventional format
- **Keep PRs small and focused** for faster reviews
- **Provide constructive code reviews** within 24 hours
- **Never commit secrets** and use proper secret management
- **Choose merge vs. rebase** appropriately
- **Tag releases** with semantic versioning
- **Automate checks** with CI and pre-commit hooks
- **Protect important branches** with branch protection rules

These practices become muscle memory with consistent application. Start by adopting a few, then gradually incorporate more as your team matures. The goal is sustainable development velocity with high code quality—Git best practices help you achieve both.
