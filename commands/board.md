---
name: sheep:board
description: View and manage GitHub Project board
allowed-tools:
  - Bash(gh project list *)
  - Bash(gh project view *)
  - Bash(gh project item-list *)
  - Bash(gh project create *)
  - Bash(gh project link *)
  - AskUserQuestion
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
gh project list --owner @me --format json
```

If no board found for this repo:
```
[AskUserQuestion]
Question: "No project board found. Create one?"
Header: "Setup"
Options:
- "Yes, create board (Recommended)" - description: "Set up Sheep It tracking"
- "Cancel" - description: "Not now"
```
</step>

<step name="display">
**Show board status:**

```bash
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

<step name="actions">
**Offer quick actions:**

```
[AskUserQuestion]
Question: "What would you like to do?"
Header: "Action"
Options:
- "Open in browser (Recommended)" - description: "View full board on GitHub"
- "Start an issue" - description: "Pick something to work on"
- "Create new task" - description: "Add something to backlog"
- "Done" - description: "Exit"
```

Route based on selection:
- "Open" → `gh project view <number> --owner @me --web`
- "Start" → route to `/sheep:start`
- "Create" → route to `/sheep:task`
</step>

<step name="setup">
**If creating new board:**

```bash
gh project create --owner @me --title "<repo-name>"
gh project link <project-number> --owner @me --repo <owner>/<repo-name>
```

```
🐑 Created project board!

✓ Board: <repo-name>
✓ Linked to repository

View: https://github.com/users/<owner>/projects/<number>
```
</step>

</process>

<interaction-style>
- Show visual board representation
- Offer helpful next actions
- Make it easy to jump to common tasks
</interaction-style>
