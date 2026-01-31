# /sheep:ship

Create a Pull Request for current work.

## Usage

```
/sheep:ship                    # Create PR for current branch
/sheep:ship 22                 # Create PR linked to issue #22
/sheep:ship --draft            # Create as draft PR
```

## Behavior

1. **Check branch**: Ensure not on main/master
2. **Push branch**: Push to origin if not already
3. **Create PR**: With title and body
4. **Link issue**: Add "Closes #XX" if issue specified

## Commands Used

```bash
# Push current branch
git push -u origin HEAD

# Create PR (interactive)
gh pr create

# Create PR linked to issue
gh pr create \
  --title "feat: Studio Working Hours (#22)" \
  --body "Closes #22"

# Create draft PR
gh pr create --draft

# Full example with body
gh pr create \
  --title "feat: Studio Working Hours" \
  --body "$(cat <<'EOF'
## Summary
- Implemented configurable studio hours
- Added admin UI for hour management

Closes #22
EOF
)"
```

## Output Format

```
🐑 Shipping #22: Studio Working Hours

✓ Pushed branch: feature/22-studio-working-hours
✓ Created PR #45: feat: Studio Working Hours
✓ Linked to issue #22

PR: https://github.com/user/repo/pull/45

When merged, issue #22 will auto-close!
```

## PR Title Format

If linked to issue:
- `feat: <issue title> (#<number>)` for enhancements
- `fix: <issue title> (#<number>)` for bugs

Detects from issue labels:
- `bug` label → `fix:` prefix
- `enhancement` label → `feat:` prefix
- Default → `chore:` prefix
