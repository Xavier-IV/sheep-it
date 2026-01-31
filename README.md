# 🐑 Sheep It

**GitHub-native project flow for Claude Code**

> "Herd your tasks, not markdown files"

Sheep It turns GitHub Issues into your PRD. Create tasks through interactive brainstorming, then let Claude implement them - with auto-updating checkboxes, progress comments, and seamless git workflow.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/install.sh | bash
```

**Prerequisites:**
- [Claude Code](https://claude.ai/code) installed
- [GitHub CLI](https://cli.github.com/) installed and authenticated
- GitHub Project permissions:
  ```bash
  gh auth login
  gh auth refresh -h github.com -s project,read:project
  ```

---

## Quick Start

```bash
# Setup in existing repo
/sheep:init

# Or create new project
/sheep:init "my-app"
```

---

## The Workflow

### 1. Create a Task (Interactive Brainstorming)
```
/sheep:task "Add user login"
```
Claude asks clarifying questions, helps define scope, and creates a well-structured GitHub Issue with acceptance criteria.

### 2. Start Working (Actually Implements Code!)
```
/sheep:start 22
```
- Creates branch `feature/22-add-login`
- Reads the issue as the spec
- **Actually writes the code**
- Auto-checks acceptance criteria as completed
- Posts progress comments on the issue

### 3. Verify & Sync
```
/sheep:verify 22    # Check all acceptance criteria met
/sheep:sync         # Rebase on latest main
```

### 4. Ship It!
```
/sheep:it 22
```
Creates PR linked to issue. When merged, issue auto-closes.

### 5. Release
```
/sheep:release v1.0.0
```
Creates GitHub release, closes milestone.

---

## Commands

| Command | Description |
|---------|-------------|
| **Setup** | |
| `/sheep:init [name]` | Create/setup project (private by default) |
| `/sheep:config` | Configure project settings (`.sheeprc.yml`) |
| **Planning** | |
| `/sheep:task "title"` | Brainstorm → refine → create issue |
| `/sheep:milestone "v1.0"` | Create milestone with due date |
| **Working** | |
| `/sheep:start [issue]` | Pick issue → **implement** → commit |
| `/sheep:resume` | Continue after context reset |
| `/sheep:status` | Quick "where am I?" check |
| `/sheep:verify [issue]` | Verify against acceptance criteria |
| `/sheep:sync` | Sync branch with main (rebase/merge) |
| **Shipping** | |
| `/sheep:it [issue]` | 🐑 Ship it! Create PR |
| `/sheep:release <version>` | Create GitHub release |
| **Tracking** | |
| `/sheep:tasks` | List open issues |
| `/sheep:milestones` | List milestones with progress |
| `/sheep:progress` | Detailed progress view |
| `/sheep:board` | View project board |
| **Collaboration** | |
| `/sheep:review [PR]` | Review a pull request |
| `/sheep:help` | Show all commands |

---

## Key Features

### 🧠 Interactive Brainstorming
`/sheep:task` doesn't just create issues - it has a conversation to refine your idea:

```
> /sheep:task "Add payments"

┌─────────────────────────────────────────┐
│ Payment type?              [Type]       │
│ ● Subscription (Recommended)            │
│ ○ One-time purchase                     │
│ ○ Both                                  │
└─────────────────────────────────────────┘
```

### 💻 Actually Writes Code
`/sheep:start` doesn't just create a branch - it implements the feature:
- Reads issue as the spec
- Explores codebase for patterns
- Writes code, commits incrementally
- Auto-updates issue checkboxes

### ✅ Auto-Update Issues
As you complete acceptance criteria, the issue checkboxes get checked automatically:
```
## Acceptance Criteria
- [x] User can enter email and password ← auto-checked!
- [x] Invalid credentials show error
- [ ] Redirect to dashboard (in progress)
```

### 🔄 Resume After Context Reset
```
/sheep:resume
```
Picks up where you left off by reading git state and issue progress.

### 🔀 Smart Conflict Handling
```
/sheep:sync
```
Rebases on main and walks you through conflicts interactively.

---

## Board Flow

```
Backlog        In Progress      Review         Done
─────────      ───────────      ──────         ────
#24 Feature    #22 Login ←you   PR #45         ✓#21
#25 Bug fix                                    ✓#20
    │               │              │              │
    └── /task ──────┴── /start ────┴── /it ──────┴── merged
```

---

## Philosophy

| Traditional Approach | Sheep It |
|---------------------|----------|
| `.planning/` markdown files | GitHub Issues |
| Local milestone docs | GitHub Milestones |
| Phase plans in folders | GitHub Projects board |
| Todo lists in files | Issue checkboxes (auto-updated!) |
| Manual state tracking | Git + GitHub status |
| Context lost on reset | `/sheep:resume` recovers |

**The insight:** GitHub already has all the infrastructure. The issue body IS the PRD.

---

## Configuration (Optional)

Create `.sheeprc.yml` in your project:

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

Or run `/sheep:config` for interactive setup.

---

## License

MIT

---

*🐑 Don't be sheepish, ship it!*
