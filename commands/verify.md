---
name: sheep:verify
description: Verify implementation against acceptance criteria
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue edit *)
  - Bash(git diff *)
  - Bash(git log *)
  - Bash(npm run *)
  - Bash(bundle exec *)
  - Bash(pytest *)
  - Bash(go test *)
  - Bash(cat .sheeprc.yml *)
  - Read
  - Glob
  - Grep
  - AskUserQuestion
  - Task
  - Skill
---

<objective>
Verify that the implementation meets all acceptance criteria from the issue.
Run tests, check functionality, and update the issue checkboxes.
</objective>

<usage>
```
/sheep:verify 22               # Verify implementation for issue #22
/sheep:verify                  # Auto-detect from branch name
```
</usage>

<process>

<step name="detect-adapter">
**Check for adapter verification:**

Before starting manual verification, check if an adapter should handle it.

**1. Check for config file:**
```bash
cat .sheeprc.yml 2>/dev/null | grep -A5 "adapter:"
```

**2. If adapter has verify mapping:**
```yaml
adapter:
  enabled: true
  name: "openspec"
  verify: "opsx:verify"
```

**3. If adapter found and enabled:**

```
🔌 Adapter verification: OpenSpec
   → /opsx:verify {issue context}
```

**Delegate to adapter:**
```
[Skill tool]
skill: "{adapter.verify}"  # e.g., "opsx:verify"
args: "{issue number or context}"
```

OpenSpec validates:
- **Completeness**: All tasks/acceptance criteria checked off
- **Correctness**: Implementation matches specs and requirements
- **Design coherence**: Follows technical design patterns

**After adapter completes, show:**
```
🔌 OpenSpec verification complete

✓ All acceptance criteria verified
✓ Implementation matches specs
→ Continuing Sheep It workflow...

Next: /sheep:it (to create the PR and ship)

Note: Stay in Sheep It namespace - verification is done
```

**4. If no adapter or adapter disabled:**

Continue with manual Sheep It verification (get-criteria step).
</step>

<step name="get-criteria">
**Get acceptance criteria from issue:**

```bash
gh issue view 22 --json body
```

Parse checkboxes from issue body:
```
- [ ] User can enter email and password
- [ ] Invalid credentials show error message
- [ ] Successful login redirects to dashboard
- [x] Already checked items
```
</step>

<step name="verify-each">
**Verify each criterion:**

For each acceptance criterion:

1. **Find related code:**
   - Use Grep/Glob to find implementation
   - Read the relevant files

2. **Check if implemented:**
   - Does the code exist?
   - Does it match the requirement?

3. **Run relevant tests:**
   - Find test files for the feature
   - Run them to verify functionality

4. **Manual verification if needed:**
   ```
   [AskUserQuestion]
   Question: "I found the login form at app/views/login.html.erb. Does it look correct?"
   Header: "Verify"
   Options:
   - "Yes, looks good (Recommended)" - description: "Mark as verified"
   - "No, needs work" - description: "I'll fix it"
   - "Show me the code" - description: "Let me review"
   ```
</step>

<step name="run-tests">
**Run project tests:**

Detect project type and run appropriate tests:

```bash
# Node.js
npm test

# Rails
bundle exec rspec

# Python
pytest

# Go
go test ./...
```

Report results:
```
Test Results:
✅ 42 passed
⚠️  2 skipped
❌ 1 failed: test_login_validation
```

If tests fail:
```
[AskUserQuestion]
Question: "1 test failed. What would you like to do?"
Header: "Test failure"
Options:
- "Fix the failing test (Recommended)" - description: "I'll help debug"
- "Skip for now" - description: "Continue verification"
- "Show test output" - description: "See the error details"
```
</step>

<step name="update-checkboxes">
**Update issue checkboxes:**

For verified criteria, update the issue body to check them off:

```bash
# Get current body, update checkboxes, patch issue
gh issue edit 22 --body "updated body with checked boxes"
```

Show progress:
```
Updating issue #22...
✅ Checked: User can enter email and password
✅ Checked: Invalid credentials show error message
✅ Checked: Successful login redirects to dashboard
```
</step>

<step name="summary">
**Show verification summary:**

```
🐑 Verification Complete: #22 Studio Working Hours

Acceptance Criteria:
✅ User can enter email and password
✅ Invalid credentials show error message
✅ Successful login redirects to dashboard
✅ "Forgot password" link visible

Tests: 42 passed, 0 failed
Build: ✅ Success

All criteria verified! Ready to ship: /sheep:it 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```

If some criteria failed:
```
🐑 Verification: #22 Studio Working Hours

Acceptance Criteria:
✅ User can enter email and password
✅ Invalid credentials show error message
❌ Successful login redirects to dashboard (redirect goes to /home not /dashboard)
⏳ "Forgot password" link visible (not implemented)

2 criteria need attention.

[AskUserQuestion]
Question: "What would you like to do?"
Header: "Next"
Options:
- "Fix the issues (Recommended)" - description: "Continue implementation"
- "Ship anyway" - description: "Create PR with known gaps"
- "Stop here" - description: "Come back later"
```
</step>

</process>

<interaction-style>
- Be thorough but not pedantic
- Run actual tests when possible
- Update issue checkboxes automatically
- Give clear pass/fail for each criterion
- Offer to fix failures
</interaction-style>
