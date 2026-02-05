---
name: sheep:config
description: Configure Sheep It settings for this project
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
---

<objective>
Configure project-specific Sheep It settings. Creates/edits .sheeprc.yml in project root.
</objective>

<usage>
```
/sheep:config                  # Interactive configuration
/sheep:config --show           # Show current config
```
</usage>

<process>

<step name="check-existing">
**Check for existing config:**

Look for `.sheeprc.yml` in project root.

If exists, read and show current settings.
If not, offer to create with defaults.
</step>

<step name="configure">
**Interactive configuration:**

```
[AskUserQuestion]
Question: "What would you like to configure?"
Header: "Config"
Options (multiSelect: true):
- "Branch naming (Recommended)" - description: "Prefix and format for branches"
- "Commit style" - description: "Conventional commits, etc."
- "Labels" - description: "Default labels for issues"
- "Auto-update issues" - description: "Check boxes and add comments"
- "Adapter integration" - description: "Connect external workflow tools (e.g., OpenSpec)"
```
</step>

<step name="branch-config">
**Branch naming:**

```
[AskUserQuestion]
Question: "Branch prefix style?"
Header: "Branch"
Options:
- "feature/123-title (Recommended)" - description: "feature/22-add-login"
- "issue-123-title" - description: "issue-22-add-login"
- "123-title" - description: "22-add-login"
- "Custom" - description: "Define your own pattern"
```
</step>

<step name="commit-config">
**Commit style:**

```
[AskUserQuestion]
Question: "Commit message style?"
Header: "Commits"
Options:
- "Conventional (Recommended)" - description: "feat:, fix:, chore:, etc."
- "Issue prefix" - description: "[#22] Add login feature"
- "Simple" - description: "No specific format"
```
</step>

<step name="labels-config">
**Default labels:**

```
[AskUserQuestion]
Question: "Label for new features?"
Header: "Feature label"
Options:
- "enhancement (Recommended)" - description: "GitHub default"
- "feature" - description: "Custom label"
- "None" - description: "No auto-label"
```

```
[AskUserQuestion]
Question: "Label for bugs?"
Header: "Bug label"
Options:
- "bug (Recommended)" - description: "GitHub default"
- "fix" - description: "Custom label"
- "None" - description: "No auto-label"
```
</step>

<step name="auto-update-config">
**Auto-update settings:**

```
[AskUserQuestion]
Question: "Auto-update issues during implementation?"
Header: "Auto-update"
Options (multiSelect: true):
- "Check off acceptance criteria (Recommended)" - description: "Update checkboxes as you complete them"
- "Add progress comments" - description: "Post comments when starting/finishing"
- "None" - description: "Don't auto-update"
```
</step>

<step name="adapter-config">
**Adapter integration:**

Adapters allow Sheep It to delegate parts of its workflow to external tools like OpenSpec.

```
[AskUserQuestion]
Question: "Configure workflow adapter?"
Header: "Adapter"
Options:
- "Auto-detect (Recommended)" - description: "Automatically detect available adapters (e.g., /openspec:*)"
- "OpenSpec" - description: "Use OpenSpec for spec creation and implementation"
- "Custom" - description: "Define custom adapter mappings"
- "Disabled" - description: "Don't use any adapter"
```

If "Custom" selected:
```
[AskUserQuestion]
Question: "Enter adapter skill for quick mode (/sheep:task --quick):"
Header: "Quick mode"
Options:
- "opsx:ff (Recommended)" - description: "OpenSpec fast-forward (new + all artifacts)"
- "None" - description: "Disable --quick flag"
```

```
[AskUserQuestion]
Question: "Enter adapter skill for research mode (/sheep:task --deep):"
Header: "Research mode"
Options:
- "opsx:explore (Recommended)" - description: "OpenSpec exploration (explore + new + continue)"
- "None" - description: "Use Sheep It research without adapter"
```

```
[AskUserQuestion]
Question: "Enter adapter skill for implementation (/sheep:start):"
Header: "Implementation"
Options:
- "opsx:apply (Recommended)" - description: "OpenSpec apply command"
- "None" - description: "Use default sheep:start flow"
```

```
[AskUserQuestion]
Question: "Enter adapter skill for verification (/sheep:verify):"
Header: "Verification"
Options:
- "opsx:verify (Recommended)" - description: "OpenSpec verify command (auto-runs in /sheep:it)"
- "None" - description: "Skip verification step"
```

```
[AskUserQuestion]
Question: "Enter adapter skill for finalization (/sheep:it):"
Header: "Finalization"
Options:
- "opsx:archive (Recommended)" - description: "OpenSpec archive command"
- "None" - description: "Use default sheep:it flow"
```
</step>

<step name="save">
**Save configuration:**

Write `.sheeprc.yml`:

```yaml
# Sheep It Configuration
# https://github.com/Xavier-IV/sheep-it

branch:
  prefix: "feature"
  format: "{prefix}/{issue}-{slug}"
  # Results in: feature/22-add-login

commits:
  style: "conventional"
  # feat:, fix:, chore:, docs:, test:, refactor:

labels:
  feature: "enhancement"
  bug: "bug"
  chore: "chore"

auto_update:
  check_criteria: true
  progress_comments: true

# Adapter integration (optional)
# Delegates workflow steps to external tools like OpenSpec
adapter:
  enabled: true                   # Set to false to disable adapter
  name: "openspec"                # Adapter name (auto-detected if not set)
  quick_mode: "opsx:ff"           # Fast spec for /sheep:task --quick
  research_mode: "opsx:explore"   # Deep research for /sheep:task --deep
  apply: "opsx:apply"             # Implementation for /sheep:start
  verify: "opsx:verify"           # Verification for /sheep:verify (auto in /sheep:it)
  archive: "opsx:archive"         # Finalization for /sheep:it
```

```
🐑 Configuration saved to .sheeprc.yml

Settings:
  Branch: feature/{issue}-{slug}
  Commits: Conventional (feat:, fix:, etc.)
  Labels: enhancement, bug, chore
  Auto-update: ✅ checkboxes, ✅ comments
  Adapter: openspec (--quick → ff, --deep → explore, start → apply, verify → verify, ship → archive)

💡 Tip: Commit this file to share settings with your team.
```
</step>

</process>

<config-schema>
```yaml
# .sheeprc.yml schema

branch:
  prefix: string          # "feature", "issue", ""
  format: string          # "{prefix}/{issue}-{slug}"

commits:
  style: string           # "conventional", "issue-prefix", "simple"
  scope: boolean          # Include scope in conventional commits

labels:
  feature: string         # Label for features
  bug: string             # Label for bugs
  chore: string           # Label for chores
  in_progress: string     # Label when work starts

auto_update:
  check_criteria: boolean # Auto-check acceptance criteria
  progress_comments: boolean # Add progress comments to issues

project:
  board: string           # GitHub Project name (auto-detected if not set)

adapter:
  enabled: boolean        # Enable/disable adapter integration
  name: string            # Adapter name (e.g., "openspec") - auto-detected if not set
  quick_mode: string      # Skill for fast spec (e.g., "opsx:ff")
  research_mode: string   # Skill for deep research (e.g., "opsx:explore")
  apply: string           # Skill for implementation (e.g., "opsx:apply")
  verify: string          # Skill for verification (e.g., "opsx:verify")
  archive: string         # Skill for finalization (e.g., "opsx:archive")
```
</config-schema>

<interaction-style>
- Use sensible defaults
- Don't require config - everything should work without it
- Make it easy to share with team (commit the file)
</interaction-style>
