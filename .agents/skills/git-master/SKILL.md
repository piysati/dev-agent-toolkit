---
name: git-master
description: >-
  Deep repository context-aware Git mastery and incident-recovery skill for
  Antigravity and Gemini. Use when diagnosing Git states, resolving merge or
  rebase conflicts, recovering lost commits via reflog, squashing/rewriting
  history, executing production rollbacks (revert -m 1), untangling branches
  (rebase --onto), bisecting regressions, scrubbing leaked secrets, or preventing
  repository corruption.
---

# Git Master — Safe Surgical Git & Incident Recovery

Prevent repository corruption, diagnose live Git state before suggesting any command, and solve every Git scenario from 0 to 5+ years of production engineering cleanly and verifiably.

---

## 1. Live Context Ingestion (Always Run First!)

Never advise blind Git commands. Before running or recommending any multi-step or history-rewriting Git operation, inspect live state using this exact read-only snippet (run via `run_command` or ask the user to paste its output):

```bash
git branch -vv && echo "---STATUS---" && git status -s && echo "---LOG---" && git log --graph --oneline --decorate -n 8 && echo "---REMOTES---" && git remote -v
```

Extract and track this **Active Repository State**:
- **Target Remote**: e.g., `origin`
- **Primary Protected Branch(es)**: e.g., `main` / `master` / `develop`
- **Active Branch & Tracking Ref**: e.g., `feature/auth -> origin/feature/auth [ahead 2, behind 1]`
- **Working Tree State**: clean / staged / unstaged / untracked / mid-rebase / detached HEAD
- **Base Merge Target**: e.g., `origin/main`

---

## 2. Non-Negotiable Safety Invariants

1. **Checkpoint Before Anything Destructive**: NEVER run or advise `git reset --hard`, `git clean -fdx`, `git rebase -i`, `git rebase --onto`, `git branch -D`, `git-filter-repo`, or force-push without first creating a zero-cost recovery checkpoint:
   ```bash
   git branch backup-HEAD-safety-checkpoint
   # If working tree also has uncommitted changes:
   git stash push -u -m "backup: before git operation"
   ```
2. **Ban Raw `--force` Permanently**: NEVER use `git push --force` (`-f`). Always replace it with:
   ```bash
   git push origin <branch> --force-with-lease --force-if-includes
   ```
   And NEVER force-push to shared/protected branches (`main`, `master`, `develop`, `release/*`).
3. **Verify Before & After**: Every command sequence must end with an explicit verification command (`git status -s`, `git log --oneline -n 5`, `git diff --staged`).
4. **Leaked Secrets = Rotate First**: If a credential/API key was pushed to ANY remote, **revoke and rotate the secret immediately first** — rewriting Git history does not undo exposure.
5. **Prefer Modern Unambiguous Verbs**: Use `git switch` (branches), `git restore` (discarding/unstaging files), and `git stash push -u -m "..."` (stashing with untracked files) instead of overloaded `git checkout` or deprecated `git stash save`.

---

## 3. Core Git Command Matrix

| Stage | Command | Operational Purpose |
| :--- | :--- | :--- |
| **Inspect** | `git status -s` | Compact status of staged, unstaged, and untracked files |
| | `git diff` / `git diff --staged` | Inspect unstaged vs. staged changes |
| | `git log --graph --oneline --decorate -n 15` | Visualize branch topology and commit pointers |
| | `git reflog show -n 20` | Inspect local `HEAD` movement history (recovery lifeline) |
| **Stage & Commit** | `git add -p` | Interactive hunk-by-hunk surgical staging |
| | `git restore --staged <file>` | Unstage file while preserving working-tree edits |
| | `git restore <file>` | Discard unstaged edits in working tree (destructive to edits!) |
| | `git commit -m "type(scope): summary"` | Record conventional, imperative commit |
| | `git commit --amend --no-edit` | Fold staged changes into the latest unpushed commit |
| **Branching** | `git switch <branch>` | Switch to an existing branch |
| | `git switch -c <name>` | Create and switch to a new branch |
| | `git switch --track origin/<branch>` | Checkout and track a remote branch locally |
| | `git branch -m <new-name>` | Rename current local branch safely |
| | `git branch -d <name>` / `-D` | Safe-delete merged branch vs. force-delete unmerged branch |
| **Sync** | `git fetch --all --prune` | Refresh remote refs and prune deleted remote branches |
| | `git pull --ff-only origin main` | Pull only if fast-forward (prevents surprise merge commits) |
| | `git pull --rebase origin <branch>` | Replay local unpushed commits cleanly on top of upstream |
| | `git push -u origin <branch>` | Push branch and set upstream tracking |
| **History & Stash** | `git stash push -u -m "wip: desc"` | Stash tracked + untracked files with a clear label |
| | `git stash list` / `git stash pop` | List stashes / re-apply and drop latest stash |
| | `git cherry-pick <sha>` | Port a single commit onto the current branch |
| | `git revert -m 1 <merge-sha>` | Safely roll back a merged PR on a shared branch |

---

## 4. Full Scenario Playbook (0 to 5+ Years Experience)

For complete, copy-paste-ready runnable recovery steps with verification commands, read **[references/PLAYBOOK.md](references/PLAYBOOK.md)**.

- **Junior (0–1 yr)**: Committed directly to `main` (unpushed) · Amend typo/missing file · Discard unstaged vs. staged edits (`git restore`) · Unpushed `.env`/secret removal · Branch lifecycle & remote tracking
- **Mid-Level (1–3 yr)**: Dirty working tree + pull/switch (`git stash push -u`) · Rebase & merge conflict triage · Squashing messy commits (`rebase -i` & `reset --soft`) · Fixing Detached HEAD · Cherry-pick single commit / range / single file · Safe force-push after rebase divergence (`--force-with-lease --force-if-includes`)
- **Senior / Staff (3–5+ yr)**: `git reflog` forensics after `reset --hard` or deleted branch · Production PR rollback (`git revert -m 1`) & re-applying via revert-the-revert · Untangling wrong parent branch (`git rebase --onto`) · Automated regression hunting (`git bisect`) · Permanent secret scrubbing (`git-filter-repo`) · Fixing Git submodule pointer drift
