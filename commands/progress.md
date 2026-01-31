---
name: sheep:progress
description: Show milestone progress with issue breakdown
allowed-tools:
  - Bash
---

<objective>
Show detailed progress for a milestone or overall project.
</objective>

<usage>
```
/sheep:progress                # Overall project progress
/sheep:progress v1.4.0         # Specific milestone progress
```
</usage>

<process>

<step name="fetch">
**Fetch data:**

```bash
# Get all milestones
gh api repos/:owner/:repo/milestones --jq '.[] | "\(.title)|\(.open_issues)|\(.closed_issues)"'

# Get issues for specific milestone
gh issue list --milestone "v1.4.0" --state all --json number,title,state
```
</step>

<step name="display">
**Show progress:**

```
🐑 Project Progress

v1.4.0 - Studio improvements
████████░░ 80% complete (4/5)
├─ ✅ #22 Studio Working Hours
├─ ✅ #23 Attendance Tracking
├─ ✅ #25 Live Duration
├─ 🚧 #27 Final testing
└─ ⏳ #28 Documentation

v1.5.0 - Gamification
░░░░░░░░░░ 0% complete (0/1)
└─ ⏳ #24 Mini Game System
```

Legend:
- ✅ = closed
- 🚧 = in progress (has assignee)
- ⏳ = open
</step>

</process>
