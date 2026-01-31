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

Commands:

  Setup
    /sheep:init [name]         Create new project or init in existing repo

  Tasks
    /sheep:task "title"        Create a GitHub Issue
    /sheep:tasks               List open issues
    /sheep:start <issue>       Start working on an issue
    /sheep:ship [issue]        Create PR for current work

  Milestones
    /sheep:milestone "name"    Create a milestone
    /sheep:milestones          List all milestones
    /sheep:progress [name]     Show progress

  Releases
    /sheep:release <version>   Create GitHub release

  Help
    /sheep:help [command]      Show help

Examples:
  /sheep:init "my-app" --private
  /sheep:task "Fix login bug" --label bug
  /sheep:start 22
  /sheep:ship 22
  /sheep:release v1.0.0

Docs: https://github.com/Xavier-IV/sheep-it
```
