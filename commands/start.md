---
name: sheep:start
description: Start working on an issue - create branch, assign, and IMPLEMENT the code
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue edit *)
  - Bash(gh issue list *)
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
</step>

<step name="understand-codebase">
**Explore codebase to understand context:**

Before implementing, explore the codebase:
- Find relevant files using Glob/Grep
- Read existing patterns and conventions
- Understand where changes need to go

Use the Task tool with Explore agent if needed for complex codebases.
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

4. **Commit as you go:**
   - Make atomic commits for each logical change
   - Use conventional commit messages (feat:, fix:, etc.)
   ```bash
   git add <files>
   git commit -m "feat(working-hours): add model and migration"
   ```

5. **Run checks after implementation:**
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

<step name="complete">
**When implementation is complete:**

```
🐑 Implemented #22: Studio Working Hours

✓ Branch: feature/22-studio-working-hours
✓ Assigned to @you
✓ All acceptance criteria met

Commits:
  • abc1234 feat(hours): add working hours model
  • def5678 feat(hours): add configuration UI
  • ghi9012 test(hours): add model specs

Ready to ship? Run: /sheep:it 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
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
