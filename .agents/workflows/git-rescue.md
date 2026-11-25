---
description: Safe Git diagnosis & incident recovery — inspects live repo state first, creates a backup branch checkpoint before any history rewrite, and guides step-by-step verified recovery.
---

# /git-rescue — Safe Surgical Git Diagnosis & Recovery

Load the `git-master` skill (and its `references/PLAYBOOK.md`) before touching a single Git ref.

## Strict Execution Steps

1. **Inspect Live State First (Read-Only)**:
   Run (or ask the user to paste):
   ```bash
   git branch -vv && echo "---STATUS---" && git status -s && echo "---LOG---" && git log --graph --oneline --decorate -n 8 && echo "---REMOTES---" && git remote -v
   ```
2. **Diagnose Plainly**:
   - State the exact current Git state (branch, upstream divergence, mid-rebase/merge, detached HEAD, dirty files, leaked secret, or wrong parent branch).
   - If a leaked secret was already pushed, **stop and tell the user to revoke/rotate it immediately** before doing any Git cleanup.
3. **Create a Recovery Checkpoint First**:
   Before any `reset`, `rebase`, `squash`, `clean`, or `filter-repo`, create a backup branch (`git branch backup-HEAD-safety-checkpoint`) and stash uncommitted changes (`git stash push -u -m "backup: before git-rescue"`).
4. **Execute Surgically & Safely**:
   - Never use raw `git push --force` — always `--force-with-lease --force-if-includes` (and never force-push shared/protected branches).
   - Explain *why* each command is safe so the user builds permanent Git mental models (no blind copy-pasting).
5. **Verify State After Every Sequence**:
   Run `git status -s && git log --graph --oneline --decorate -n 6` to confirm the repository is clean and intact, and remind the user they can safely delete `backup-HEAD-safety-checkpoint` once satisfied.
