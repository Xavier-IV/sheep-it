# /sheep:progress

Show detailed progress for a milestone or overall project.

## Usage

```
/sheep:progress                # Overall project progress
/sheep:progress v1.4.0         # Specific milestone progress
```

## Behavior

1. **Fetch milestone(s)**: Via GitHub API
2. **Fetch issues**: Get all issues in milestone
3. **Format output**: Progress bar + issue list

## Commands Used

```bash
# Get milestone details
gh api repos/:owner/:repo/milestones \
  --jq '.[] | select(.title == "v1.4.0")'

# Get issues in milestone
gh issue list --milestone "v1.4.0" --state all \
  --json number,title,state
```

## Output Format

### Overall Progress

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

v1.6.0 - Freelance System
░░░░░░░░░░ 0% complete (0/1)
└─ ⏳ #26 Freelance Agent System
```

### Specific Milestone

```
🐑 v1.4.0 - Studio improvements
   ████████░░ 80% complete

Tasks:
✅ #22 Studio Working Hours          closed 2 days ago
✅ #23 Attendance Tracking           closed yesterday
✅ #25 Live Duration                 closed yesterday
🚧 #27 Final testing                 in progress
⏳ #28 Documentation                 open

View: https://github.com/user/repo/milestone/1
```

## Legend

- ✅ Closed
- 🚧 In Progress (has assignee or "in progress" label)
- ⏳ Open
