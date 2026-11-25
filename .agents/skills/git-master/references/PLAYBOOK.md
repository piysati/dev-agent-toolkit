# Git Master — Complete Chronological Recovery Playbook (0 to 5+ Years)

Every scenario below includes runnable Bash commands, step-by-step reasoning, and an explicit verification command. Always run the live context ingestion check from `SKILL.md` first.

---

## Level 1: Junior / Foundations (0–1 Year)

### 1.1 Committed Directly to `main` Instead of a Feature Branch (Unpushed)
Move your local commit(s) onto a new feature branch and reset local `main` cleanly back to `origin/main`.

```bash
# 1. Anchor a new feature branch at your current HEAD (preserves all your commits)
git branch feature/my-feature

# 2. Reset local main safely back to origin/main (--keep aborts if uncommitted files would be lost)
git switch main
git reset --keep origin/main

# 3. Switch to your new feature branch where your commits live
git switch feature/my-feature

# Verify: main matches origin/main, feature/my-feature has your commit(s)
git log --graph --oneline --decorate -n 5 main feature/my-feature
```

### 1.2 Typo in Commit Message or Forgot to Include a File (Unpushed Only)
Never amend a commit that has already been pushed to a shared branch.

```bash
# Add forgotten file (skip this line if only fixing the message)
git add path/to/missing-file.java

# Update both contents and message (or use --no-edit to keep message)
git commit --amend -m "fix(orders): handle null currency code safely"

# Verify: inspect latest commit and files included
git show --stat HEAD
```

### 1.3 Discarding Accidental Local Edits (Unstaged vs. Staged via `git restore`)
```bash
# Case A: Unstage a file WITHOUT losing your edits in the working directory
git restore --staged path/to/file.java

# Case B: Discard UNSTAGED edits in a specific file (permanent for those edits!)
git restore path/to/file.java

# Case C: Unstage AND discard edits for a file in one step
git restore --staged --worktree path/to/file.java

# Case D: Remove untracked junk files (ALWAYS preview with -n first!)
git clean -nd
git clean -fd

# Verify
git status -s
```

### 1.4 Accidentally Committed Sensitive Data (`.env` / Credentials) Locally (Unpushed)
```bash
# 1. Remove from Git index while keeping your local .env file on disk
git rm --cached .env

# 2. Ensure .env is ignored permanently
grep -qxF ".env" .gitignore || echo ".env" >> .gitignore
git add .gitignore

# 3. Amend the unpushed commit so .env is no longer in HEAD
git commit --amend --no-edit

# Verify: confirm .env is NOT in the commit and is ignored
git show --stat HEAD && git check-ignore -v .env
```
*(If the commit was ALREADY pushed to a remote, rotate/revoke the secret immediately FIRST, then jump to Scenario 3.5.)*

### 1.5 Branch Lifecycle Basics (Create, Track, Safe Delete vs. Force Delete)
```bash
# Create and switch to a new branch
git switch -c feature/new-idea

# Checkout a remote branch that does not exist locally yet
git fetch origin --prune
git switch --track origin/feature/remote-branch

# Safe delete a local branch (fails if unmerged commits exist)
git branch -d feature/old-feature

# Force delete an abandoned branch (creates safety backup first if unsure)
git branch -D feature/abandoned-work

# Delete a remote branch
git push origin --delete feature/old-feature

# Verify
git branch -vv
```

---

## Level 2: Mid-Level Engineer (1–3 Years)

### 2.1 Dirty Working Directory While Needing to Pull or Switch Branches
Use modern `git stash push -u -m` so untracked files are safely included.

```bash
# 1. Stash tracked + untracked changes with a descriptive label
git stash push -u -m "wip: auth refresh flow half done"

# 2. Switch branch and fast-forward pull cleanly
git switch main
git pull --ff-only origin main

# 3. Return to your feature branch and re-apply your stashed work
git switch feature/my-feature
git stash pop

# Inspect / manage multiple stashes without dropping:
git stash list
git stash show -p stash@{0}
git stash apply stash@{1}
git stash drop stash@{1}

# Verify
git status -s && git stash list
```

### 2.2 Rebase & Merge Conflict Triage Step-by-Step
```bash
# 1. Create a zero-cost backup checkpoint BEFORE rebasing
git switch feature/my-feature
git branch backup-before-rebase

# 2. Fetch latest upstream and rebase onto origin/main
git fetch origin --prune
git rebase origin/main

# 3. When Git pauses on conflicts, list conflicting files ('UU' / 'both modified')
git status -s

# 4. Open each conflicting file, resolve <<<<<<< / ======= / >>>>>>> markers, and run tests
# 5. Stage resolved files and continue (NEVER run 'git commit' during a rebase!)
git add path/to/resolved-file.java
git rebase --continue

# Emergency escape hatch (restores exact pre-rebase state):
git rebase --abort

# Verify clean linear history and passing build
git log --graph --oneline --decorate -n 8 && git status -s
```

*(For a standard merge conflict: `git merge origin/main` → resolve markers → `git add <files>` → `git commit` or `git merge --abort`.)*

### 2.3 Squashing Messy Commits Into One Clean Semantic Commit
```bash
# Safety checkpoint first
git branch backup-before-squash

# Option A: Soft Reset Squash (cleanest for linear unpushed commits, e.g. last 5 commits)
git reset --soft HEAD~5
git commit -m "feat(auth): implement stateless JWT validation with tests"

# Option B: Interactive Rebase (when you want to reorder, drop, or keep multiple logical commits)
# In editor: leave first commit as 'pick', change subsequent commits to 'squash' (s) or 'fixup' (f)
git rebase -i HEAD~5

# Verify: clean commit count and exact diff against base branch
git log --oneline -n 5 && git diff --stat origin/main..HEAD
```

### 2.4 Fixing "Detached HEAD" State and Anchoring Work
If you checked out a commit SHA or tag directly and made commits, those commits aren't on any branch yet.

```bash
# 1. Anchor all commits made in detached HEAD onto a real branch immediately
git switch -c rescue/detached-work

# 2. Confirm HEAD is now attached to the branch
git branch -vv && git log --oneline -n 5
```

### 2.5 Cherry-Picking an Urgent Hotfix (or Extracting a Single File)
```bash
# Port a single commit onto your target branch
git switch release/v2.1
git fetch origin
git cherry-pick <COMMIT_SHA>

# If conflicts occur: resolve markers, stage, then continue (or --abort)
git add path/to/resolved-file.java
git cherry-pick --continue

# Cherry-pick a commit range (exclusive of A, inclusive of B; add A^..B to include A)
git cherry-pick <COMMIT_A>..<COMMIT_B>

# Extract just one file from another branch without switching branches
git restore --source=target-branch -- path/to/specific-file.java
git add path/to/specific-file.java
git commit -m "chore: port specific-file from target-branch"

# Verify
git log --oneline -n 3 && git status -s
```

### 2.6 Remote Rejected Push After Local Rebase (Safe Force-Push)
```bash
# NEVER run 'git push --force'. Always use both lease & includes guards:
git push origin feature/my-feature --force-with-lease --force-if-includes

# If rejected because a teammate pushed new commits while you were rebasing:
git fetch origin feature/my-feature
git log HEAD..origin/feature/my-feature --oneline
git rebase origin/feature/my-feature
git push origin feature/my-feature --force-with-lease --force-if-includes

# Verify local and remote SHAs match
git branch -vv
```

---

## Level 3: Senior / Staff Engineer (3–5+ Years)

### 3.1 Reflog Forensics — Recovering Lost Commits After `reset --hard` or `branch -D`
Git keeps unreachable commits locally in the reflog (typically 30–90 days before GC).

```bash
# 1. Inspect recent HEAD movements to find the SHA right before the mistake
git reflog show -n 25

# 2. Inspect the target commit to confirm it is the exact state you want
git show --stat <LOST_COMMIT_SHA>

# 3. Anchor the recovered state onto a new rescue branch
git switch -c rescue/recovered-work <LOST_COMMIT_SHA>

# Verify
git log --oneline -n 5 && git status -s
```

### 3.2 Production Rollback — Safely Reverting a Merged PR (`git revert -m 1`) & Re-Applying Later
Never rewrite history on `main`. Use a forward revert commit.

```bash
# 1. Sync main cleanly
git switch main
git pull --ff-only origin main

# 2. Inspect merge commit parents (parent 1 = mainline/main, parent 2 = merged feature branch)
git show --no-patch --format="%H parents: %P%n%s" <MERGE_COMMIT_SHA>

# 3. Revert the merge commit relative to mainline (-m 1)
git revert -m 1 <MERGE_COMMIT_SHA>
git push origin main

# Verify
git log --oneline -n 3
```

**Re-applying that feature later after fixing the bug:**
If you try to merge the original branch again, Git thinks those commits are already merged and silently ignores them. You must **revert the revert commit** on a fresh branch first:
```bash
git switch -c fix/reapply-feature main
git revert <REVERT_COMMIT_SHA>
# Now apply your bug fix commit(s), test, and open a new PR
git log --oneline -n 3
```

### 3.3 Untangling a Branch Based Off the Wrong Parent Branch (`git rebase --onto`)
Scenario: You accidentally branched `feature/B` off `feature/A` instead of `main`, and now you want ONLY `feature/B`'s commits transplanted cleanly onto `origin/main`.

```bash
# 1. Always create a safety checkpoint first
git switch feature/B
git branch backup-feature-B

# 2. Fetch latest main
git fetch origin --prune

# 3. Replay commits in (feature/A .. feature/B] directly onto origin/main
# Syntax: git rebase --onto <new-base> <old-parent> <branch-to-move>
git rebase --onto origin/main feature/A feature/B

# Verify: confirm feature/A commits are gone and only feature/B commits sit on origin/main
git log --graph --oneline --decorate origin/main..feature/B
```

### 3.4 Binary Search Regression Debugging (`git bisect`)
Find the exact commit that introduced a bug in `O(log n)` steps (1,000 commits → ~10 steps).

```bash
# Manual mode:
git bisect start
git bisect bad HEAD                 # Current commit is broken
git bisect good <LAST_KNOWN_GOOD>   # Older commit/tag where tests passed
# Test the checked-out commit, then mark: git bisect good OR git bisect bad
# Repeat until Git prints "<SHA> is the first bad commit"

# Automated mode (fastest — supply any test command that exits 0 on pass, 1 on fail):
git bisect start HEAD <LAST_KNOWN_GOOD>
git bisect run ./mvnw test -Dtest=OrderServiceTest

# ALWAYS exit bisect cleanly when finished to return to your original branch:
git bisect reset

# Verify back on original branch
git status -s && git branch --show-current
```

### 3.5 Permanent Secret Scrubbing From Repository History (`git-filter-repo`)
> **MANDATORY STEP 0**: **Revoke and rotate the leaked API key / password / token immediately BEFORE running anything below.**

```bash
# 1. Make a fresh mirror clone so you never corrupt your daily working tree
git clone --mirror <REMOTE_URL> repo-scrub-mirror.git
cd repo-scrub-mirror.git

# 2. Scrub an entire accidentally committed file from ALL branches & tags
# (Requires git-filter-repo: brew install git-filter-repo / pip install git-filter-repo)
git filter-repo --invert-paths --path .env

# OR replace specific secret strings across all blobs using a replacements file:
# echo "LITERAL_SECRET_VALUE==>***REMOVED***" > /tmp/replacements.txt
# git filter-repo --replace-text /tmp/replacements.txt

# 3. Re-add origin (git-filter-repo strips origin as a safety guard) and force-push rewritten refs
git remote add origin <REMOTE_URL>
git push origin --force --all
git push origin --force --tags

# Verify: confirm the path/secret no longer exists in history
git log --all --stat -- .env
```
*(Notify teammates to freshly re-clone or hard-reset their local branches so old commits aren't accidentally pushed back.)*

### 3.6 Resolving Git Submodule Pointer Drift & De-Sync
```bash
# 1. Inspect submodule commit status ('+' = drifted pointer, '-' = uninitialized, 'U' = conflict)
git submodule status

# 2. Sync submodule URLs from .gitmodules and restore exact pinned commits recorded by parent repo
git submodule sync --recursive
git submodule update --init --recursive

# 3. If intentionally advancing a submodule to its latest remote commit:
git -C path/to/submodule fetch origin
git -C path/to/submodule switch main
git -C path/to/submodule pull --ff-only origin main
git add path/to/submodule
git commit -m "chore(submodules): bump submodule pointer to verified commit"

# Verify: no leading '+' or '-' in submodule status
git submodule status && git status -s
```
