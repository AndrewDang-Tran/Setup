# Skills Sync — Desktop Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Keep Claude Code skills version-controlled in the existing Setup GitHub repo, with auto-commit logic in `setup.sh` after `claude-superskills` runs.

**Architecture:** Skills already live in `Setup/claude.symlink/skills/` (which is `~/.claude/skills/` via symlink), so the GitHub repo already has them. We expand the existing `claude-superskills` block in `setup.sh` to commit any diff after install.

**Tech Stack:** Bash, `npx claude-superskills`, `git`

---

## Context for Implementer

- `~/.claude` → `/Users/andrewdt/workspace/Setup/claude.symlink` (symlink set up by `setup.sh`)
- `Setup` is the GitHub repo `AndrewDang-Tran/Setup` (git@github.com:AndrewDang-Tran/Setup.git)
- Skills are already committed under `claude.symlink/skills/`
- Skills are installed/updated by running `npx claude-superskills install -y`
- `setup.sh` already calls `npx claude-superskills install -y` in `install_non_brew_applications()`

---

### Task 1: Commit Any Dirty Skill Changes

**Files:**
- Check: `claude.symlink/skills/`

**Step 1: Verify current git status of skills**

Run from `Setup/` directory:
```bash
git status --short claude.symlink/skills/
```
Expected: Any modified or untracked files listed. If output is empty, skills are clean — skip to Task 2.

**Step 2: Stage and commit any dirty skills**

```bash
git add claude.symlink/skills/
git commit -m "chore: sync skills from claude-superskills"
```
Expected: Commit created with changed skill files.

**Step 3: Verify commit**

```bash
git log --oneline -1
git status --short claude.symlink/skills/
```
Expected: New commit shown, status output is empty.

---

### Task 2: Add Auto-Commit to setup.sh

**Files:**
- Modify: `Setup/setup.sh` (lines ~205-206, the `claude-superskills` install block)

**Step 1: Replace the claude-superskills block in setup.sh**

Old (around line 205):
```bash
    inform "Installing claude-superskills..."
    npx claude-superskills install -y
```

New:
```bash
    inform "Installing/updating claude-superskills..."
    npx claude-superskills install -y
    cd "$DOTFILES_ROOT"
    if ! (git diff --quiet && git diff --staged --quiet); then
        git add claude.symlink/skills/
        git commit -m "chore: update skills from claude-superskills"
        success "Skills updated and committed."
    fi
```

Note: `DOTFILES_ROOT` and `success` are already defined in setup.sh.

**Step 2: Verify the change looks correct**

```bash
grep -n -A 8 "claude-superskills" /Users/andrewdt/workspace/Setup/setup.sh
```
Expected: The new block with the git commit logic visible.

**Step 3: Commit**

```bash
git add setup.sh
git commit -m "feat: auto-commit skill changes after claude-superskills update"
```

---

## Maintenance Summary

| Action | How |
|--------|-----|
| Update skills | Re-run `setup.sh` — installs and auto-commits any changes |
| New machine setup | Run `setup.sh` as before — no changes needed |
| Add a custom skill | Create it under `claude.symlink/skills/<name>/SKILL.md`, commit manually |

---

## Push to GitHub

After all tasks complete:
```bash
git push origin main
```
