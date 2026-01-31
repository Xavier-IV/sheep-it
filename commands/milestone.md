---
name: sheep:milestone
description: Create a GitHub Milestone
allowed-tools:
  - Bash(gh api repos/:owner/:repo/milestones *)
---

<objective>
Create a GitHub Milestone for grouping related issues.
</objective>

<usage>
```
/sheep:milestone "v1.0.0"                              # Create milestone
/sheep:milestone "v1.0.0" --description "First release"
/sheep:milestone "v1.0.0" --due 2024-03-01             # With due date
```
</usage>

<process>

<step name="create">
**Create the milestone:**

```bash
# Basic
gh api repos/:owner/:repo/milestones \
  -f title="v1.4.0" \
  -f description="Studio improvements"

# With due date (ISO 8601 format)
gh api repos/:owner/:repo/milestones \
  -f title="v1.4.0" \
  -f description="Studio improvements" \
  -f due_on="2024-03-01T00:00:00Z"
```
</step>

<step name="confirm">
**Show result:**

```
🐑 Created milestone: v1.4.0
   Studio improvements
   https://github.com/<owner>/<repo>/milestone/<number>
```
</step>

</process>
