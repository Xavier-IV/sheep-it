---
name: sheep:task
description: Create a GitHub Issue
allowed-tools:
  - Bash(gh issue create *)
  - Bash(gh label list *)
  - Bash(gh api repos/:owner/:repo/milestones *)
---

<objective>
Create a GitHub Issue. Optionally assign to milestone and add labels.
The issue will automatically appear in the project board's Backlog column.
</objective>

<usage>
```
/sheep:task "title"                           # Create issue with title
/sheep:task "title" --body "description"      # With description
/sheep:task "title" --label bug               # With label
/sheep:task "title" --milestone v1.0.0        # Assign to milestone
/sheep:task                                   # Interactive: ask for details
```
</usage>

<process>

<step name="get-details">
**Get issue details:**

If title provided in args, use it.
If no args, ask user:
1. What's the task title?
2. Description? (optional)
3. Label? (optional - show available with `gh label list`)
4. Milestone? (optional - show available with `gh api repos/:owner/:repo/milestones --jq '.[].title'`)
</step>

<step name="create-issue">
**Create the issue:**

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
</step>

<step name="confirm">
**Show result:**

```
🐑 Created task #<number>: <title>
   https://github.com/<owner>/<repo>/issues/<number>

   → Added to Backlog
```
</step>

</process>
