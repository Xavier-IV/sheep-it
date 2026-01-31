# 🐑 Sheep It

**GitHub-native project flow for Claude Code**

> "Herd your tasks, not markdown files"

Sheep It is a Claude Code skill that leverages GitHub's native features (Issues, Milestones, Projects, PRs) instead of local markdown files. Everything lives in GitHub - the single source of truth.

## Installation

**One-liner:**
```bash
curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/install.sh | bash
```

**Or manual:**
```bash
# Clone the repo
git clone https://github.com/Xavier-IV/sheep-it.git

# Copy commands to Claude Code
mkdir -p ~/.claude/commands/sheep
cp sheep-it/commands/*.md ~/.claude/commands/sheep/

# Cleanup
rm -rf sheep-it
```

**Prerequisites:**
- [Claude Code](https://claude.ai/code) installed
- [GitHub CLI](https://cli.github.com/) installed and authenticated (`gh auth login`)
- GitHub Project permissions (required for board features):
  ```bash
  gh auth refresh -h github.com -s project,read:project
  ```

---

## Quick Start (First Time)

**Already have a project on GitHub?**
```bash
cd your-project
/sheep:init              # Just sets up project board
```

**Starting fresh?**
```bash
/sheep:init "my-app"     # Creates private repo + board
```

That's it! Now you can start working.

---

## Day-to-Day Workflow

Here's what your typical day looks like with Sheep It:

### Morning: Check what needs doing
```bash
/sheep:progress          # See all milestones and tasks
/sheep:tasks             # List open tasks
```

### Pick a task and start working
```bash
/sheep:start 22          # Creates branch, assigns to you
                         # → Card moves to "In Progress"
```

### Code, commit, repeat...
```bash
# Just your normal coding workflow
git add .
git commit -m "feat: add login form"
```

### Done? Ship it!
```bash
/sheep:it 22             # Creates PR linked to issue #22
                         # → Card moves to "Review"
```

### After PR merged
```bash
# Issue auto-closes, card moves to "Done" ✓
# Ready for next task!
/sheep:start 23
```

### End of milestone? Release it
```bash
/sheep:release v1.0.0    # Creates GitHub release
                         # → Milestone closes
```

---

## Visual Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         YOUR DAY                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   /sheep:progress      "What needs doing?"                      │
│         ↓                                                       │
│   /sheep:start 22      "I'll work on this"                      │
│         ↓              → creates branch                         │
│                        → assigns to you                         │
│      [CODE]            → moves card to In Progress              │
│         ↓                                                       │
│   /sheep:it 22         "Done! Ship it 🐑"                       │
│         ↓              → creates PR                             │
│                        → moves card to Review                   │
│    [PR MERGED]                                                  │
│         ↓              → issue auto-closes                      │
│                        → card moves to Done ✓                   │
│                                                                 │
│   Repeat for next task...                                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

Board View:
┌──────────┐   ┌─────────────┐   ┌────────┐   ┌──────┐
│ Backlog  │ → │ In Progress │ → │ Review │ → │ Done │
├──────────┤   ├─────────────┤   ├────────┤   ├──────┤
│ #24      │   │ #22 ← you   │   │ PR #45 │   │ ✓#21 │
│ #25      │   │             │   │        │   │ ✓#20 │
└──────────┘   └─────────────┘   └────────┘   └──────┘
   task           start             it         merged
```

---

## Why Sheep It?

| Traditional (GSD) | Sheep It |
|-------------------|----------|
| `.planning/` markdown files | GitHub Issues |
| Local milestone docs | GitHub Milestones |
| Phase plans in folders | GitHub Projects board |
| Todo lists in files | GitHub Issue checkboxes |
| Manual state tracking | GitHub PR/Issue status |
| Audit trail in markdown | Git history + GitHub activity |

**The insight:** GitHub already has all the infrastructure. Why duplicate it in markdown?

## Commands

### Project Setup

```bash
/sheep:init                   # Initialize Sheep It in current repo
/sheep:init "project-name"    # Create new private repo + board
/sheep:init "name" --public   # Create public repo (explicit)
```

**Private by default** - to avoid accidental exposure. Use `--public` explicitly for open source.

**What `/sheep:init` does:**
1. Creates GitHub repo (private by default)
2. Sets up GitHub Project board (Backlog → In Progress → Review → Done)
3. Pushes initial commit
4. You're ready to herd! 🐑

### Task Management

```bash
/sheep:task "title"          # Create GitHub Issue
/sheep:tasks                  # List open issues
/sheep:start 22               # Start working on issue #22
/sheep:done 22                # Close issue #22
```

### Milestone Planning

```bash
/sheep:milestone "v1.4.0"     # Create milestone
/sheep:milestones             # List all milestones
/sheep:plan 22 --milestone v1.4.0  # Assign issue to milestone
```

### Progress Tracking

```bash
/sheep:progress               # Show all milestone progress
/sheep:progress v1.4.0        # Show specific milestone
/sheep:board                  # Open GitHub Projects board
```

### Shipping

```bash
/sheep:it                   # Create PR for current branch
/sheep:it 22                # Create PR linked to issue #22
/sheep:release v1.4.0         # Create GitHub release
```

### Quick Actions

```bash
/sheep:label 22 bug           # Add label to issue
/sheep:assign 22 @me          # Assign issue to yourself
/sheep:comment 22 "message"   # Add comment to issue
```

## Workflow Example

```bash
# 1. Plan your milestone
> /sheep:milestone "v1.4.0" --description "Studio improvements"

# 2. Create tasks
> /sheep:task "Studio Working Hours Integration"
Created issue #22

> /sheep:task "Attendance Tracking"
Created issue #23

# 3. Assign to milestone
> /sheep:plan 22 23 --milestone v1.4.0

# 4. Check progress
> /sheep:progress v1.4.0
🐑 v1.4.0 - Studio improvements
   Progress: ████░░░░░░ 1/3 (33%)

   ✅ #22 Studio Working Hours (closed)
   🚧 #23 Attendance Tracking (in progress)
   ⏳ #24 Live Duration (open)

# 5. Start working
> /sheep:start 23
Created branch: feature/23-attendance-tracking
Moved to "In Progress" on project board

# 6. Ship it
> /sheep:it 23
Created PR #45 → linked to issue #23
Ready for review!

# 7. Release when milestone complete
> /sheep:release v1.4.0
🚀 Released v1.4.0!
   - #22 Studio Working Hours
   - #23 Attendance Tracking
   - #24 Live Duration
```

## GitHub Mapping

| Sheep It Concept | GitHub Feature |
|------------------|----------------|
| Task | Issue |
| Milestone | Milestone |
| Phase/Sprint | Project Board Column |
| Progress | Milestone % + Issue counts |
| Plan | Issue body + checkboxes |
| Audit trail | Git commits + Issue timeline |
| Release notes | Auto-generated from merged PRs |

## Project Board Integration

Sheep It can auto-manage a GitHub Project board:

```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│   Backlog   │ In Progress │   Review    │    Done     │
├─────────────┼─────────────┼─────────────┼─────────────┤
│ #25 Live    │ #23 Attend  │ #45 PR      │ #22 Hours   │
│ #26 Freelan │             │             │             │
│             │             │             │             │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

Commands auto-move cards:
- `/sheep:start 25` → Backlog → In Progress
- `/sheep:it 25` → In Progress → Review
- PR merged → Review → Done

## Configuration

```yaml
# .sheep.yml (optional - can also auto-detect)
github:
  owner: Xavier-IV
  repo: com.hoaperfumes.sales

project:
  board: "Sheep It Board"  # GitHub Project name
  columns:
    backlog: "Backlog"
    in_progress: "In Progress"
    review: "Review"
    done: "Done"

defaults:
  labels:
    task: ["enhancement"]
    bug: ["bug"]
  branch_prefix: "feature/"
```

## Installation

```bash
# Add to Claude Code skills
claude skill add sheep-it

# Or clone and link
git clone https://github.com/you/sheep-it
claude skill link ./sheep-it
```

## Philosophy

1. **GitHub is the source of truth** - No duplicate state in markdown
2. **Use what exists** - Issues, Milestones, Projects are battle-tested
3. **Audit trail for free** - Git history + GitHub activity
4. **Collaborative by default** - Team can see everything in GitHub
5. **Scriptable** - `gh` CLI underneath, extend as needed

## Tech Stack

- **Claude Code Skill** - The interface
- **GitHub CLI (`gh`)** - All GitHub operations
- **GitHub API** - For advanced queries
- **Git** - Branch management

## MVP Scope

### Phase 1: Core Commands
- [ ] `/sheep:init` - Create private repo + project board
- [ ] `/sheep:task` - Create issue (→ Backlog)
- [ ] `/sheep:tasks` - List issues
- [ ] `/sheep:milestone` - Create milestone
- [ ] `/sheep:milestones` - List milestones
- [ ] `/sheep:progress` - Show progress
- [ ] `/sheep:board` - View project board
- [ ] `/sheep:start` - Start working (branch + → In Progress)
- [ ] `/sheep:it` - Create PR (→ Review)
- [ ] `/sheep:release` - Create GitHub release

### Phase 2: Board Automation
- [ ] Auto-move cards when PR merged (→ Done)
- [ ] Custom column configuration
- [ ] Sprint/iteration support

### Phase 3: Polish
- [ ] Auto-generate changelog from merged PRs
- [ ] Tag management
- [ ] Rich progress visualization
- [ ] Team/assignment features
- [ ] `/sheep:help` - Show all commands

---

## License

MIT

---

*🐑 Don't be sheepish, ship it!*
