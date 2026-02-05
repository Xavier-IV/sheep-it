---
name: sheep:review
description: Review a pull request - check code quality and acceptance criteria
allowed-tools:
  - Bash(gh pr view *)
  - Bash(gh pr diff *)
  - Bash(gh pr checks *)
  - Bash(gh pr review *)
  - Bash(gh issue view *)
  - Bash(gh api repos/*/pulls/*/comments*)
  - Bash(gh api repos/*/pulls/*/reviews*)
  - Bash(gh api repos/*/issues/*/comments*)
  - Bash(gh run list *)
  - Bash(gh run view *)
  - Read
  - Glob
  - Grep
  - AskUserQuestion
  - Task
---

<objective>
Review a pull request. Check code quality, verify it meets acceptance criteria from the linked issue,
and provide feedback or approval.
</objective>

<usage>
```
/sheep:review 45               # Review PR #45
/sheep:review                  # Show PRs waiting for review
```
</usage>

<process>

<step name="select-pr">
**If no PR specified, show available:**

```bash
gh pr list --state open --json number,title,author,url
```

```
[AskUserQuestion]
Question: "Which PR would you like to review?"
Header: "PR"
Options:
- "PR #45: feat: Studio Working Hours (Recommended)" - description: "by @contributor"
- "PR #46: fix: Login button" - description: "by @another"
- "Cancel" - description: "Not now"
```
</step>

<step name="get-context">
**Get PR and linked issue context:**

```bash
# PR details
gh pr view 45 --json number,title,body,additions,deletions,changedFiles,commits

# PR diff
gh pr diff 45

# CI status
gh pr checks 45

# Linked issue (from PR body "Closes #22")
gh issue view 22 --json body
```

Parse:
- What the PR claims to do
- Acceptance criteria from linked issue
- Files changed
- CI status
</step>

<step name="fetch-comments">
**Fetch PR and issue comments for feedback analysis:**

```bash
# Get repository info
REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')

# PR review comments (inline code comments)
gh api "repos/${REPO}/pulls/45/comments" --jq '.[] | {user: .user.login, body: .body, created_at: .created_at, path: .path, line: .line, in_reply_to_id: .in_reply_to_id}'

# PR reviews (approval/request-changes/comment reviews)
gh api "repos/${REPO}/pulls/45/reviews" --jq '.[] | {user: .user.login, state: .state, body: .body, submitted_at: .submitted_at}'

# Linked issue comments (from "Closes #22")
gh api "repos/${REPO}/issues/22/comments" --jq '.[] | {user: .user.login, body: .body, created_at: .created_at}'
```

**Parse comments to identify actionable items:**

Look for:
- **Questions:** Comments containing `?` or phrases like "why", "how", "could you explain"
- **Change requests:** Comments with phrases like "please", "should", "must", "need to", "consider"
- **Unresolved threads:** PR comments without replies, or threads still marked unresolved
- **Review states:** `CHANGES_REQUESTED` reviews that haven't been dismissed

**Categorize feedback:**

```
Actionable Feedback Analysis:

1. CHANGES_REQUESTED reviews:
   - User, date, and summary of requested changes

2. Unanswered questions:
   - Questions from reviewers without responses

3. Unaddressed suggestions:
   - Specific change requests that may not be implemented

4. Recent discussion:
   - Any comments in the last 24-48 hours that may need attention
```
</step>

<step name="review-checklist">
**Review against checklist:**

1. **Acceptance Criteria Met?**
   - Compare PR changes against issue acceptance criteria
   - Each criterion should be addressed

2. **Code Quality:**
   - Follows project patterns/conventions
   - No obvious bugs or issues
   - Appropriate error handling
   - No security concerns

3. **Tests:**
   - Tests added for new functionality?
   - Existing tests still pass?

4. **CI Status:**
   - All checks passing?
</step>

<step name="analyze-ci-errors">
**If CI checks are failing, fetch detailed error logs:**

```bash
# Get failed workflow runs for this PR
gh pr checks 45 --json name,state,conclusion --jq '.[] | select(.conclusion == "failure")'

# List recent workflow runs for the PR branch
gh run list --branch feature/22-description --limit 5 --json databaseId,name,status,conclusion

# Get detailed logs for a failed run (replace RUN_ID with actual ID)
gh run view RUN_ID --log-failed
```

**Parse and summarize errors:**

Look for common patterns:
- **Build errors:** TypeScript/compilation failures, missing dependencies
- **Test failures:** Failed assertions, snapshot mismatches
- **Lint errors:** ESLint, Rubocop, formatting issues
- **Type errors:** TypeScript strict mode violations

**Display CI Error Summary:**

```
CI Errors Detected:

1. build (run #12345) - failed 5 min ago
   ❌ TypeScript compilation error
   src/utils/date.ts:45:12
   Property 'format' does not exist on type 'Date'

   💡 Likely fix: Import date-fns or use toLocaleDateString()

2. test (run #12346) - failed 5 min ago
   ❌ 2 tests failed

   FAIL src/components/Button.test.tsx
   Line 23: Expected "Submit" but received "Submti"

   💡 Likely fix: Typo in Button component text

3. lint (run #12347) - failed 5 min ago
   ❌ ESLint errors

   src/hooks/useData.ts:12:5
   'data' is assigned but never used (no-unused-vars)

   💡 Likely fix: Remove unused variable or use it
```

**If errors are fixable, offer to resolve:**

```
[AskUserQuestion]
Question: "CI is failing. Want me to analyze and fix these errors?"
Header: "CI Errors"
Options:
- "Yes, fix them (Recommended)" - description: "I'll fix and push to the PR"
- "Show details only" - description: "Just show me the full logs"
- "Skip CI analysis" - description: "Continue with review"
```

**If user chooses to fix:**

1. Read the affected files
2. Apply fixes based on error analysis
3. Commit with message: `fix(#issue): resolve CI errors - [description]`
4. Push to PR branch
5. Wait for CI to re-run (or continue review)

```bash
# After fixing, push to the PR branch
git push origin HEAD
```
</step>

<step name="examine-changes">
**Examine key changes:**

Read the most important changed files:

```bash
gh pr diff 45 --name-only
```

For each significant file, use Read tool to examine:
- What changed?
- Does it look correct?
- Any concerns?

```
📝 Reviewing Changes:

app/models/working_hour.rb
  ✅ Model looks good
  ✅ Validations present
  ⚠️  Line 45: Consider adding index for date column

app/controllers/hours_controller.rb
  ✅ CRUD actions implemented
  ✅ Strong params used
  ✅ Authorization checks present

spec/models/working_hour_spec.rb
  ✅ Tests cover main scenarios
  ⚠️  Missing edge case: overlapping hours
```
</step>

<step name="summary">
**Provide review summary:**

```
🐑 PR Review: #45 feat: Studio Working Hours

Linked Issue: #22

Acceptance Criteria:
✅ Working hours model - implemented in working_hour.rb
✅ Configuration UI - added views and controller
✅ Validation rules - validates presence and format
✅ API endpoint - /api/hours responds correctly

Code Quality:
✅ Follows Rails conventions
✅ No security issues found
⚠️  Suggestion: Add database index for date column

Tests:
✅ Model specs added
⚠️  Missing: Controller specs

CI: ✅ All checks passing

Unresolved Feedback:
⚠️  2 items need attention

1. @reviewer1 (2 days ago) - CHANGES_REQUESTED
   "Please add input validation for the date field"

2. @reviewer2 (1 day ago) - Question
   "Why did you choose this approach over using callbacks?"
```

**If there's unresolved feedback, highlight it:**

```
⚠️  UNRESOLVED FEEDBACK DETECTED

There are 2 unresolved items from previous reviews:
- 1 CHANGES_REQUESTED review by @reviewer1
- 1 unanswered question from @reviewer2

Consider addressing these before approving, or verify they've been
resolved in the latest commits.
```

**Decision options depend on feedback status:**

If NO unresolved feedback:
```
[AskUserQuestion]
Question: "What's your review decision?"
Header: "Decision"
Options:
- "Approve (Recommended)" - description: "LGTM, ready to merge"
- "Request changes" - description: "Needs fixes before merge"
- "Comment only" - description: "Leave feedback without blocking"
- "Need more time" - description: "I'll review more thoroughly"
```

If HAS unresolved feedback:
```
[AskUserQuestion]
Question: "There's unresolved feedback. What's your review decision?"
Header: "Decision"
Options:
- "Review feedback first (Recommended)" - description: "Check if issues were addressed"
- "Approve anyway" - description: "Feedback has been addressed in commits"
- "Request changes" - description: "Needs fixes before merge"
- "Comment only" - description: "Leave feedback without blocking"
```
</step>

<step name="submit-review">
**Submit the review:**

```bash
# Approve
gh pr review 45 --approve --body "LGTM! 🐑

Verified against acceptance criteria for #22.
All checks passing.

Minor suggestions:
- Consider adding index for date column
- Add controller specs when you have time"

# Request changes
gh pr review 45 --request-changes --body "Good progress! A few things to address:

- [ ] Add database index for date column (performance)
- [ ] Add controller specs
- [ ] Fix the edge case for overlapping hours"

# Comment
gh pr review 45 --comment --body "Looking good so far! Left some suggestions."
```
</step>

<step name="complete">
**Show result:**

```
🐑 Review Submitted: PR #45

Decision: ✅ Approved
Comment: Left suggestions for future improvements

PR: https://github.com/owner/repo/pull/45

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<interaction-style>
- Be constructive, not nitpicky
- Focus on acceptance criteria first
- Highlight security/bug concerns prominently
- Suggestions vs requirements should be clear
- Celebrate good work!
</interaction-style>
