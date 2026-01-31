---
name: sheep:milestones
description: List all GitHub Milestones with progress
allowed-tools:
  - Bash(gh api repos/:owner/:repo/milestones *)
---

<objective>
List all GitHub Milestones with their progress.
</objective>

<usage>
```
/sheep:milestones              # List all open milestones
/sheep:milestones --all        # Include closed milestones
```
</usage>

<process>

<step name="fetch">
**Fetch milestones:**

```bash
gh api repos/:owner/:repo/milestones --jq '.[] | "\(.title)|\(.description)|\(.open_issues)|\(.closed_issues)|\(.html_url)"'
```
</step>

<step name="display">
**Show with progress bars:**

Calculate percentage: closed / (open + closed) * 100

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

View: https://github.com/<owner>/<repo>/milestones
```
</step>

</process>
