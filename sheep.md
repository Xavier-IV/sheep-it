# 🐑 Sheep It

GitHub-native project flow for Claude Code.

> "Herd your tasks, not markdown files"

## Overview

Sheep It leverages GitHub's native features (Issues, Milestones, Projects, Releases) instead of local markdown files. Everything lives in GitHub - the single source of truth.

## Prerequisites

- GitHub CLI (`gh`) must be installed and authenticated
- Run `gh auth status` to verify

## Available Commands

| Command | Description |
|---------|-------------|
| `/sheep:init` | Initialize new project (private by default) + create board |
| `/sheep:task` | Create a GitHub Issue (auto-adds to board) |
| `/sheep:task --deep` | Deep research before creating issue |
| `/sheep:tasks` | List open issues |
| `/sheep:milestone` | Create a milestone |
| `/sheep:milestones` | List milestones with progress |
| `/sheep:progress` | Show milestone progress |
| `/sheep:board` | View/manage GitHub Project board |
| `/sheep:research` | Deep research with parallel agents (codebase, docs, approaches) |
| `/sheep:start` | Start working on an issue (branch + move to In Progress) |
| `/sheep:start --deep` | Research first, then implement |
| `/sheep:it` | 🐑 Ship it! Create PR (move to Review) |
| `/sheep:release` | Create GitHub release |
| `/sheep:help` | Show this help |

## Defaults

- **Private by default**: New repos are private. Use `--public` explicitly for open source.
- **Board included**: `/sheep:init` creates a GitHub Project board automatically.
- **Auto card movement**: Cards move through columns as you work.

## Core Principles

1. **GitHub is the source of truth** - No duplicate state in markdown files
2. **Use `gh` CLI** - All operations go through GitHub CLI
3. **Keep it simple** - Minimal config, maximum leverage of GitHub features
4. **Audit trail for free** - Git history + GitHub activity = full traceability
5. **Safe defaults** - Private repos, explicit public

## GitHub Feature Mapping

| Sheep It | GitHub |
|----------|--------|
| Task | Issue |
| Milestone | Milestone |
| Progress | Milestone % complete |
| Board | GitHub Projects (Kanban) |
| Release | GitHub Releases |

## Board Automation

```
/sheep:task     →  Card in Backlog
/sheep:start    →  Move to In Progress
/sheep:it       →  Move to Review
PR merged       →  Move to Done ✓
```
