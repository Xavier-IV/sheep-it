---
name: sheep:start
description: Start working on an issue - create branch, assign, move to In Progress
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue edit *)
  - Bash(git checkout *)
  - Bash(git switch *)
  - Bash(git branch *)
  - Bash(git push *)
---

<objective>
Start working on an issue. Creates a branch, assigns to you, and moves card to In Progress.
</objective>

<usage>
```
/sheep:start 22                # Start working on issue #22
/sheep:start 22 --branch fix   # Custom branch prefix
```
</usage>

<process>

<step name="get-issue">
**Get issue details:**

```bash
gh issue view 22 --json number,title,labels
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
```
</step>

</process>
