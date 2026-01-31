---
name: sheep:start
description: Start working on an issue - create branch, assign, move to In Progress
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue edit *)
  - Bash(gh issue list *)
  - Bash(git checkout *)
  - Bash(git switch *)
  - Bash(git branch *)
  - Bash(git push *)
  - AskUserQuestion
---

<objective>
Start working on an issue. Creates a branch, assigns to you, and moves card to In Progress.
If no issue number given, show available issues to pick from.
</objective>

<usage>
```
/sheep:start 22                # Start working on issue #22
/sheep:start                   # Pick from open issues interactively
/sheep:start --branch fix      # Custom branch prefix
```
</usage>

<process>

<step name="select-issue">
**If no issue number provided, show picker:**

First, fetch open issues:
```bash
gh issue list --state open --json number,title,labels --limit 10
```

Then use AskUserQuestion to let user pick:

```
[AskUserQuestion]
Question: "Which issue do you want to work on?"
Header: "Issue"
Options (build from issue list):
- "#22 Studio Working Hours (Recommended)" - description: "enhancement"
- "#23 Fix login button" - description: "bug"
- "#24 Add dark mode" - description: "enhancement"
- "#25 Update docs" - description: "documentation"
```

Mark the oldest/highest priority issue as "(Recommended)" to help user decide.
If issue has "priority" or "urgent" label, put it first.
</step>

<step name="get-issue">
**Get issue details:**

```bash
gh issue view 22 --json number,title,labels
```
</step>

<step name="confirm-start">
**Confirm before starting:**

```
[AskUserQuestion]
Question: "Start working on #22: Studio Working Hours?"
Header: "Confirm"
Options:
- "Yes, start (Recommended)" - description: "Create branch and assign to me"
- "Pick different issue" - description: "Go back to issue list"
- "Cancel" - description: "Not now"
```
</step>

<step name="create-branch">
**Create and checkout branch:**

Convert title to kebab-case slug (max 50 chars):
- "Studio Working Hours" → `studio-working-hours`

```bash
git checkout -b feature/22-studio-working-hours
```
</step>

<step name="assign">
**Assign issue to self:**

```bash
gh issue edit 22 --add-assignee @me
```
</step>

<step name="label">
**Add in-progress label (if exists):**

```bash
gh issue edit 22 --add-label "in progress" 2>/dev/null || true
```
</step>

<step name="confirm">
**Show result:**

```
🐑 Starting work on #22: Studio Working Hours

✓ Created branch: feature/22-studio-working-hours
✓ Assigned to @<username>
✓ Marked as in progress

Ready to code! When done:
  /sheep:it 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<interaction-style>
- If user gives issue number, skip the picker (but still confirm)
- Show max 4 issues in picker (use most recent or highest priority)
- If no open issues, tell user to create one first: /sheep:task
- Mark oldest or priority-labeled issue as "(Recommended)"
</interaction-style>
