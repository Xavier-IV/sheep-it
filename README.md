# 🐑 Sheep It

**Your GitHub Issues become PRDs. Claude implements them.**

Stop managing `.planning/` folders and markdown files. Sheep It uses GitHub Issues as your spec, then Claude actually writes the code. One command to brainstorm, one to implement, one to ship.

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

## What Makes This Different

| Approach | How it works | The catch |
|----------|--------------|-----------|
| **Plain gh CLI** | Manual issue creation, manual branch management | No AI assistance, you write everything |
| **GSD** | Detailed planning phases in `.planning/` folders | Heavy process, context lost on reset |
| **Sheep It** | GitHub Issues = PRD, Claude implements | Just works. Issues persist, context recovers. |

**Why GitHub Issues?**
- They survive Claude context resets (your spec is always there)
- Built-in tracking: checkboxes, labels, milestones, projects
- `/sheep:resume` recovers state instantly by reading git + issues
- No markdown file sprawl to manage

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
```

## Philosophy

| Traditional | Sheep It |
|-------------|----------|
| `.planning/` markdown files | GitHub Issues |
| Local milestone docs | GitHub Milestones |
| Phase plans in folders | GitHub Projects board |
| Todo lists in files | Issue checkboxes (auto-updated!) |
| Manual state tracking | Git + GitHub status |
| Context lost on reset | `/sheep:resume` recovers |

**The insight:** GitHub already has all the infrastructure. Why rebuild it?

---

MIT License

*🐑 Don't be sheepish, ship it!*
