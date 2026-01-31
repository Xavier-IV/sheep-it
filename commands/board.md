# /sheep:board

View and manage the GitHub Project board.

## Usage

```
/sheep:board                   # Show board status
/sheep:board --open            # Open board in browser
/sheep:board --setup           # Create board if doesn't exist
```

## Behavior

1. **Find project**: Look for GitHub Project linked to repo
2. **Fetch status**: Get items in each column
3. **Display board**: Show Kanban view in terminal

## Commands Used

```bash
# List projects for current user
gh project list --owner @me

# Get project items
gh project item-list <project-number> --owner @me --format json

# Open in browser
gh project view <project-number> --owner @me --web

# Create project if needed
gh project create --owner @me --title "repo-name"

# Add item to project
gh project item-add <project-number> --owner @me --url <issue-url>
```

## Output Format

```
🐑 Project Board: my-cool-app

┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐
│     Backlog     │   In Progress   │     Review      │      Done       │
├─────────────────┼─────────────────┼─────────────────┼─────────────────┤
│ #5 API docs     │ #3 Auth system  │ PR #12 (→#2)    │ ✓ #1 Setup      │
│ #6 Testing      │                 │                 │ ✓ #4 Database   │
│ #7 Deploy       │                 │                 │                 │
├─────────────────┼─────────────────┼─────────────────┼─────────────────┤
│ 3 items         │ 1 item          │ 1 item          │ 2 items         │
└─────────────────┴─────────────────┴─────────────────┴─────────────────┘

View: https://github.com/users/Xavier-IV/projects/5
```

## Board Automation

When using Sheep It commands, cards auto-move:

| Command | Card Movement |
|---------|---------------|
| `/sheep:task` | → Backlog |
| `/sheep:start 5` | Backlog → In Progress |
| `/sheep:it 5` | In Progress → Review |
| PR merged | Review → Done |

## Integration with Other Commands

**`/sheep:task`** - Adds issue to Backlog:
```bash
# Create issue
gh issue create --title "New feature"

# Add to project board (auto-goes to Backlog)
gh project item-add <project-num> --owner @me --url <issue-url>
```

**`/sheep:start`** - Moves to In Progress:
```bash
# Get item ID
gh project item-list <project-num> --owner @me --format json | jq '.items[] | select(.content.number == 5)'

# Update status field to "In Progress"
gh project item-edit --project-id <id> --id <item-id> --field-id <status-field-id> --single-select-option-id <in-progress-option-id>
```

**`/sheep:it`** - Moves to Review:
```bash
# Similar to above, move to "Review" column
```

## No Board Found

If no project board exists:
```
🐑 No project board found for this repo.

Create one?
  /sheep:board --setup

Or create manually:
  https://github.com/new/project
```
