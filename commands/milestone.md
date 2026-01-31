# /sheep:milestone

Create a GitHub Milestone.

## Usage

```
/sheep:milestone "v1.0.0"                              # Create milestone
/sheep:milestone "v1.0.0" --description "First release"
/sheep:milestone "v1.0.0" --due 2024-03-01             # With due date
```

## Behavior

1. **Create milestone**: Via GitHub API
2. **Show result**: Milestone URL

## Commands Used

```bash
# Create milestone
gh api repos/:owner/:repo/milestones \
  -f title="v1.4.0" \
  -f description="Studio improvements"

# With due date (ISO 8601 format)
gh api repos/:owner/:repo/milestones \
  -f title="v1.4.0" \
  -f description="Studio improvements" \
  -f due_on="2024-03-01T00:00:00Z"
```

## Output Format

```
🐑 Created milestone: v1.4.0
   Studio improvements
   https://github.com/user/repo/milestone/1
```
