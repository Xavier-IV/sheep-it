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
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
  - Task
---

<objective>
Start working on an issue: create branch, assign to you, then ACTUALLY IMPLEMENT the code.
This is the core command - it reads the issue spec and builds it.
</objective>

<usage>
```
/sheep:start 22                # Start and implement issue #22
/sheep:start                   # Pick from open issues, then implement
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

<step name="create-branch">
**Create and checkout branch:**

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

4. **Make atomic commits after each logical change:**

   IMPORTANT: Create commits frequently, after each meaningful unit of work.
   Each commit should represent a single logical change that could be understood
   and potentially reverted independently.

   **Commit message format:**
   ```
   type(#issue): short description

   Detailed explanation of what changed and why.
   Reference specific files or functions if helpful.

   Acceptance-Criteria: [criterion being addressed]
   ```

   **Commit types:**
   - `feat` - New feature or functionality
   - `fix` - Bug fix
   - `refactor` - Code change that neither fixes a bug nor adds a feature
   - `test` - Adding or updating tests
   - `docs` - Documentation changes
   - `chore` - Maintenance tasks

   **Example commits:**
   ```bash
   git add app/models/working_hour.rb db/migrate/xxx_create_working_hours.rb
   git commit -m "$(cat <<'EOF'
   feat(#22): add WorkingHour model and migration

   Created the core model for storing studio working hours.
   - Added day_of_week, opens_at, closes_at columns
   - Added belongs_to :studio association
   - Added uniqueness validation for day per studio

   Acceptance-Criteria: Working hours model exists
   EOF
   )"
   ```

   ```bash
   git add app/controllers/hours_controller.rb app/views/hours/
   git commit -m "$(cat <<'EOF'
   feat(#22): add working hours configuration UI

   Built the interface for configuring studio hours.
   - Added HoursController with index/update actions
   - Created form for editing hours per day
   - Added validation error display

   Acceptance-Criteria: Configuration UI allows editing hours
   EOF
   )"
   ```

   **When to commit:**
   - After creating a new file/function
   - After completing a subtask
   - After fixing an edge case
   - After adding tests for a feature
   - Before switching to a different area of the codebase

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
- Confirm approach before writing code
- Show progress as you implement
- Commit incrementally with good messages
- Verify acceptance criteria at the end
- Use AskUserQuestion for any decisions
</interaction-style>
