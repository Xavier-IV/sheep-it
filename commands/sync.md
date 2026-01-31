---
name: sheep:sync
description: Sync branch with main - fetch, rebase/merge, handle conflicts
allowed-tools:
  - Bash(git fetch *)
  - Bash(git rebase *)
  - Bash(git merge *)
  - Bash(git status)
  - Bash(git branch *)
  - Bash(git log *)
  - Bash(git diff *)
  - Bash(git add *)
  - Bash(git rebase --continue)
  - Bash(git rebase --abort)
  - Bash(git stash *)
  - Read
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
---

<objective>
Sync current branch with main/master. Fetch latest, rebase or merge, and handle conflicts.
Run this before /sheep:it to ensure your branch is up to date.
</objective>

<usage>
```
/sheep:sync                    # Sync current branch with main
/sheep:sync --merge            # Use merge instead of rebase
```
</usage>

<process>

<step name="check-state">
**Check current state:**

```bash
# Current branch
git branch --show-current

# Any uncommitted changes?
git status --porcelain

# Fetch latest
git fetch origin
```

If uncommitted changes:
```
[AskUserQuestion]
Question: "You have uncommitted changes. What should I do?"
Header: "Changes"
Options:
- "Stash them (Recommended)" - description: "Save changes, sync, then restore"
- "Commit first" - description: "I'll help you commit"
- "Cancel" - description: "I'll sort this out myself"
```

If stashing:
```bash
git stash push -m "sheep:sync auto-stash"
```
</step>

<step name="check-behind">
**Check if branch is behind:**

```bash
# How many commits behind main?
git rev-list --count HEAD..origin/main

# How many commits ahead?
git rev-list --count origin/main..HEAD
```

Show status:
```
📊 Branch Status: feature/22-add-login

  Your branch:  3 commits ahead of main
  Main branch:  5 commits ahead of you

  You need to sync to include recent changes.
```

If already up to date:
```
✅ Branch is already up to date with main!

No sync needed.
```
</step>

<step name="choose-strategy">
**Choose sync strategy:**

```
[AskUserQuestion]
Question: "How would you like to sync?"
Header: "Strategy"
Options:
- "Rebase (Recommended)" - description: "Clean history, replay your commits on top"
- "Merge" - description: "Create merge commit, preserve history"
- "Cancel" - description: "Not now"
```
</step>

<step name="rebase">
**If rebase:**

```bash
git rebase origin/main
```

If conflicts occur, go to conflict resolution step.

If successful:
```
✅ Rebased successfully!

Your 3 commits are now on top of the latest main.
```
</step>

<step name="merge">
**If merge:**

```bash
git merge origin/main
```

If conflicts occur, go to conflict resolution step.

If successful:
```
✅ Merged successfully!

Created merge commit incorporating latest main.
```
</step>

<step name="conflicts">
**Handle conflicts:**

```bash
# Check which files have conflicts
git diff --name-only --diff-filter=U
```

```
⚠️  Conflicts detected in 2 files:

  • app/models/user.rb
  • app/controllers/auth_controller.rb
```

For each conflicted file:

1. **Show the conflict:**
   ```bash
   git diff <file>
   ```

2. **Ask how to resolve:**
   ```
   [AskUserQuestion]
   Question: "How to resolve app/models/user.rb?"
   Header: "Conflict"
   Options:
   - "Show me the conflict" - description: "I'll review and decide"
   - "Keep our changes" - description: "Use the feature branch version"
   - "Keep their changes" - description: "Use the main branch version"
   - "Help me merge" - description: "Combine both intelligently"
   ```

3. **If "Help me merge":**
   - Read both versions
   - Understand what each change does
   - Propose a merged solution
   - Use Edit tool to fix the file
   - ```bash
     git add <file>
     ```

4. **Continue after all resolved:**
   ```bash
   git rebase --continue
   # or for merge:
   git commit
   ```
</step>

<step name="restore-stash">
**Restore stashed changes (if any):**

```bash
git stash pop
```

If stash conflicts:
```
[AskUserQuestion]
Question: "Stashed changes conflict with synced code. What to do?"
Header: "Stash conflict"
Options:
- "Help me merge (Recommended)" - description: "Combine changes"
- "Drop stash" - description: "Discard my uncommitted changes"
- "Keep stash for later" - description: "I'll handle manually"
```
</step>

<step name="complete">
**Show result:**

```
🐑 Sync Complete!

Branch: feature/22-add-login
Strategy: Rebase
Commits: 3 of yours on top of 5 new from main

✅ Ready to continue working or ship with /sheep:it 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<conflict-resolution-tips>
When helping merge conflicts:

1. **Understand both sides:**
   - What does the main branch change do?
   - What does the feature branch change do?
   - Are they modifying the same thing or different things?

2. **Common patterns:**
   - Both added imports → keep both
   - Both modified same function → need to combine logic
   - One deleted, one modified → ask user intent

3. **After resolution:**
   - Make sure the code still makes sense
   - Run build/tests if possible
   - Mark file as resolved with `git add`
</conflict-resolution-tips>

<interaction-style>
- Auto-detect if sync is needed
- Default to rebase for cleaner history
- Walk through conflicts one by one
- Offer to intelligently merge conflicts
- Always allow user to take manual control
</interaction-style>
