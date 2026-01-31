---
name: sheep:status
description: Quick status check - where am I and what's the progress?
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue list *)
  - Bash(gh pr list *)
  - Bash(git status)
  - Bash(git branch *)
  - Bash(git log *)
  - AskUserQuestion
---

<objective>
Quick "where am I?" check. Shows current branch, linked issue, progress, and suggested next action.
</objective>

<usage>
```
/sheep:status                  # Show current status
```
</usage>

<process>

<step name="gather">
**Gather current state:**

```bash
# Current branch
git branch --show-current

# Uncommitted changes
git status --porcelain

# Commits ahead of main
git log origin/main..HEAD --oneline 2>/dev/null

# Open PRs
gh pr list --state open --author @me --json number,title,url

# Assigned issues
gh issue list --assignee @me --state open --json number,title
```
</step>

<step name="display">
**Display status:**

```
🐑 Sheep It Status

📍 Current Work:
   Branch: feature/22-studio-working-hours
   Issue:  #22 Studio Working Hours
   Status: In Progress

📝 Progress:
   Commits: 3 ahead of main
   Changes: 2 modified, 1 new file (uncommitted)

   Acceptance Criteria:
   ✅ Working hours model (done)
   ✅ Configuration UI (done)
   🔄 Validation rules (in progress)
   ⏳ API endpoint
   ⏳ Tests

🔀 Open PRs:
   None

📋 Your Issues:
   • #22 Studio Working Hours (current)
   • #25 Fix mobile layout
   • #28 Add dark mode

💡 Suggested: Continue implementing, then /sheep:it 22
```
</step>

<step name="suggest-action">
**Suggest next action based on state:**

| State | Suggestion |
|-------|------------|
| On feature branch with uncommitted changes | "Commit your changes or continue working" |
| On feature branch, all committed | "/sheep:verify 22 then /sheep:it 22" |
| On main, has assigned issues | "/sheep:start to pick up an issue" |
| On main, no assigned issues | "/sheep:tasks to see what's available" |
| Has open PR | "Waiting for review on PR #45" |

```
[AskUserQuestion]
Question: "What would you like to do?"
Header: "Action"
Options:
- "Continue working (Recommended)" - description: "Keep implementing #22"
- "Verify progress" - description: "Run /sheep:verify"
- "Ship it" - description: "Create PR with /sheep:it"
- "Switch to different issue" - description: "Work on something else"
```
</step>

</process>

<interaction-style>
- Be concise - this is a quick check
- Show the most relevant info first
- Always suggest a next action
- Parse acceptance criteria if available
</interaction-style>
