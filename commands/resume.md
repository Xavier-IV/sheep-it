---
name: sheep:resume
description: Resume interrupted work - pick up where you left off
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue list *)
  - Bash(git status)
  - Bash(git branch *)
  - Bash(git log *)
  - Bash(git diff *)
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
  - Task
---

<objective>
Resume work after a context reset or break. Reads the current state from git and GitHub,
reconstructs context, and continues implementation.
</objective>

<usage>
```
/sheep:resume                  # Auto-detect current work
/sheep:resume 22               # Resume specific issue #22
```
</usage>

<process>

<step name="detect-state">
**Detect current state:**

```bash
# What branch are we on?
git branch --show-current

# Any uncommitted changes?
git status --porcelain

# Recent commits on this branch
git log origin/main..HEAD --oneline 2>/dev/null || git log -5 --oneline

# Extract issue number from branch name (e.g., feature/22-something)
```

If on main/master with no feature branch:
```
[AskUserQuestion]
Question: "No work in progress detected. What would you like to do?"
Header: "No WIP"
Options:
- "Start a new task (Recommended)" - description: "Pick an issue to work on"
- "I was working on something" - description: "Let me specify the issue"
```
</step>

<step name="get-issue-context">
**Get full issue context:**

```bash
gh issue view <number> --json number,title,body,labels,comments
```

Parse:
- Title and description
- Acceptance criteria (checkboxes)
- Tasks/subtasks
- Any comments (might have progress notes)
</step>

<step name="analyze-progress">
**Analyze what's been done:**

1. Check commits on branch - what's implemented?
2. Check uncommitted changes - work in progress?
3. Parse acceptance criteria - which are likely done?

```
🐑 Resuming #22: Studio Working Hours

Branch: feature/22-studio-working-hours
Commits so far:
  • abc1234 feat(hours): add working hours model
  • def5678 feat(hours): add configuration UI

Uncommitted changes:
  M app/models/working_hour.rb
  A app/views/hours/index.html.erb

Acceptance Criteria:
  ✅ Working hours model exists (commit abc1234)
  ✅ Configuration UI (commit def5678)
  🔄 Validation rules (uncommitted changes)
  ⏳ API endpoint
  ⏳ Tests
```
</step>

<step name="confirm-continue">
**Confirm where to continue:**

```
[AskUserQuestion]
Question: "Where would you like to continue?"
Header: "Resume"
Options:
- "Continue from uncommitted work (Recommended)" - description: "Pick up validation rules"
- "Start next acceptance criterion" - description: "Move to API endpoint"
- "Show me the full issue" - description: "Let me review the spec"
- "Start fresh" - description: "Discard progress and restart"
```
</step>

<step name="continue-implementation">
**Continue implementation:**

Same as `/sheep:start` implementation step:
- Work through remaining acceptance criteria
- Commit incrementally
- Run checks
- Verify completion

Reference the issue body as the spec.
</step>

<step name="complete">
**When done:**

```
🐑 Completed #22: Studio Working Hours

Acceptance Criteria:
✅ Working hours model exists
✅ Configuration UI
✅ Validation rules
✅ API endpoint
✅ Tests

All criteria met! Ready to ship: /sheep:it 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<interaction-style>
- Auto-detect as much as possible from git state
- Show clear progress summary
- Let user choose where to continue
- Reference the issue as the source of truth
</interaction-style>
