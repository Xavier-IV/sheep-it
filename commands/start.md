---
name: sheep:start
description: Start working on an issue - create branch, assign, and IMPLEMENT the code
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue edit *)
  - Bash(gh issue list *)
  - Bash(gh issue comment *)
  - Bash(git checkout *)
  - Bash(git switch *)
  - Bash(git branch *)
  - Bash(git push *)
  - Bash(git add *)
  - Bash(git commit *)
  - Bash(git fetch *)
  - Bash(git pull *)
  - Bash(git status *)
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
  - Task
  - WebSearch
  - WebFetch
---

<objective>
Start working on an issue: create branch, assign to you, then ACTUALLY IMPLEMENT the code.
This is the core command - it reads the issue spec and builds it.
</objective>

<usage>
```
/sheep:start 22                # Start and implement issue #22
/sheep:start                   # Pick from open issues, then implement
/sheep:start 22 --deep         # Deep research first, then implement
/sheep:start 22 --yolo         # Autonomous mode (if YOLO-safe)
/sheep:start 22 --yolo --force # Override YOLO safety check
/sheep:start 22 --yolo --deep  # Research first, then autonomous
```
</usage>

<process>

<step name="select-issue">
**If no issue number provided, show picker:**

```bash
gh issue list --state open --json number,title,labels --limit 10
```

```
[AskUserQuestion]
Question: "Which issue do you want to work on?"
Header: "Issue"
Options (from issue list, mark oldest/priority as Recommended):
- "#22 Studio Working Hours (Recommended)" - description: "enhancement"
- "#23 Fix login button" - description: "bug"
```
</step>

<step name="get-issue-details">
**Get full issue details - this is your spec:**

```bash
gh issue view 22 --json number,title,body,labels
```

Parse the issue body for:
- **Why** section - understand the problem
- **What** section - understand the solution
- **Acceptance Criteria** - checkboxes to satisfy
- **Tasks** - implementation subtasks

This is your implementation spec!
</step>

<step name="check-yolo" condition="--yolo flag present">
**Check YOLO safety (if --yolo flag):**

If the user ran `/sheep:start 22 --yolo`, check if the issue is marked as YOLO-safe.

**Parse YOLO metadata from issue body:**

Look for HTML comment in issue body:
- `<!-- YOLO:safe -->` → Proceed autonomously
- `<!-- YOLO:unsafe -->` → Warn and require confirmation
- No metadata → Treat as unsafe, require confirmation

```
# Check for YOLO metadata in issue body
if issue_body contains "<!-- YOLO:safe -->":
    yolo_allowed = true
elif issue_body contains "<!-- YOLO:unsafe -->":
    yolo_allowed = false
else:
    yolo_allowed = false  # No metadata = unsafe by default
```

**If YOLO not allowed (and no --force flag):**

```
⚠️  YOLO MODE BLOCKED

This issue is not marked as YOLO-safe.

Reason: [Issue marked as requiring supervision / No YOLO metadata found]

To proceed anyway, use: /sheep:start 22 --yolo --force
Or run without --yolo for interactive mode: /sheep:start 22
```

```
[AskUserQuestion]
Question: "This issue isn't YOLO-safe. What do you want to do?"
Header: "YOLO Blocked"
Options:
- "Continue interactively (Recommended)" - description: "Run without --yolo"
- "Force YOLO anyway" - description: "I accept the risks"
- "Cancel" - description: "Not now"
```

**If YOLO allowed (or --force flag):**

```
🐑 YOLO MODE ACTIVATED

This issue is marked as YOLO-safe. Running autonomously.
Progress updates will be posted to the issue.

You can check back anytime or wait for the PR!
```

**Post YOLO start comment:**

```bash
gh issue comment 22 --body "🐑 **YOLO MODE ACTIVATED**

Running autonomous implementation. Progress updates will be posted here.

- Branch: \`feature/22-issue-title\`
- Mode: Autonomous (no human prompts)
- Started: $(date)

Check back for updates or wait for the PR! 🚀"
```

**YOLO mode behavior:**
- Skip all `AskUserQuestion` prompts - make reasonable default choices
- Post progress comments at key milestones
- Continue through errors if possible (commit what works)
- Auto-create PR when complete
- Post final summary to issue
</step>

<step name="deep-research" condition="--deep flag present">
**Run deep research before implementation (if --deep flag):**

If the user ran `/sheep:start 22 --deep`, run comprehensive research using parallel agents
before proceeding to implementation.

**Spawn parallel research agents:**

Use the Task tool to launch multiple agents concurrently:

```
[Task subagent_type="Explore" description="Codebase analysis"]
prompt: |
  Research the codebase for issue #{number}: {title}

  Issue context:
  {why_section}
  {what_section}

  Find:
  1. Related files and patterns
  2. Dependencies (code this feature relies on)
  3. Impact areas (code that may be affected)
  4. Existing conventions to follow

  Return structured analysis with file paths and descriptions.
```

```
[Task subagent_type="general-purpose" description="External docs research"]
prompt: |
  Research external documentation for: {title}

  Context: {why_section} {what_section}

  Find:
  1. Relevant framework/library documentation
  2. Best practices for this type of feature
  3. Common pitfalls to avoid

  Return practical, actionable information with source URLs.
```

```
[Task subagent_type="general-purpose" description="Approach evaluation"]
prompt: |
  Evaluate implementation approaches for: {title}

  Context: {why_section} {what_section}
  Acceptance Criteria: {acceptance_criteria}

  Identify 2-3 approaches with:
  - Description, Pros, Cons
  - Recommend best approach with reasoning
```

**Post research as collapsible comment:**

```bash
gh issue comment 22 --body "$(cat <<'EOF'
## Deep Research Complete

<details>
<summary>Codebase Analysis</summary>

### Related Files
- `path/to/file.rb` - Description

### Dependencies
- `path/to/dependency.rb` - What it provides

### Impact Areas
- `path/to/impacted.rb` - Why affected

</details>

<details>
<summary>Approaches Considered</summary>

### Approach 1: [Name]
**Pros:** ...
**Cons:** ...

### Recommendation
[Selected approach] because [reasoning]

</details>

<details>
<summary>External Research</summary>

### Documentation
- [Link](url) - Description

### Best Practices
- Practice 1
- Practice 2

</details>
EOF
)"
```

**Update issue with research summary:**

Append concise summary to issue description:

```bash
gh issue edit 22 --body "[original body]

---

## Research Summary

**Recommended Approach:** [Approach]

**Key Findings:**
- Finding 1
- Finding 2

**Files to Modify:** [list]

See collapsible comments for detailed research.
"
```

Continue to implementation with research context loaded.
</step>

<step name="ensure-clean-base">
**Ensure we're starting from a clean, up-to-date base branch:**

This step prevents accidentally creating feature branches from other feature branches.

**1. Check for uncommitted changes:**

```bash
git status --porcelain
```

If there are uncommitted changes:
```
⚠️  UNCOMMITTED CHANGES DETECTED

You have uncommitted changes in your working directory.
Please commit or stash your changes before starting a new task.

Files with changes:
[list of files from git status]

To stash: git stash push -m "WIP before starting #22"
To commit: git add . && git commit -m "WIP"
```

Stop here and do NOT proceed until working directory is clean.

**2. Check current branch:**

```bash
git branch --show-current
```

**3. Determine if branch switch is needed:**

```
# Parse the issue number from the command (e.g., 22)
issue_number = [issue number being started]

# Get current branch
current_branch = [result of git branch --show-current]

# Check if current branch matches the issue (resuming work)
# IMPORTANT: Use word boundaries to prevent false positives!
# e.g., issue #2 should NOT match "feature/22-something"
#
# Match patterns like: feature/22-*, 22-*, issue-22-*, etc.
# Use regex with proper anchoring:
#   - "/(issue_number)-" matches "feature/22-desc" but NOT "feature/122-desc"
#   - "^(issue_number)-" matches "22-desc" at start
#   - "-(issue_number)-" matches "issue-22-desc" but NOT "issue-122-desc"
```

**Bash implementation for exact matching:**

```bash
issue_number=22
current_branch=$(git branch --show-current)

# Use regex with word boundaries (number must be preceded by / or - or start of string)
if [[ "$current_branch" =~ (^|/)${issue_number}- ]] || \
   [[ "$current_branch" =~ -${issue_number}- ]]; then
    branch_matches_issue=true
else
    branch_matches_issue=false
fi
```

This ensures issue `#2` only matches branches like `feature/2-desc`, `2-desc`, or `prefix-2-desc`,
but NOT `feature/22-desc` or `feature/122-desc`.

```
# Check if on main/master
if current_branch == "main" or current_branch == "master":
    on_main = true
else:
    on_main = false
```

**4. Handle branch scenarios:**

**Scenario A: Branch matches the issue (resuming work)**
```
✅ Already on branch for issue #22: feature/22-description

Resuming work on this issue.
```
Skip to the `assign` step (don't create a new branch).

**Scenario B: On main/master (correct starting point)**
```
✅ On main branch - good starting point

Fetching latest changes...
```
```bash
git fetch origin
git pull origin main  # or master
```
Continue to `create-branch` step.

**Scenario C: On a different branch (needs auto-switch)**
```
⚠️  BRANCH MISMATCH

You're on branch: feature/15-other-task
But starting task: #22

Auto-switching to main branch...
```
```bash
git fetch origin
git checkout main  # or master, whichever exists
git pull origin main
```
```
✅ Switched to main and pulled latest.

Now on: main (up to date with origin)
```
Continue to `create-branch` step.

**5. Detect main vs master:**

```bash
# Check which default branch exists
git show-ref --verify --quiet refs/heads/main && echo "main" || echo "master"
# Or check remote
git remote show origin | grep "HEAD branch" | cut -d: -f2 | tr -d ' '
```

Use whichever branch exists (main or master) for all operations.
</step>

<step name="create-branch">
**Create and checkout branch:**

Only run this step if NOT resuming work (i.e., `branch_matches_issue` is false).

```bash
git checkout -b feature/22-studio-working-hours
```
</step>

<step name="assign">
**Assign issue and mark in progress:**

```bash
gh issue edit 22 --add-assignee @me
gh issue edit 22 --add-label "in progress" 2>/dev/null || true
```

**Post progress comment:**

```bash
gh issue comment 22 --body "🐑 Started working on this issue

Branch: \`feature/22-studio-working-hours\`
Assigned to: @me

Will update acceptance criteria as I progress."
```
</step>

<step name="understand-codebase">
**Explore codebase to understand context:**

Before implementing, explore the codebase:
- Find relevant files using Glob/Grep
- Read existing patterns and conventions
- Understand where changes need to go

Use the Task tool with Explore agent if needed for complex codebases.
</step>

<step name="reanalyze-impact">
**Re-analyze dependencies and impact:**

Even if the issue has Dependencies/Impact Analysis sections, re-verify them:
- The codebase may have changed since the issue was created
- Fresh analysis ensures you catch all affected areas

**Parse existing analysis from issue body:**
Look for "## Dependencies" and "## Impact Analysis" sections in the issue.

**Verify and expand the analysis:**

```bash
# For each file mentioned in Dependencies, verify it exists and check its current state
ls -la path/to/dependency.rb

# For each file in Impact Analysis, find current usages
grep -rn "FunctionOrClassName" app/ --include="*.rb" | head -20

# Search for additional dependencies not in the original analysis
grep -rn "import\|require\|belongs_to\|has_many" path/to/main_file.rb
```

**Identify additional impacted areas:**

```bash
# Find all files that import/use the code you'll modify
grep -rn "ModuleOrClassName" . --include="*.rb" --include="*.ts" --include="*.tsx" | head -30

# Find tests for impacted areas
ls -la spec/**/*related*_spec.rb 2>/dev/null || true
ls -la __tests__/**/*Related*.test.ts 2>/dev/null || true
```

**Document your findings:**
```
Impact Analysis (re-verified):
- Files this feature depends on: [list]
- Files that may be affected: [list]
- Tests to run after implementation: [list]
```
</step>

<step name="assess-risk">
**Assess impact level and warn if high-risk:**

Based on the impact analysis, categorize the change:

**Low Impact:**
- Isolated change with no downstream dependencies
- Only affects the new feature files
- Minimal or no test coverage concerns

**Medium Impact:**
- 2-5 files may be affected
- Some existing tests cover impacted areas
- Changes are additive (not modifying existing behavior)

**High Impact:**
- 6+ files may be affected
- Core/shared code being modified
- Existing behavior is being changed
- Critical paths (auth, payments, data) involved

**For high-impact changes, show warning:**

```
⚠️  HIGH IMPACT CHANGE DETECTED

This change affects 8+ files and modifies core functionality.

Files that depend on your changes:
- app/controllers/bookings_controller.rb
- app/controllers/studios_controller.rb
- app/services/availability_service.rb
- app/views/studios/show.html.erb
- app/views/bookings/new.html.erb
- spec/models/studio_spec.rb
- spec/services/availability_service_spec.rb
- spec/features/booking_flow_spec.rb

Recommendation: Implement incrementally with frequent commits.
After implementation, verify each impacted file still works correctly.
```

```
[AskUserQuestion]
Question: "This is a high-impact change. How do you want to proceed?"
Header: "Risk"
Options:
- "Proceed carefully (Recommended)" - description: "Implement with extra verification"
- "Break into smaller tasks" - description: "Use /sheep:task to split this up"
- "Continue anyway" - description: "I understand the risks"
```
</step>

<step name="confirm-approach">
**Confirm approach with user:**

```
Based on issue #22: Studio Working Hours

I'll need to:
1. [First implementation step]
2. [Second implementation step]
3. [Third implementation step]

Files I'll modify:
- path/to/file1.rb
- path/to/file2.rb

New files I'll create:
- path/to/new_file.rb
```

```
[AskUserQuestion]
Question: "Does this approach look right?"
Header: "Approach"
Options:
- "Yes, start coding (Recommended)" - description: "Begin implementation"
- "Let me clarify something" - description: "I'll explain more"
- "Cancel" - description: "Not now"
```
</step>

<step name="implement">
**IMPLEMENT THE CODE:**

This is the core work. Based on the issue spec:

1. **Work through each acceptance criterion:**
   - Read the checkbox items from the issue
   - Implement each one
   - Test as you go

2. **Work through each subtask:**
   - Follow the Tasks checklist from the issue
   - Implement in order (respecting dependencies)

3. **Follow project conventions:**
   - Use existing patterns in the codebase
   - Match coding style
   - Use framework generators if available (per CLAUDE.md)

4. **Make ATOMIC commits - commit early, commit often:**

   CRITICAL: Each commit should be as small as possible while remaining coherent.
   Think "one change, one commit" not "one feature, one commit".

   **The Golden Rule: If you can describe what you did with "and", it's too big.**

   **Commit message format:**
   ```
   type(#issue): short description

   Detailed explanation of what changed and why.

   Acceptance-Criteria: [criterion being addressed]
   ```

   **Commit types:**
   - `feat` - New feature or functionality
   - `fix` - Bug fix
   - `refactor` - Code change that neither fixes a bug nor adds a feature
   - `test` - Adding or updating tests
   - `docs` - Documentation changes
   - `chore` - Maintenance tasks

   **ATOMIC COMMIT RULES:**

   ✅ **DO - Commit separately:**
   - Each new file (unless generated together like model+migration)
   - Each function/method added
   - Each bug fix (even one-liners)
   - Each refactor
   - Model changes separate from controller changes
   - Controller changes separate from view changes
   - Tests separate from implementation
   - Config changes separate from code changes

   ❌ **DON'T - Never bundle these:**
   - Feature code + refactoring in same commit
   - Multiple unrelated files
   - Implementation + tests (unless TDD where test comes first)
   - Bug fix + feature addition
   - Multiple acceptance criteria in one commit

   **PRE-COMMIT CHECKLIST - Ask yourself:**
   1. Can I describe this commit WITHOUT using "and"?
   2. Does this commit do exactly ONE thing?
   3. If I reverted this, would only ONE change be undone?
   4. Are all files in this commit directly related?

   If any answer is "no", split the commit.

   **GOOD Example - Truly atomic commits:**

   ```bash
   # Commit 1: Just the migration
   git add db/migrate/xxx_create_working_hours.rb
   git commit -m "$(cat <<'EOF'
   feat(#22): add working_hours migration

   Creates working_hours table with day_of_week, opens_at, closes_at.

   Acceptance-Criteria: Database schema for working hours
   EOF
   )"
   ```

   ```bash
   # Commit 2: Just the model
   git add app/models/working_hour.rb
   git commit -m "$(cat <<'EOF'
   feat(#22): add WorkingHour model

   Adds model with validations and studio association.

   Acceptance-Criteria: Working hours model exists
   EOF
   )"
   ```

   ```bash
   # Commit 3: Just the controller
   git add app/controllers/working_hours_controller.rb
   git commit -m "$(cat <<'EOF'
   feat(#22): add WorkingHoursController

   Adds index and update actions for managing hours.

   Acceptance-Criteria: API endpoints for working hours
   EOF
   )"
   ```

   ```bash
   # Commit 4: Just one view file
   git add app/views/working_hours/index.html.erb
   git commit -m "$(cat <<'EOF'
   feat(#22): add working hours index view

   Lists all working hours for a studio.

   Acceptance-Criteria: Configuration UI displays hours
   EOF
   )"
   ```

   **BAD Example - What NOT to do:**

   ```bash
   # ❌ TOO BIG - bundles model, controller, views, and tests
   git add app/models/working_hour.rb \
           app/controllers/working_hours_controller.rb \
           app/views/working_hours/ \
           spec/models/working_hour_spec.rb
   git commit -m "feat(#22): add working hours feature"
   # This commit does 4+ things!
   ```

   ```bash
   # ❌ MIXED CONCERNS - feature + refactor
   git add app/models/studio.rb app/models/working_hour.rb
   git commit -m "feat(#22): add WorkingHour and refactor Studio"
   # Split into: 1) refactor commit, 2) feature commit
   ```

   **When to commit:**
   - After creating/modifying ANY file
   - After each function/method
   - After each config change
   - After any refactoring (even small)
   - BEFORE switching to a different file or concern

   **Commit frequency target:** Aim for 5-15+ commits per feature, not 1-3.

5. **Update issue checkboxes as you complete criteria:**
   - When an acceptance criterion is done, update the issue body
   - Change `- [ ]` to `- [x]` for completed items
   ```bash
   # Get current body, update checkbox, patch issue
   gh issue edit 22 --body "updated body with checked item"
   ```

   This keeps the issue as live documentation of progress!

6. **Run checks after implementation:**
   - Build the project
   - Run type checks
   - Run tests
   - Run security checks (e.g., brakeman for Rails)

7. **Post progress comments (YOLO mode):**

   In YOLO mode, post progress updates to the issue at key milestones:

   ```bash
   gh issue comment 22 --body "🐑 **Progress Update**

   ✅ Completed: [Acceptance criterion or subtask]

   Next up: [What's being worked on next]

   Commits so far:
   - abc1234 feat(#22): description
   - def5678 feat(#22): description"
   ```

   Post updates after:
   - Each acceptance criterion completed
   - Each major subtask completed
   - Any errors or blockers encountered

   This keeps the issue as a live log of autonomous progress.
</step>

<step name="verify">
**Verify acceptance criteria:**

Go through each acceptance criterion from the issue:

```
Acceptance Criteria Check:
✅ User can enter email and password
✅ Invalid credentials show error message
✅ Successful login redirects to dashboard
⏳ "Forgot password" link is visible (not yet done)
```

If any are incomplete:
```
[AskUserQuestion]
Question: "Some acceptance criteria aren't done yet. What do you want to do?"
Header: "Incomplete"
Options:
- "Continue implementing (Recommended)" - description: "Finish the remaining items"
- "Ship what's done" - description: "Create PR with partial work"
- "Stop here" - description: "I'll continue later"
```
</step>

<step name="verify-impact">
**Verify impacted areas still work:**

Based on the Impact Analysis from earlier, verify each affected area:

```
Impact Verification:
```

**For each impacted file, perform appropriate checks:**

```bash
# Run specific tests for impacted areas
bundle exec rspec spec/models/impacted_model_spec.rb
npm test -- --testPathPattern="impacted"

# For Rails: check routes still work
bundle exec rails routes | grep "impacted_resource"

# For Next.js: verify pages build
npm run build

# For any project: run linter/type checks
bundle exec rubocop app/controllers/impacted_controller.rb
npx tsc --noEmit
```

**Check for breaking changes:**
```bash
# Verify imports/exports still valid
grep -rn "import.*ModifiedExport" src/ --include="*.ts" --include="*.tsx"

# Check for undefined/nil errors in logs (if dev server available)
# Look for TypeScript errors on modified interfaces
```

**Display verification results:**
```
Impact Verification Results:
✅ app/controllers/bookings_controller.rb - still works (tests pass)
✅ app/services/availability_service.rb - no breaking changes
⚠️  app/views/studios/show.html.erb - may need visual review
✅ spec/models/studio_spec.rb - all 12 tests pass
```

**If issues found in impacted areas:**
```
[AskUserQuestion]
Question: "Found issues in impacted areas. What do you want to do?"
Header: "Impact Issues"
Options:
- "Fix them now (Recommended)" - description: "Address the breaking changes"
- "Create follow-up issue" - description: "Track as separate task"
- "Proceed anyway" - description: "I'll handle it later"
```
</step>

<step name="complete">
**When implementation is complete:**

```
🐑 Implemented #22: Studio Working Hours

✓ Branch: feature/22-studio-working-hours
✓ Assigned to @you
✓ All acceptance criteria met
✓ Impact areas verified

Atomic commits (traceable to issue):
  • abc1234 feat(#22): add working hours model
  • def5678 feat(#22): add configuration UI
  • ghi9012 test(#22): add model specs

Impact verification:
  • 4 dependent files checked
  • 3 impacted areas verified
  • All tests passing

Ready to ship? Run: /sheep:it 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
💡 Each commit references #22, making history fully traceable.
```

**In YOLO mode, auto-create PR:**

```bash
# Push branch
git push -u origin HEAD

# Create PR
gh pr create \
  --title "feat: [Issue title] (#22)" \
  --body "Closes #22

## Summary
[Auto-generated summary of changes]

## Commits
[List of commits]

---
🐑 This PR was created autonomously in YOLO mode.
Please review the changes before merging."
```

**Post completion comment to issue:**

```bash
gh issue comment 22 --body "🐑 **YOLO MODE COMPLETE**

✅ All acceptance criteria implemented
✅ PR created: #45

**Summary:**
- X commits made
- Y files changed
- All checks passing

**PR:** https://github.com/owner/repo/pull/45

Please review the PR and merge when ready! 🎉"
```
</step>

</process>

<implementation-guidelines>
IMPORTANT: This command WRITES CODE, not just creates branches!

1. **Read the issue carefully** - it's your spec
2. **Explore before coding** - understand the codebase first
3. **Confirm approach** - make sure you're on the right track
4. **Implement incrementally** - commit as you go
5. **Verify against spec** - check all acceptance criteria
6. **Run project checks** - build, test, lint, security

The issue body IS the PRD. Work through it systematically.

If the issue is vague:
- Ask clarifying questions via AskUserQuestion
- Or suggest improvements to the issue spec

If the issue is too big:
- Suggest breaking it down with /sheep:task
- Or implement in phases, committing incrementally
</implementation-guidelines>

<interaction-style>
**Normal mode:**
- Confirm approach before writing code
- Show progress as you implement
- Commit incrementally with good messages
- Verify acceptance criteria at the end
- Use AskUserQuestion for any decisions

**YOLO mode (--yolo flag):**
- Check YOLO metadata in issue first
- Skip all AskUserQuestion prompts
- Make reasonable default choices autonomously
- Post progress comments to issue instead of asking
- Auto-create PR when complete
- Post final summary to issue
</interaction-style>
