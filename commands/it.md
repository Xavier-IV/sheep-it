---
name: sheep:it
description: 🐑 Ship it! Create PR for current work
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue list *)
  - Bash(gh pr create *)
  - Bash(git push *)
  - Bash(git fetch *)
  - Bash(git status)
  - Bash(git branch *)
  - Bash(git log *)
  - Bash(git diff *)
  - Bash(git rev-list *)
  - Bash(cat .sheeprc.yml *)
  - AskUserQuestion
  - Skill
---

<objective>
🐑 Ship it! Create a Pull Request for current work.
The endgame command - creates PR and links to issue.
Confirm details before creating.
</objective>

<usage>
```
/sheep:it                      # Create PR for current branch
/sheep:it 22                   # Create PR linked to issue #22
/sheep:it --draft              # Create as draft PR
```
</usage>

<process>

<step name="check-branch">
**Verify not on main/master:**

```bash
current_branch=$(git branch --show-current)
```

If on main/master, use AskUserQuestion:
```
[AskUserQuestion]
Question: "You're on the main branch. What would you like to do?"
Header: "Branch"
Options:
- "Create a new branch first" - description: "I'll help you branch off"
- "Cancel" - description: "I'll sort this out myself"
```
</step>

<step name="check-outdated">
**Check if branch is behind main:**

```bash
git fetch origin
git rev-list --count HEAD..origin/main
```

If behind main (count > 0):
```
⚠️  Your branch is 5 commits behind main.

Recent merges may cause conflicts or your PR may be outdated.
```

```
[AskUserQuestion]
Question: "Your branch is behind main. What would you like to do?"
Header: "Outdated"
Options:
- "Sync first (Recommended)" - description: "Run /sheep:sync to rebase"
- "Create PR anyway" - description: "I'll handle conflicts in the PR"
- "Cancel" - description: "Let me check first"
```

If "Sync first" → tell user to run `/sheep:sync` then come back
</step>

<step name="check-changes">
**Check for uncommitted changes:**

```bash
git status --porcelain
```

If there are uncommitted changes:
```
[AskUserQuestion]
Question: "You have uncommitted changes. What would you like to do?"
Header: "Changes"
Options:
- "Commit them first (Recommended)" - description: "I'll help you commit"
- "Create PR anyway" - description: "Changes won't be in the PR"
- "Cancel" - description: "Let me sort this out"
```
</step>

<step name="find-issue">
**Determine linked issue:**

Try to extract issue number from branch name (e.g., `feature/22-something`).

If no issue found in branch and not provided:
```bash
gh issue list --state open --assignee @me --json number,title --limit 5
```

```
[AskUserQuestion]
Question: "Link this PR to an issue?"
Header: "Link issue"
Options (from assigned issues + none):
- "#22 Studio Working Hours (Recommended)" - description: "You're assigned to this"
- "#23 Fix login" - description: "You're assigned to this"
- "No linked issue" - description: "Standalone PR"
```
</step>

<step name="pr-type">
**Ask PR type:**

```
[AskUserQuestion]
Question: "What type of PR?"
Header: "PR type"
Options:
- "Ready for review (Recommended)" - description: "Reviewers will be notified"
- "Draft" - description: "Work in progress, not ready yet"
```
</step>

<step name="preview">
**Show PR preview:**

Get commit summary:
```bash
git log origin/main..HEAD --oneline
```

Show preview:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🐑 PR PREVIEW

Title: feat: Studio Working Hours (#22)
Branch: feature/22-studio-working-hours → main
Type: Ready for review

Commits:
  • abc1234 Add working hours model
  • def5678 Add hours configuration UI
  • ghi9012 Add validation

Links: Closes #22
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
[AskUserQuestion]
Question: "Create this PR?"
Header: "Confirm"
Options:
- "Yes, ship it! 🐑 (Recommended)" - description: "Create the PR"
- "Edit title" - description: "Change the PR title"
- "Cancel" - description: "Not yet"
```
</step>

<step name="push">
**Push branch to remote:**

```bash
git push -u origin HEAD
```
</step>

<step name="create-pr">
**Create Pull Request:**

Determine prefix from issue labels:
- `bug` → `fix:`
- `enhancement` → `feat:`
- default → `chore:`

```bash
# With linked issue
gh pr create \
  --title "feat: Studio Working Hours (#22)" \
  --body "Closes #22"

# Draft PR
gh pr create --draft \
  --title "feat: Studio Working Hours (#22)" \
  --body "Closes #22"
```
</step>

<step name="adapter-archive">
**Call adapter archive (if configured):**

After creating the PR, check if an adapter should handle archiving/cleanup.

**1. Check for config file:**
```bash
cat .sheeprc.yml 2>/dev/null | grep -A5 "adapter:"
```

**2. If adapter has ship mapping:**
```yaml
adapter:
  enabled: true
  name: "openspec"
  mappings:
    ship: "openspec:archive"
```

**3. If adapter found and enabled with ship mapping:**

```
🔌 Adapter: Running archive step
   → /openspec:archive {issue/PR context}
```

**Delegate to adapter skill:**
```
[Skill tool]
skill: "{adapter.mappings.ship}"  # e.g., "openspec:archive"
args: "{issue number or PR context}"
```

The adapter handles any cleanup, archiving, or finalization needed.

**4. If no adapter or no ship mapping:**

Skip this step - no archive action needed.
</step>

<step name="confirm">
**Show result:**

```
🐑 Shipped #22: Studio Working Hours

✓ Pushed branch: feature/22-studio-working-hours
✓ Created PR #45: feat: Studio Working Hours (#22)
✓ Linked to issue #22
✓ Adapter archive complete (if applicable)

PR: https://github.com/<owner>/<repo>/pull/45

When merged, issue #22 will auto-close! 🎉

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```

**If adapter was used, show adapter status:**
```
🔌 Adapter actions:
   ✓ OpenSpec archive completed
   → Spec files archived/cleaned up
```
</step>

</process>

<interaction-style>
- Always preview before creating
- Use "(Recommended)" for sensible defaults
- If user provides issue number, skip issue picker but still confirm
- Make "Yes, ship it! 🐑" feel satisfying - this is the endgame!
</interaction-style>
