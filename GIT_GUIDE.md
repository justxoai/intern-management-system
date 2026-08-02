# Git Workflow Guide

This document describes the Git workflow used by the development team.

---

# Git Branch Strategy

```
main
│
└── develop
      │
      ├── feature/authentication
      ├── feature/intern-management
      ├── feature/recruitment
      ├── feature/mentor-management
      ├── feature/task-management
      └── feature/evaluation
```

Branch naming convention

| Branch | Purpose |
|---------|----------|
| main | Stable release |
| develop | Integration branch |
| feature/* | New feature |
| fix/* | Bug fix |
| docs/* | Documentation |
| refactor/* | Code improvement |
| chore/* | Maintenance |

---

# Clone Repository

```bash
git clone https://github.com/your-username/internship-management-system.git

cd internship-management-system
```

---

# Synchronize Latest Code

Before starting any task

```bash
git checkout develop

git pull origin develop
```

---

# Create a Feature Branch

```bash
git checkout develop

git pull origin develop

git checkout -b feature/intern-management
```

Push the new branch

```bash
git push -u origin feature/intern-management
```

---

# Commit Convention

Format

```
type: short description
```

Examples

```bash
git commit -m "feat: add intern registration"

git commit -m "fix: correct login validation"

git commit -m "docs: update README"

git commit -m "refactor: simplify mentor service"

git commit -m "style: format source code"

git commit -m "test: add login test"

git commit -m "chore: update dependencies"
```

Available commit types

- feat
- fix
- docs
- style
- refactor
- test
- chore

---

# Daily Development Workflow

### 1. Update develop

```bash
git checkout develop

git pull origin develop
```

---

### 2. Switch to your branch

```bash
git checkout feature/intern-management
```

---

### 3. Develop your feature

---

### 4. Check modified files

```bash
git status
```

---

### 5. Stage changes

```bash
git add .
```

or

```bash
git add src/
```

---

### 6. Commit

```bash
git commit -m "feat: implement intern search"
```

---

### 7. Push

```bash
git push origin feature/intern-management
```

---

# Merge Feature Branch

Switch to develop

```bash
git checkout develop
```

Update develop

```bash
git pull origin develop
```

Merge

```bash
git merge feature/intern-management
```

Push

```bash
git push origin develop
```

Delete merged branch

```bash
git branch -d feature/intern-management

git push origin --delete feature/intern-management
```

---

# Rebase

Synchronize feature branch with develop

```bash
git checkout feature/intern-management

git fetch origin

git rebase origin/develop
```

If conflicts occur

```bash
git add .

git rebase --continue
```

Abort rebase

```bash
git rebase --abort
```

After successful rebase

```bash
git push --force-with-lease
```

---

# Resolving Merge Conflicts

Check conflicting files

```bash
git status
```

Resolve conflicts manually.

Then

```bash
git add .

git commit
```

---

# Pull Request

1. Push your feature branch

```bash
git push origin feature/intern-management
```

2. Open GitHub.

3. Create a Pull Request.

Target branch

```
develop
```

Source branch

```
feature/intern-management
```

Title example

```
feat: implement intern management module
```

Description should include

- Summary
- Implemented features
- Testing results

After review, merge the Pull Request and delete the feature branch.

---

# Useful Git Commands

Current branch

```bash
git branch
```

All branches

```bash
git branch -a
```

Commit history

```bash
git log --oneline
```

Undo last commit

```bash
git reset --soft HEAD~1
```

Discard local changes

```bash
git restore .
```

Unstage files

```bash
git restore --staged .
```

Fetch remote branches

```bash
git fetch --all
```

---

# Recommended Workflow

```
main
 │
 └────────────── develop
                     │
      ┌──────────────┴──────────────┐
      │                             │
feature/authentication      feature/task-management
      │                             │
      └──────── Pull Request ───────┘
                     │
                 develop
                     │
                    main
```

---

# Best Practices

- Pull the latest code before starting work.
- Create one feature per branch.
- Write clear and meaningful commit messages.
- Do not commit directly to `main`.
- Create a Pull Request for every completed feature.
- Resolve merge conflicts before merging.
- Delete merged branches regularly.