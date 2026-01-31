---
name: sheep:it
description: 🐑 Ship it! Create PR for current work
allowed-tools:
  - Bash
---

<objective>
🐑 Ship it! Create a Pull Request for current work.
The endgame command - creates PR and links to issue.
</objective>

<usage>
```
/sheep:it                      # Create PR for current branch
/sheep:it 22                   # Create PR linked to issue #22
/sheep:it --draft              # Create as draft PR
```
</usage>

<process>

<step name="check-branch">
**Verify not on main/master:**

```bash
current_branch=$(git branch --show-current)
if [ "$current_branch" = "main" ] || [ "$current_branch" = "master" ]; then
  echo "Cannot create PR from main/master branch"
  exit 1
fi
```
</step>

<step name="push">
**Push branch to remote:**

```bash
git push -u origin HEAD
```
</step>

<step name="get-issue">
**If issue number provided, get details:**

```bash
gh issue view 22 --json number,title,labels
```

Determine prefix from labels:
- `bug` → `fix:`
- `enhancement` → `feat:`
- default → `chore:`
</step>

<step name="create-pr">
**Create Pull Request:**

```bash
# With linked issue
gh pr create \
  --title "feat: Studio Working Hours (#22)" \
  --body "Closes #22"

# Draft PR
gh pr create --draft \
  --title "feat: Studio Working Hours (#22)" \
  --body "Closes #22"

# Without issue link
gh pr create \
  --title "feat: Description" \
  --body "Description of changes"
```
</step>

<step name="confirm">
**Show result:**

```
🐑 Shipped #22: Studio Working Hours

✓ Pushed branch: feature/22-studio-working-hours
✓ Created PR #45: feat: Studio Working Hours (#22)
✓ Linked to issue #22

PR: https://github.com/<owner>/<repo>/pull/45

When merged, issue #22 will auto-close! 🎉
```
</step>

</process>
