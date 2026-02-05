# 🐑 Sheep It

**Your GitHub Issues become PRDs. Claude implements them.**

A simple workflow for solo devs. Sheep It uses GitHub Issues as your spec, then Claude actually writes the code. One command to brainstorm, one to implement, one to ship.

## 30-Second Install

```bash
# 1. Install Sheep It
curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/install.sh | bash

# 2. Authenticate GitHub (if not already)
gh auth login && gh auth refresh -h github.com -s project,read:project

# 3. Setup in your project
/sheep:init
```

Requires [Claude Code](https://claude.ai/code) and [GitHub CLI](https://cli.github.com/).

## See It In Action

### Step 1: Brainstorm a task
```
/sheep:task "Add user login"
```
Claude asks clarifying questions, refines scope, and creates a GitHub Issue with acceptance criteria. **The issue IS your PRD.**

### Step 2: Claude implements it
```
/sheep:start 22
```
Claude reads the issue as the spec, writes the code, commits incrementally, and auto-checks acceptance criteria as it completes them.

### Step 3: Ship it
```
/sheep:it 22
```
Creates a PR linked to the issue. When merged, issue auto-closes. Done.

## Why I Built This

I'm a solo dev who wanted something simple. I kept losing context when Claude reset, and managing `.planning/` folders felt like overhead for my small projects.

GitHub Issues already have everything I need:
- They survive Claude context resets (your spec is always there)
- Built-in tracking: checkboxes, labels, milestones, projects
- `/sheep:resume` recovers state instantly by reading git + issues
- No extra files to manage

This is just a personal tool I built for myself. If it helps you too, great!

---

## Commands

<details>
<summary><strong>All Commands Reference</strong></summary>

| Command | Description |
|---------|-------------|
| **Setup** | |
| `/sheep:init [name]` | Create/setup project (private by default) |
| `/sheep:config` | Configure project settings |
| **Planning** | |
| `/sheep:task "title"` | Brainstorm → refine → create issue |
| `/sheep:milestone "v1.0"` | Create milestone with due date |
| **Working** | |
| `/sheep:start [issue]` | Pick issue → implement → commit |
| `/sheep:resume` | Continue after context reset |
| `/sheep:status` | Quick "where am I?" check |
| `/sheep:verify [issue]` | Verify against acceptance criteria |
| `/sheep:sync` | Sync branch with main (rebase/merge) |
| **Shipping** | |
| `/sheep:it [issue]` | Ship it! Create PR |
| `/sheep:release <version>` | Create GitHub release |
| **Tracking** | |
| `/sheep:tasks` | List open issues |
| `/sheep:milestones` | List milestones with progress |
| `/sheep:progress` | Detailed progress view |
| `/sheep:board` | View project board |
| **Collaboration** | |
| `/sheep:review [PR]` | Review a pull request |
| `/sheep:help` | Show all commands |

</details>

## Configuration (Optional)

Create `.sheeprc.yml` or run `/sheep:config`:

```yaml
branch:
  prefix: "feature"
  format: "{prefix}/{issue}-{slug}"

commits:
  style: "conventional"  # feat:, fix:, chore:

auto_update:
  check_criteria: true   # Auto-check acceptance criteria
  progress_comments: true

# Adapter integration (optional)
adapter:
  enabled: true
  name: "openspec"
  mappings:
    task: "openspec:proposal"
    start: "openspec:apply"
    ship: "openspec:archive"
```

## Adapters

Sheep It can integrate with external workflow tools (adapters) for enhanced spec creation and implementation.

### Supported Adapters

| Adapter | Description | Integration |
|---------|-------------|-------------|
| **[OpenSpec](https://github.com/Xavier-IV/openspec)** | Structured spec creation with PRDs | `proposal` → `apply` → `archive` |

### How It Works

When an adapter is configured:

```
/sheep:task "Add login"     →  Calls /openspec:proposal
                               Creates GitHub issue from spec

/sheep:start 22             →  Creates branch, assigns issue
                               Calls /openspec:apply for implementation

/sheep:it                   →  Creates PR
                               Calls /openspec:archive to finalize
```

Sheep It handles all GitHub operations (issues, PRs, tracking) while the adapter handles spec creation and implementation details.

### Auto-Detection

Adapters are auto-detected from available Claude Code skills. To disable:

```yaml
adapter:
  enabled: false
```

## Philosophy

GitHub already has all the infrastructure for project management. Sheep It just connects the dots:

- **Issues** → Your PRD / spec
- **Milestones** → Version planning
- **Projects** → Kanban board
- **Checkboxes** → Acceptance criteria (auto-updated!)
- **Git state** → Progress tracking

Keep it simple. Use what's already there.

---

## Uninstall

To remove Sheep It from your system:

```bash
curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/uninstall.sh | bash
```

This removes the `~/.claude/commands/sheep` directory. Your project files and GitHub data are untouched.

---

MIT License

*🐑 Don't be sheepish, ship it!*
