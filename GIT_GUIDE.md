# Git Workflow Guide

This document describes the Git workflow used in this project.

---

# Branch Strategy

```
main
│
├── develop
│
├── feature/login
├── feature/intern-management
├── feature/task-management
├── feature/evaluation
│
├── fix/login-bug
├── hotfix/security
```

- **main**: Production
- **develop**: Development
- **feature/**: New features
- **fix/**: Bug fixes
- **hotfix/**: Urgent fixes
- **chore/**: Maintenance

---

# Clone Project

```bash
git clone https://github.com/username/internship-management-system.git

cd internship-management-system
```

---

# Pull Latest Code

Always pull before starting work.

```bash
git checkout develop

git pull origin develop
```

---

# Create New Branch

Naming convention

```
feature/<feature-name>

fix/<bug-name>

chore/<task-name>

docs/<document>

refactor/<module>
```

Example

```bash
git checkout develop

git pull origin develop

git checkout -b feature/login
```

Push branch

```bash
git push -u origin feature/login
```

---

# Git Commit Convention

Format

```
type: message
```

## feat

New feature

```bash
git commit -m "feat: add login feature"
```

## fix

Bug fix

```bash
git commit -m "fix: resolve login validation"
```

## docs

Documentation

```bash
git commit -m "docs: update README"
```

## style

Formatting

```bash
git commit -m "style: format code"
```

## refactor

Refactoring

```bash
git commit -m "refactor: simplify user service"
```

## test

Testing

```bash
git commit -m "test: add login unit tests"
```

## chore

Configuration

```bash
git commit -m "chore: update dependencies"
```

---

# Daily Workflow

## Step 1

Pull newest code

```bash
git checkout develop

git pull origin develop
```

---

## Step 2

Checkout your feature branch

```bash
git checkout feature/login
```

---

## Step 3

Work on your code

---

## Step 4

Check changes

```bash
git status
```

---

## Step 5

Stage changes

```bash
git add .
```

or

```bash
git add src/
```

---

## Step 6

Commit

```bash
git commit -m "feat: implement login API"
```

---

## Step 7

Push

```bash
git push origin feature/login
```

---

# Merge Branch

Switch to develop

```bash
git checkout develop
```

Pull latest

```bash
git pull origin develop
```

Merge

```bash
git merge feature/login
```

Push

```bash
git push origin develop
```

Delete local branch

```bash
git branch -d feature/login
```

Delete remote branch

```bash
git push origin --delete feature/login
```

---

# Rebase

Update branch using rebase

```bash
git checkout feature/login

git fetch origin

git rebase origin/develop
```

Resolve conflicts

```bash
git add .
```

Continue

```bash
git rebase --continue
```

Cancel

```bash
git rebase --abort
```

Push after rebase

```bash
git push --force-with-lease
```

---

# Merge Conflict

Check files

```bash
git status
```

Resolve conflict manually.

After fixing

```bash
git add .

git commit
```

---

# Pull Request

1. Push feature branch

```bash
git push origin feature/login
```

2. Open GitHub

3. Click

```
Compare & Pull Request
```

4. Select

```
base: develop

compare: feature/login
```

5. Fill

- Title

```
feat: Login feature
```

- Description

```
## Summary

- Add login API
- JWT Authentication
- Validation

## Testing

- Login successful
- Login failed
```

6. Create Pull Request

7. Review

8. Merge

```
Squash and Merge
```

Delete branch afterwards.

---

# Merge Request (GitLab)

1. Push branch

```bash
git push origin feature/login
```

2. Open GitLab

3. Create Merge Request

```
Source

feature/login

Target

develop
```

4. Assign reviewer

5. Resolve comments

6. Merge

---

# Useful Commands

Check current branch

```bash
git branch
```

List all branches

```bash
git branch -a
```

View commit history

```bash
git log --oneline
```

Undo last commit

```bash
git reset --soft HEAD~1
```

Discard changes

```bash
git restore .
```

Remove staged files

```bash
git restore --staged .
```

Fetch latest branches

```bash
git fetch --all
```

---

# Recommended Workflow

```
develop
      │
      ├───────────────┐
      │               │
feature/login   feature/task
      │               │
      └────PR─────────┘
             │
         develop
             │
        release
             │
            main
```

---

# Best Practices

- Pull before coding.
- One feature per branch.
- Commit frequently with meaningful messages.
- Never commit directly to `main`.
- Create Pull Requests for all feature branches.
- Resolve conflicts before merging.
- Delete merged branches.