---
name: sheep:release
description: Create GitHub Release for a milestone
allowed-tools:
  - Bash(gh api repos/:owner/:repo/milestones *)
  - Bash(gh issue list *)
  - Bash(gh release create *)
  - Bash(git tag *)
  - Bash(git push *)
  - AskUserQuestion
---

<objective>
Create a GitHub Release for a completed milestone.
Generates changelog from closed issues and creates git tag.
Confirm before releasing.
</objective>

<usage>
```
/sheep:release v1.4.0                    # Release milestone v1.4.0
/sheep:release                           # Pick milestone interactively
/sheep:release v1.4.0 --draft            # Create as draft
```
</usage>

<process>

<step name="select-milestone">
**If no milestone specified, show picker:**

```bash
gh api repos/:owner/:repo/milestones --jq '.[] | "\(.title)|\(.open_issues)|\(.closed_issues)"'
```

```
[AskUserQuestion]
Question: "Which milestone do you want to release?"
Header: "Milestone"
Options (from milestone list):
- "v1.4.0 (Recommended)" - description: "3 closed, 0 open - ready!"
- "v1.3.0" - description: "5 closed, 2 open - not complete"
- "v1.2.0" - description: "Already released"
```

Mark milestones with 0 open issues as "(Recommended)".
</step>

<step name="verify">
**Check if milestone is complete:**

```bash
gh api repos/:owner/:repo/milestones --jq '.[] | select(.title == "v1.4.0") | .open_issues'
```

If open_issues > 0:
```
[AskUserQuestion]
Question: "v1.4.0 has 2 open issues. What do you want to do?"
Header: "Open issues"
Options:
- "Show me the issues" - description: "List what's not done"
- "Release anyway (Recommended)" - description: "Ship what's ready"
- "Cancel" - description: "Finish the issues first"
```

If "Show me":
```
⏳ #27 Final testing
⏳ #28 Documentation

These issues will remain open after release.
```

Then ask again.
</step>

<step name="release-type">
**Ask release type:**

```
[AskUserQuestion]
Question: "What type of release?"
Header: "Type"
Options:
- "Full release (Recommended)" - description: "Published and visible"
- "Draft release" - description: "Save for later, not published"
- "Pre-release" - description: "Beta/RC, marked as pre-release"
```
</step>

<step name="release-notes">
**Ask about release notes:**

```
[AskUserQuestion]
Question: "How do you want to generate release notes?"
Header: "Notes"
Options:
- "Auto-generate (Recommended)" - description: "From closed issues and PRs"
- "Custom notes" - description: "I'll write them myself"
- "No notes" - description: "Just the tag"
```
</step>

<step name="preview">
**Show release preview:**

Get closed issues:
```bash
gh issue list --milestone "v1.4.0" --state closed --json number,title
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 RELEASE PREVIEW

Version: v1.4.0
Title: v1.4.0 - Studio improvements
Type: Full release

What's included:
✅ #22 Studio Working Hours
✅ #23 Attendance Tracking
✅ #25 Live Duration

Actions:
• Create git tag v1.4.0
• Create GitHub release
• Close milestone
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
[AskUserQuestion]
Question: "Create this release?"
Header: "Confirm"
Options:
- "Yes, release it! 🚀 (Recommended)" - description: "Ship it!"
- "Edit title" - description: "Change the release title"
- "Cancel" - description: "Not yet"
```
</step>

<step name="create-tag">
**Create and push tag:**

```bash
git tag v1.4.0
git push origin v1.4.0
```
</step>

<step name="create-release">
**Create GitHub release:**

```bash
gh release create v1.4.0 \
  --title "v1.4.0 - Studio improvements" \
  --generate-notes
```

Or draft:
```bash
gh release create v1.4.0 --draft \
  --title "v1.4.0 - Studio improvements" \
  --generate-notes
```
</step>

<step name="close-milestone">
**Close the milestone:**

```bash
milestone_number=$(gh api repos/:owner/:repo/milestones --jq '.[] | select(.title == "v1.4.0") | .number')
gh api repos/:owner/:repo/milestones/$milestone_number -X PATCH -f state="closed"
```
</step>

<step name="confirm">
**Show result:**

```
🐑 Released v1.4.0 - Studio improvements

Included:
✅ #22 Studio Working Hours
✅ #23 Attendance Tracking
✅ #25 Live Duration

✓ Created tag: v1.4.0
✓ Created release
✓ Closed milestone

🚀 https://github.com/<owner>/<repo>/releases/tag/v1.4.0

Congratulations on shipping! 🎉
```
</step>

</process>

<interaction-style>
- Preview everything before releasing
- Make incomplete milestones obvious but not blocking
- "Yes, release it! 🚀" should feel satisfying
- Celebrate the release at the end!
</interaction-style>
