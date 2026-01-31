# /sheep:help

Show all available Sheep It commands.

## Usage

```
/sheep:help                    # Show all commands
/sheep:help init               # Show help for specific command
```

## Output Format

```
🐑 Sheep It - GitHub-native project flow

"Herd your tasks, not markdown files"

Commands:

  Setup
    /sheep:init [name]         Create new project (private by default)
    /sheep:init name --public  Create public repo (explicit)

  Tasks
    /sheep:task "title"        Create GitHub Issue → Backlog
    /sheep:tasks               List open issues
    /sheep:start <issue>       Start work → In Progress
    /sheep:it [issue]          🐑 Ship it! Create PR → Review

  Board
    /sheep:board               View project board status
    /sheep:board --open        Open board in browser

  Milestones
    /sheep:milestone "name"    Create a milestone
    /sheep:milestones          List all milestones
    /sheep:progress [name]     Show progress

  Releases
    /sheep:release <version>   Create GitHub release

  Help
    /sheep:help [command]      Show help

Board Flow:
  ┌──────────┐   ┌─────────────┐   ┌────────┐   ┌──────┐
  │ Backlog  │ → │ In Progress │ → │ Review │ → │ Done │
  └──────────┘   └─────────────┘   └────────┘   └──────┘
     task           start             it         merged

Examples:
  /sheep:init "my-app"              # New private repo + board
  /sheep:task "Add login" --milestone v1.0.0
  /sheep:start 1                    # Branch + assign + move card
  /sheep:it 1                       # PR + move to review
  /sheep:release v1.0.0

Docs: https://github.com/Xavier-IV/sheep-it
```
