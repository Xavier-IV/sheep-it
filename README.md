# 🐑 Sheep It

**GitHub-native project flow for Claude Code**

> "Herd your tasks, not markdown files"

Sheep It is a Claude Code skill that leverages GitHub's native features (Issues, Milestones, Projects, PRs) instead of local markdown files. Everything lives in GitHub - the single source of truth.

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
/sheep:ship                   # Create PR for current branch
/sheep:ship 22                # Create PR linked to issue #22
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
> /sheep:ship 23
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
- `/sheep:ship 25` → In Progress → Review
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
- [ ] `/sheep:task` - Create issue
- [ ] `/sheep:tasks` - List issues
- [ ] `/sheep:milestone` - Create milestone
- [ ] `/sheep:progress` - Show progress
- [ ] `/sheep:start` - Start working (branch + assign)
- [ ] `/sheep:ship` - Create PR

### Phase 2: Project Board
- [ ] `/sheep:board` - Setup/open project board
- [ ] Auto-move cards on status change
- [ ] Column configuration

### Phase 3: Releases
- [ ] `/sheep:release` - Create release
- [ ] Auto-generate changelog from PRs
- [ ] Tag management

### Phase 4: Polish
- [ ] `/sheep:init` - Setup wizard
- [ ] Rich progress visualization
- [ ] Team/assignment features

---

## License

MIT

---

*🐑 Don't be sheepish, ship it!*
