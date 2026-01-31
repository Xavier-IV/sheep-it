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
| `/sheep:init` | Initialize new project or setup Sheep It in existing repo |
| `/sheep:task` | Create a GitHub Issue |
| `/sheep:tasks` | List open issues |
| `/sheep:milestone` | Create a milestone |
| `/sheep:milestones` | List milestones with progress |
| `/sheep:progress` | Show milestone progress |
| `/sheep:start` | Start working on an issue (create branch, assign) |
| `/sheep:it` | Create PR for current work |
| `/sheep:release` | Create GitHub release |
| `/sheep:help` | Show this help |

## Core Principles

1. **GitHub is the source of truth** - No duplicate state in markdown files
2. **Use `gh` CLI** - All operations go through GitHub CLI
3. **Keep it simple** - Minimal config, maximum leverage of GitHub features
4. **Audit trail for free** - Git history + GitHub activity = full traceability

## GitHub Feature Mapping

| Sheep It | GitHub |
|----------|--------|
| Task | Issue |
| Milestone | Milestone |
| Progress | Milestone % complete |
| Board | GitHub Projects |
| Release | GitHub Releases |
