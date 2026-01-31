# /sheep:milestones

List all GitHub Milestones with progress.

## Usage

```
/sheep:milestones              # List all open milestones
/sheep:milestones --all        # Include closed milestones
```

## Behavior

1. **Fetch milestones**: Via GitHub API
2. **Calculate progress**: open vs closed issues
3. **Format output**: Show with progress bars

## Commands Used

```bash
# List milestones with issue counts
gh api repos/:owner/:repo/milestones \
  --jq '.[] | "\(.title) - \(.open_issues) open, \(.closed_issues) closed"'
```

## Output Format

```
🐑 Milestones

v1.4.0 - Studio improvements
████████░░ 80% (4/5 tasks)
Due: Mar 1, 2024

v1.5.0 - Gamification
░░░░░░░░░░ 0% (0/1 tasks)
No due date

v1.6.0 - Freelance Agent System
░░░░░░░░░░ 0% (0/1 tasks)
No due date

View: https://github.com/user/repo/milestones
```
