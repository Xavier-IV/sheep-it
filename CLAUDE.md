# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Sheep It** is a Git workflow orchestrator for solo developers, implemented as a Claude Code skill system. It manages the entire development lifecycle from task creation to PR shipping, using GitHub Issues as specs and GitHub as the single source of truth.

### Architecture

This is a **skill-based CLI tool**, not a traditional codebase:
- **Commands**: Markdown skill files in `/commands` directory define behavior
- **Installation**: Shell scripts that copy skill files to `~/.claude/commands/sheep`
- **No build process**: Skills are interpreted directly by Claude Code
- **No tests**: Skills are declarative prompts, not executable code

### Core Philosophy

1. **GitHub as single source of truth**: Issues, PRs, milestones, and git state contain all project information
2. **Git workflow orchestration**: Sheep It handles all git operations (branch, commit, PR, release)
3. **Adapter delegation**: Complex implementation can be delegated to adapters (e.g., OpenSpec)
4. **Resume-friendly**: State can be recovered from GitHub + git status after context resets

## Skill System Architecture

### Skill File Structure

Each command is a markdown file in `/commands` with:
- **Frontmatter**: YAML with name, description, allowed-tools
- **Objective**: What the skill does
- **Usage**: Example commands
- **Process**: Step-by-step execution logic using XML tags

### Key Skills

| Skill | Purpose | Key Features |
|-------|---------|--------------|
| `task.md` | Create GitHub Issues | Adapter-aware, interactive brainstorming, YOLO metadata |
| `start.md` | Implement issues | Branch creation, adapter delegation, YOLO mode |
| `it.md` | Create PRs | Branch validation, conflict detection, proper linking |
| `review.md` | Review PRs | Parallel agent execution (3 stages), acceptance criteria checking |
| `resume.md` | Recover state | Read git + GitHub to continue work after reset |
| `config.md` | Configure settings | Interactive `.sheeprc.yml` creation |

### Parallel Agent Architecture (New)

The `review.md` skill uses **staged parallel execution** for performance:
- **Stage 1**: 4 parallel agents fetch PR data (info, comments, issue, CI)
- **Stage 2**: 2-5 parallel agents analyze files based on PR size
- **Stage 3**: Optional parallel quality checks for complex PRs

**Important**: When launching parallel agents, use a SINGLE message with MULTIPLE Task tool calls.

## Configuration System

### `.sheeprc.yml` (Project-Level)

Optional configuration file in project root:

```yaml
branch:
  prefix: "feature"              # Branch prefix
  format: "{prefix}/{issue}-{slug}"  # Branch naming pattern

commits:
  style: "conventional"          # feat:, fix:, chore:, etc.

auto_update:
  check_criteria: true           # Auto-check acceptance criteria
  progress_comments: true        # Post progress to issues

adapter:
  enabled: true                  # Enable adapter integration
  name: "openspec"               # Adapter name
  quick_mode: "opsx:ff"          # For /sheep:task --quick
  research_mode: "opsx:explore"  # For /sheep:task --deep
  apply: "opsx:apply"            # For /sheep:start
  verify: "opsx:verify"          # For /sheep:verify (and auto in /sheep:it)
  archive: "opsx:archive"        # For /sheep:it
```

### `.claude/settings.local.json` (User Permissions)

Stores pre-approved permissions for git/gh operations:

```json
{
  "permissions": {
    "allow": [
      "Bash(git push)",
      "Bash(gh issue comment:*)",
      "Bash(gh issue edit:*)",
      "Bash(gh pr create:*)"
    ]
  }
}
```

## Development Workflow

### Making Changes to Skills

1. **Edit skill files**: Modify markdown files in `/commands`
2. **Test locally**: Copy to `~/.claude/commands/sheep` or run install script
3. **No build required**: Changes are immediately effective
4. **Document in README**: Update README.md if behavior changes

### Testing Skills

Since skills are declarative prompts, testing is manual:
1. Run the skill in Claude Code: `/sheep:<command>`
2. Verify correct tool usage and prompts
3. Check GitHub state (issues, PRs) matches expectations
4. Test edge cases (no issue, conflicts, etc.)

### Installation Script Updates

When adding/removing skills:
1. Update `COMMAND_FILES` array in `install.sh`
2. Ensure file is listed for both zip and fallback methods
3. Update README command reference

## Key Implementation Patterns

### Adapter Detection & Delegation

Skills check for adapters before proceeding:

```yaml
# 1. Check .sheeprc.yml for adapter config
# 2. If enabled, delegate to adapter skill
# 3. If disabled/missing, continue with default flow
```

Example in `task.md`:
- Default mode: Pure Sheep It brainstorming (no adapter)
- `--quick` mode: Delegates to OpenSpec `opsx:ff` for fast spec generation
- `--deep` mode: Delegates to OpenSpec `opsx:explore` for research
- Takes adapter output and creates GitHub issue

### YOLO Mode Safety

Issues can be marked for autonomous execution:
- `<!-- YOLO:safe -->` in issue body → proceed autonomously
- `<!-- YOLO:unsafe -->` or no metadata → require confirmation
- `--force` flag overrides safety check

### Progress Tracking

Skills update GitHub state during execution:
- Check off acceptance criteria checkboxes
- Post progress comments to issues
- Update labels (in progress → ready for review)
- Link commits and branches

### Branch Naming Convention

Default: `feature/{issue-number}-{slug}`
- Issue #22 "Add login" → `feature/22-add-login`
- Configurable via `.sheeprc.yml`
- Always includes issue number for traceability

### Commit Message Format

Default conventional commits:
```
feat(#22): add working hours model
fix(#22): handle timezone edge case
test(#22): add model specs
docs(#22): update API documentation
```

## Common Development Tasks

### Adding a New Skill

1. Create `/commands/new-skill.md`
2. Add frontmatter with name, description, allowed-tools
3. Define objective, usage, and process steps
4. Add to `install.sh` COMMAND_FILES array
5. Update README.md command table
6. Test locally: `/sheep:new-skill`

### Updating Parallel Agent Logic

The review skill uses parallel execution:
- Keep progress indicators clear for users
- Use single message with multiple Task calls for true parallelism
- Handle agent failures gracefully (others continue)
- Maintain backward compatibility with existing functionality

### Modifying Configuration Schema

When adding new config options:
1. Update `config.md` with new AskUserQuestion options
2. Document in README.md configuration section
3. Provide sensible defaults if config missing
4. Support both old and new formats for compatibility

## GitHub Integration

### Required Scopes

GitHub CLI must be authenticated with:
- `project` - read/write project boards
- `read:project` - read project data

Command: `gh auth refresh -h github.com -s project,read:project`

### GitHub API Usage

Skills use `gh` CLI exclusively (not direct API calls):
- `gh issue view/create/edit/comment`
- `gh pr view/create/review/diff`
- `gh api` for advanced operations (comments, reviews)

### Workflow Integration

Sheep It works with GitHub Actions:
- `.github/workflows/claude.yml` - Claude Code integration
- `.github/workflows/claude-code-review.yml` - Automated reviews
- Skills can trigger workflows via labels/comments

## Installation & Distribution

### Install Methods

1. **Recommended**: Curl install script
   ```bash
   curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/install.sh | bash
   ```

2. **Manual**: Clone and copy to `~/.claude/commands/sheep`

### Installation Script Features

- Cross-platform (macOS, Linux, Windows Git Bash/WSL)
- Zip download with curl fallback
- Secure cleanup with multiple safety checks
- Preserves existing `.claude/settings.local.json`
- Atomic updates (temp dir → move)

### Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/uninstall.sh | bash
```

Removes `~/.claude/commands/sheep` only. Project files and GitHub data untouched.

## Critical Notes for Claude Code

1. **This is NOT a traditional codebase**: No TypeScript, no build process, no test suite
2. **Skills are prompts**: XML-structured markdown interpreted by Claude Code
3. **State lives in GitHub**: Issues, PRs, git status are the source of truth
4. **Manual testing only**: Run skills and verify GitHub state
5. **Parallel execution**: When updating review skill, use single message with multiple Task calls
6. **Adapter pattern**: Check for adapters before implementing default behavior
7. **Resume-friendly**: Always design features to be recoverable from GitHub + git state
