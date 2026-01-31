---
name: sheep:board
description: View and manage GitHub Project board
allowed-tools:
  - Bash(gh project list *)
  - Bash(gh project view *)
  - Bash(gh project item-list *)
  - Bash(gh project create *)
---

<objective>
View and manage the GitHub Project board for this repository.
</objective>

<usage>
```
/sheep:board                   # Show board status
/sheep:board --open            # Open board in browser
/sheep:board --setup           # Create board if doesn't exist
```
</usage>

<process>

<step name="find-board">
**Find project board:**

```bash
# List projects
gh project list --owner @me --format json
```
</step>

<step name="display">
**Show board status:**

```bash
# Get project items
gh project item-list <number> --owner @me --format json
```

Format output:
```
🐑 Project Board: my-cool-app

┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐
│     Backlog     │   In Progress   │     Review      │      Done       │
├─────────────────┼─────────────────┼─────────────────┼─────────────────┤
│ #5 API docs     │ #3 Auth system  │ PR #12 (→#2)    │ ✓ #1 Setup      │
│ #6 Testing      │                 │                 │ ✓ #4 Database   │
└─────────────────┴─────────────────┴─────────────────┴─────────────────┘

View: https://github.com/users/<owner>/projects/<number>
```
</step>

<step name="open">
**If --open flag:**

```bash
gh project view <number> --owner @me --web
```
</step>

<step name="setup">
**If --setup flag and no board exists:**

```bash
gh project create --owner @me --title "<repo-name>"
```
</step>

</process>
