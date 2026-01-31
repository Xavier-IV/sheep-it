---
name: sheep:milestone
description: Create a GitHub Milestone
allowed-tools:
  - Bash(gh api repos/:owner/:repo/milestones *)
  - AskUserQuestion
---

<objective>
Create a GitHub Milestone for grouping related issues.
Use interactive questions to gather milestone details.
</objective>

<usage>
```
/sheep:milestone "v1.0.0"                              # Create milestone
/sheep:milestone "v1.0.0" --description "First release"
/sheep:milestone                                       # Interactive mode
```
</usage>

<process>

<step name="gather-details">
**If no name provided, gather details interactively:**

Use AskUserQuestion to ask:

```
[AskUserQuestion]
Question: "What's this milestone for?"
Header: "Purpose"
Options:
- "Feature release (Recommended)" - description: "New features for users"
- "Bug fix release" - description: "Fixes and patches"
- "Major version" - description: "Breaking changes or big updates"
- "Other" - description: "Custom milestone"
```

Then ask for the version/name:
```
[AskUserQuestion - free text via "Other"]
Question: "What version number?"
Header: "Version"
Options:
- "v1.0.0 (Recommended)" - description: "If this is your first release"
- "Increment patch (v1.0.x)" - description: "Bug fixes"
- "Increment minor (v1.x.0)" - description: "New features"
- "Increment major (vX.0.0)" - description: "Breaking changes"
```
</step>

<step name="description">
**Ask for description:**

```
[AskUserQuestion]
Question: "Brief description of this milestone?"
Header: "Description"
Options:
- "Skip for now (Recommended)" - description: "Add description later"
- "Add description" - description: "I want to describe it now"
```

If user wants to add description, let them type it.
</step>

<step name="due-date">
**Ask for due date:**

```
[AskUserQuestion]
Question: "Set a target date?"
Header: "Due date"
Options:
- "No due date (Recommended)" - description: "Ship when it's ready"
- "1 week" - description: "Due in 7 days"
- "2 weeks" - description: "Due in 14 days"
- "1 month" - description: "Due in 30 days"
- "Custom date" - description: "Pick a specific date"
```
</step>

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
   Due: March 1, 2024
   https://github.com/<owner>/<repo>/milestone/<number>

Next steps:
  /sheep:task "First task" --milestone v1.4.0

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<interaction-style>
- Use AskUserQuestion for all choices
- Mark sensible defaults with "(Recommended)"
- Keep it quick - most milestones just need name + optional description
- If user provides name in command, skip to description/due date questions
</interaction-style>
