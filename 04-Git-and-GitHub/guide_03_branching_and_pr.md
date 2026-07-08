# Git Branching Strategies

## Overview

Branching strategies provide a structured approach to managing code changes across team members and deployment environments. The right strategy depends on your team size, release cadence, and deployment model.

## Git Flow

### When to Use Git Flow

Git Flow works best for:
- Projects with scheduled releases (e.g., quarterly, monthly)
- Products that need to support multiple versions in production
- Teams that need formal release preparation phases
- Projects requiring hotfix capabilities separate from feature development

### Branch Structure

**Permanent Branches:**
- `main` (or `master`): Production-ready code only
- `develop`: Integration branch for features

**Temporary Branches:**
- `feature/*`: New feature development
- `release/*`: Release preparation and testing
- `hotfix/*`: Emergency production fixes

### Workflows

**Feature Development:**
```bash
# Start new feature
git checkout develop
git checkout -b feature/user-dashboard

# Work on feature
git add .
git commit -m "Add user dashboard component"

# Finish feature
git checkout develop
git merge --no-ff feature/user-dashboard
git branch -d feature/user-dashboard
git push origin develop
```

**Release Process:**
```bash
# Create release branch
git checkout develop
git checkout -b release/1.2.0

# Bug fixes on release branch
git commit -m "Fix date formatting bug"

# Merge to main and tag
git checkout main
git merge --no-ff release/1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge --no-ff release/1.2.0
git branch -d release/1.2.0
```

**Hotfix Process:**
```bash
# Create hotfix from main
git checkout main
git checkout -b hotfix/security-patch

# Fix the issue
git commit -m "Apply security patch for CVE-2024-1234"

# Merge to main
git checkout main
git merge --no-ff hotfix/security-patch
git tag -a v1.2.1 -m "Hotfix for security vulnerability"

# Merge to develop
git checkout develop
git merge --no-ff hotfix/security-patch

# Clean up
git branch -d hotfix/security-patch
```

### Pros and Cons

**Advantages:**
- Clear separation between production, staging, and development
- Formal release process with testing gates
- Easy to maintain multiple versions
- Hotfixes don't disrupt feature development

**Disadvantages:**
- Complex for small teams or simple projects
- Overhead of maintaining multiple branches
- Not ideal for continuous deployment
- Merge conflicts can be frequent

---

## GitHub Flow

### When to Use GitHub Flow

GitHub Flow is ideal for:
- Web applications with continuous deployment
- SaaS products
- Projects deploying multiple times per day
- Small to medium teams
- Cloud-native applications

### Core Principles

1. **Main branch is always deployable**
2. **Create descriptive branches from main**
3. **Open pull requests early for discussion**
4. **Deploy from branch for testing**
5. **Merge to main after review**
6. **Deploy immediately after merge**

### Workflow

```bash
# Create feature branch
git checkout main
git pull origin main
git checkout -b add-payment-integration

# Develop with regular commits
git add .
git commit -m "Add Stripe API integration"
git push origin add-payment-integration

# Open pull request on GitHub
# Team reviews, discusses, suggests changes

# Deploy to staging from branch to test
# If tests pass, merge PR

# Main is automatically deployed to production
```

### Pull Request Process

1. **Open Early**: Open PR when work begins, mark as draft
2. **Request Review**: Tag specific reviewers when ready
3. **Address Feedback**: Make changes based on review comments
4. **CI Checks**: Ensure all automated tests pass
5. **Deploy Test**: Deploy branch to staging environment
6. **Merge**: After approval, merge to main
7. **Auto-Deploy**: CI/CD deploys main to production

### Pros and Cons

**Advantages:**
- Simple and intuitive
- Fast feedback cycles
- Supports continuous deployment
- Main always reflects production
- Easy to onboard new developers

**Disadvantages:**
- Requires robust automated testing
- No formal release preparation
- Less suitable for scheduled releases
- Requires feature flags for long-running features

---

## Trunk-Based Development

### When to Use Trunk-Based Development

Trunk-based development suits:
- High-performing engineering teams
- Organizations practicing continuous delivery
- Teams with comprehensive test automation
- Projects requiring rapid iteration
- Companies like Google, Facebook, Netflix

### Core Philosophy

- Developers commit directly to trunk (main) or use very short-lived branches
- Branches live less than 24 hours
- Continuous integration runs on every commit
- Feature flags control feature visibility
- Automated tests provide safety net

### Workflow Variations

**Direct to Trunk:**
```bash
# Pull latest
git checkout main
git pull origin main

# Make small change
# Run tests locally
npm test

# Commit directly to main
git add .
git commit -m "feat: add email validation"
git push origin main

# CI runs tests and deploys
```

**Short-Lived Branches:**
```bash
# Create branch for focused change
git checkout -b quick-fix

# Make change
git commit -m "fix: correct date calculation"

# Push and immediately merge when tests pass
git push origin quick-fix
# Open PR, get quick review (< 1 hour), merge
```

### Feature Flags

Feature flags enable trunk-based development by hiding incomplete work:

```javascript
// Code committed to main but hidden
if (featureFlags.newCheckout) {
  return <NewCheckoutFlow />
} else {
  return <OldCheckoutFlow />
}
```

Benefits:
- Deploy anytime without exposing incomplete features
- Gradual rollout (10% users, then 50%, then 100%)
- Easy rollback (flip flag off)
- A/B testing capabilities

### Requirements for Success

**Fast Build and Test:**
- Build time < 10 minutes
- Fast feedback on failures
- Parallel test execution

**Automated Testing:**
- High code coverage (>80%)
- Integration tests
- End-to-end tests
- Performance tests

**Team Discipline:**
- Small, focused commits
- Commit frequently (multiple times daily)
- Pull latest changes before committing
- Communicate about high-risk changes

**Deployment Automation:**
- Automated deployment pipeline
- Canary deployments or blue-green deployments
- Fast rollback capability

### Pros and Cons

**Advantages:**
- Fastest feedback loops
- Minimal merge conflicts
- Always integration-ready
- Supports continuous delivery
- Aligns with DevOps principles

**Disadvantages:**
- Requires mature engineering practices
- Needs significant automated testing
- Feature flag management overhead
- Not suitable for teams new to agile practices

---

## Release Branching Strategy

### When to Use

- Enterprise software with scheduled releases
- Products requiring extensive QA
- Systems with deployment windows (e.g., quarterly releases)

### Structure

**Long-Lived Branches:**
- `main`: Active development
- `release/2024.Q1`, `release/2024.Q2`: Release branches

### Workflow

```bash
# Continue development on main
git checkout main
git commit -m "New features for next release"

# Create release branch when ready
git checkout -b release/2024.Q2 main

# Only bug fixes on release branch
git checkout release/2024.Q2
git cherry-pick <bug-fix-commit>

# Tag release
git tag v2024.Q2.0
git push --tags

# Cherry-pick critical fixes back to main
git checkout main
git cherry-pick <critical-fix>
```

---

## Comparison Matrix

| Factor | Git Flow | GitHub Flow | Trunk-Based | Release Branches |
|--------|----------|-------------|-------------|------------------|
| **Complexity** | High | Low | Medium | Medium |
| **Best For** | Scheduled releases | Continuous deployment | High-velocity teams | Enterprise software |
| **Branch Lifetime** | Days to weeks | Hours to days | Hours | Weeks to months |
| **Deployment Frequency** | Weekly to monthly | Multiple per day | Continuous | Quarterly to monthly |
| **CI/CD Integration** | Moderate | Strong | Strongest | Moderate |
| **Learning Curve** | Steep | Gentle | Moderate | Moderate |
| **Team Size** | Large teams | Any size | Works best with mature teams | Large teams |

---

## Choosing the Right Strategy

### Questions to Ask

1. **How often do you deploy?**
   - Multiple times daily → GitHub Flow or Trunk-Based
   - Weekly/Monthly → Git Flow or Release Branches

2. **What's your team's testing maturity?**
   - High automation → Trunk-Based
   - Manual QA phases → Git Flow

3. **Do you support multiple versions?**
   - Yes → Git Flow or Release Branches
   - No → GitHub Flow or Trunk-Based

4. **Team size and experience?**
   - Small, experienced → Trunk-Based
   - Large, mixed experience → Git Flow
   - Growing team → GitHub Flow

5. **Deployment model?**
   - Continuous Deployment (SaaS) → GitHub Flow or Trunk-Based
   - Scheduled Releases (Enterprise) → Git Flow
   - Customer-specific versions → Release Branches

### Migration Path

Most teams start with **GitHub Flow**, then evolve:
- More complexity → Git Flow
- More maturity → Trunk-Based Development

---

## Best Practices Across All Strategies

### Branch Naming

- Use consistent prefixes: `feature/`, `bugfix/`, `hotfix/`
- Include ticket numbers: `feature/JIRA-123-user-login`
- Keep names descriptive but concise

### Commit Practices

- Commit frequently (at least daily)
- Write meaningful commit messages
- Keep commits atomic (one logical change)
- Test before committing

### Code Review

- Review all changes before merging
- Respond to reviews within 24 hours
- Keep reviews focused and constructive
- Use automated checks to reduce review burden

### Documentation

- Maintain branching strategy documentation
- Update team runbooks
- Document exception processes
- Keep README current

---

## Conclusion

No single branching strategy fits all teams. The best strategy:
- Matches your deployment frequency
- Aligns with team size and maturity
- Supports your testing capabilities
- Enables your business goals

Start simple (GitHub Flow), then adjust based on pain points and team evolution. The strategy should serve the team, not constrain it.
