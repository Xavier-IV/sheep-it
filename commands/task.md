# /sheep:task

Create a GitHub Issue.

## Usage

```
/sheep:task "title"                           # Create issue with title
/sheep:task "title" --body "description"      # With description
/sheep:task "title" --label bug               # With label
/sheep:task "title" --milestone v1.0.0        # Assign to milestone
/sheep:task                                   # Interactive: ask for details
```

## Behavior

1. **Get issue details**: From args or ask user
2. **Create issue**: `gh issue create --title "title" [options]`
3. **Show result**: Issue number and URL

## Commands Used

```bash
# Basic
gh issue create --title "Fix login bug"

# With body
gh issue create --title "Fix login bug" --body "Users can't login with email"

# With label
gh issue create --title "Fix login bug" --label "bug"

# With milestone
gh issue create --title "Add feature X" --milestone "v1.0.0"

# Full example
gh issue create \
  --title "Studio Working Hours" \
  --body "Allow admin to configure studio hours" \
  --label "enhancement" \
  --milestone "v1.4.0"
```

## Output Format

```
🐑 Created task #22: Studio Working Hours
   https://github.com/user/repo/issues/22
```

## Interactive Mode

If just `/sheep:task` is called without arguments, ask:
1. What's the task title?
2. Any description? (optional)
3. Label? (show available labels)
4. Milestone? (show available milestones)
