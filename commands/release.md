# /sheep:release

Create a GitHub Release for a milestone.

## Usage

```
/sheep:release v1.4.0                    # Release milestone v1.4.0
/sheep:release v1.4.0 --draft            # Create as draft
/sheep:release v1.4.0 --title "Custom"   # Custom release title
```

## Behavior

1. **Verify milestone**: Check all issues are closed
2. **Generate changelog**: From closed issues/PRs
3. **Create tag**: If not exists
4. **Create release**: With auto-generated notes
5. **Close milestone**: Mark as closed

## Commands Used

```bash
# Check milestone is complete
gh api repos/:owner/:repo/milestones \
  --jq '.[] | select(.title == "v1.4.0") | .open_issues'

# Create tag
git tag v1.4.0
git push origin v1.4.0

# Get closed issues for changelog
gh issue list --milestone "v1.4.0" --state closed \
  --json number,title

# Create release with auto-generated notes
gh release create v1.4.0 \
  --title "v1.4.0 - Studio Improvements" \
  --generate-notes

# Or with custom notes
gh release create v1.4.0 \
  --title "v1.4.0 - Studio Improvements" \
  --notes "$(cat <<'EOF'
## What's New

- #22 Studio Working Hours
- #23 Attendance Tracking
- #25 Live Duration Tracking

**Full Changelog**: https://github.com/user/repo/compare/v1.3.0...v1.4.0
EOF
)"

# Close milestone
gh api repos/:owner/:repo/milestones/1 -X PATCH -f state="closed"
```

## Output Format

```
🐑 Releasing v1.4.0 - Studio improvements

Included tasks:
✅ #22 Studio Working Hours
✅ #23 Attendance Tracking
✅ #25 Live Duration Tracking

✓ Created tag: v1.4.0
✓ Created release: v1.4.0 - Studio improvements
✓ Closed milestone

🚀 Released! https://github.com/user/repo/releases/tag/v1.4.0
```

## Pre-release Check

If milestone has open issues:
```
🐑 Cannot release v1.4.0

⚠️  2 tasks still open:
   ⏳ #27 Final testing
   ⏳ #28 Documentation

Complete these tasks first, or use --force to release anyway.
```
