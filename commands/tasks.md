# /sheep:tasks

List open GitHub Issues.

## Usage

```
/sheep:tasks                    # List all open issues
/sheep:tasks --milestone v1.0.0 # Filter by milestone
/sheep:tasks --label bug        # Filter by label
/sheep:tasks --all              # Include closed issues
```

## Behavior

1. **Fetch issues**: `gh issue list [filters]`
2. **Format output**: Show in readable table

## Commands Used

```bash
# All open issues
gh issue list --state open

# By milestone
gh issue list --milestone "v1.4.0"

# By label
gh issue list --label "bug"

# Include closed
gh issue list --state all

# JSON for detailed info
gh issue list --json number,title,state,milestone,labels
```

## Output Format

```
🐑 Open Tasks (5)

#   Title                              Milestone   Labels
22  Studio Working Hours               v1.4.0      enhancement
23  Attendance Tracking                v1.4.0      enhancement
24  Mini Game System                   v1.5.0      enhancement
25  Live Duration Tracking             v1.4.0      enhancement
26  Freelance Agent System             v1.6.0      enhancement

View: https://github.com/user/repo/issues
```
