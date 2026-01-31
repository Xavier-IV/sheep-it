# /sheep:start

Start working on an issue - creates branch and assigns to you.

## Usage

```
/sheep:start 22                # Start working on issue #22
/sheep:start 22 --branch fix   # Custom branch prefix
```

## Behavior

1. **Fetch issue**: Get issue title for branch name
2. **Create branch**: `feature/<issue>-<slug>`
3. **Assign issue**: Assign to current user
4. **Add label**: Add "in progress" label if exists

## Commands Used

```bash
# Get issue title for branch name
gh issue view 22 --json title,number

# Create and checkout branch
git checkout -b feature/22-studio-working-hours

# Assign to self
gh issue edit 22 --add-assignee @me

# Add in-progress label (if exists)
gh issue edit 22 --add-label "in progress"
```

## Output Format

```
🐑 Starting work on #22: Studio Working Hours

✓ Created branch: feature/22-studio-working-hours
✓ Assigned to @Xavier-IV
✓ Marked as in progress

Ready to code! When done:
  /sheep:ship 22
```

## Branch Naming

Converts issue title to kebab-case slug:
- "Studio Working Hours Integration" → `studio-working-hours-integration`
- "Fix: Login Bug" → `fix-login-bug`
- Max 50 chars, truncated if longer

Default format: `feature/<issue-number>-<slug>`
