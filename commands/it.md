---
name: sheep:it
description: 🐑 Ship it! Create PR for current work
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue list *)
  - Bash(gh pr create *)
  - Bash(git push *)
  - Bash(git status)
  - Bash(git branch *)
  - Bash(git log *)
  - Bash(git diff *)
  - AskUserQuestion
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

<step name="confirm">
**Show result:**

```
🐑 Shipped #22: Studio Working Hours

✓ Pushed branch: feature/22-studio-working-hours
✓ Created PR #45: feat: Studio Working Hours (#22)
✓ Linked to issue #22

PR: https://github.com/<owner>/<repo>/pull/45

When merged, issue #22 will auto-close! 🎉

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<interaction-style>
- Always preview before creating
- Use "(Recommended)" for sensible defaults
- If user provides issue number, skip issue picker but still confirm
- Make "Yes, ship it! 🐑" feel satisfying - this is the endgame!
</interaction-style>
