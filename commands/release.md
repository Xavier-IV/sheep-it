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
</objective>

<usage>
```
/sheep:release v1.4.0                    # Release milestone v1.4.0
/sheep:release v1.4.0 --draft            # Create as draft
/sheep:release v1.4.0 --title "Custom"   # Custom release title
```
</usage>

<process>

<step name="verify">
**Verify milestone is complete:**

```bash
gh api repos/:owner/:repo/milestones --jq '.[] | select(.title == "v1.4.0") | .open_issues'
```

If open_issues > 0:
```
🐑 Cannot release v1.4.0

⚠️  2 tasks still open:
   ⏳ #27 Final testing
   ⏳ #28 Documentation

Complete these tasks first, or use --force to release anyway.
```
</step>

<step name="create-tag">
**Create and push tag:**

```bash
git tag v1.4.0
git push origin v1.4.0
```
</step>

<step name="get-issues">
**Get closed issues for changelog:**

```bash
gh issue list --milestone "v1.4.0" --state closed --json number,title
```
</step>

<step name="create-release">
**Create GitHub release:**

```bash
gh release create v1.4.0 \
  --title "v1.4.0 - Studio improvements" \
  --generate-notes
```

Or with custom notes:
```bash
gh release create v1.4.0 \
  --title "v1.4.0 - Studio improvements" \
  --notes "## What's New

- #22 Studio Working Hours
- #23 Attendance Tracking
- #25 Live Duration

**Full Changelog**: https://github.com/<owner>/<repo>/compare/v1.3.0...v1.4.0"
```
</step>

<step name="close-milestone">
**Close the milestone:**

```bash
# Get milestone number
milestone_number=$(gh api repos/:owner/:repo/milestones --jq '.[] | select(.title == "v1.4.0") | .number')

# Close it
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
```
</step>

</process>
