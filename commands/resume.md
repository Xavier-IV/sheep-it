---
name: sheep:resume
description: Resume interrupted work - pick up where you left off
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue list *)
  - Bash(git status)
  - Bash(git branch *)
  - Bash(git log *)
  - Bash(git diff *)
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
  - Task
---

<objective>
Resume work after a context reset or break. Reads the current state from git and GitHub,
reconstructs context, and continues implementation.
</objective>

<usage>
```
/sheep:resume                  # Auto-detect current work
/sheep:resume 22               # Resume specific issue #22
```
</usage>

<process>

<step name="detect-state">
**Detect current state:**

```bash
# What branch are we on?
git branch --show-current

# Any uncommitted changes?
git status --porcelain

# Recent commits on this branch (with full message to see issue references)
git log origin/main..HEAD --oneline 2>/dev/null || git log -5 --oneline

# Extract issue number from branch name (e.g., feature/22-something)
# Or from recent commit messages (e.g., feat(#22): ...)
```

**Parse commits for issue context:**
```bash
# Get commits with their full messages to understand progress
git log origin/main..HEAD --format="%h %s%n%b---" 2>/dev/null
```

Look for:
- Issue references in commit subjects: `feat(#22):`, `fix(#22):`
- Acceptance-Criteria footers showing what's been completed
- The chronological progression of work

If on main/master with no feature branch:
```
[AskUserQuestion]
Question: "No work in progress detected. What would you like to do?"
Header: "No WIP"
Options:
- "Start a new task (Recommended)" - description: "Pick an issue to work on"
- "I was working on something" - description: "Let me specify the issue"
```
</step>

<step name="get-issue-context">
**Get full issue context:**

```bash
gh issue view <number> --json number,title,body,labels,comments
```

Parse:
- Title and description
- Acceptance criteria (checkboxes)
- Tasks/subtasks
- Research Summary (if present from /sheep:research or --deep)
- Any comments (might have progress notes or collapsible research findings)
</step>

<step name="analyze-progress">
**Analyze what's been done from atomic commits:**

1. **Parse commit messages for progress markers:**
   ```bash
   # Get all commits with their Acceptance-Criteria footers
   git log origin/main..HEAD --format="%h %s" 2>/dev/null

   # Get full commit bodies to find Acceptance-Criteria lines
   git log origin/main..HEAD --format="%b" 2>/dev/null | grep "Acceptance-Criteria:"
   ```

2. **Map commits to acceptance criteria:**
   - Each commit with `Acceptance-Criteria:` footer indicates completed work
   - Commits are checkpoints you can resume from

3. **Check uncommitted changes** - work in progress?

4. **Cross-reference with issue checkboxes:**
   - Compare commit Acceptance-Criteria footers with issue checklist
   - Identify what's done vs remaining

```
🐑 Resuming #22: Studio Working Hours

Branch: feature/22-studio-working-hours

Atomic commits (with acceptance criteria mapping):
  • abc1234 feat(#22): add working hours model
    └─ Acceptance-Criteria: Working hours model exists ✅
  • def5678 feat(#22): add configuration UI
    └─ Acceptance-Criteria: Configuration UI allows editing hours ✅

Last checkpoint: def5678 (configuration UI)

Uncommitted changes:
  M app/models/working_hour.rb
  A app/views/hours/index.html.erb

Remaining Acceptance Criteria (from issue):
  ⏳ Validation rules
  ⏳ API endpoint
  ⏳ Tests
```

**Resume strategy:**
- If uncommitted changes exist → continue that work
- If clean state → start next unchecked acceptance criterion
- Each atomic commit is a safe checkpoint to resume from
- If research comments exist → use them for context (expand <details> sections)
</step>

<step name="confirm-continue">
**Confirm where to continue:**

Based on the last atomic commit checkpoint, present options:

```
[AskUserQuestion]
Question: "Where would you like to continue?"
Header: "Resume"
Options:
- "Continue from last checkpoint (Recommended)" - description: "Resume from commit def5678"
- "Continue uncommitted work" - description: "Pick up in-progress changes"
- "Start next acceptance criterion" - description: "Move to API endpoint"
- "Show me the full issue" - description: "Let me review the spec"
```

Note: "Start fresh" is intentionally not an option here.
If user needs to restart, they should use `/sheep:start` instead.
The atomic commits preserve meaningful checkpoints that shouldn't be discarded lightly.
</step>

<step name="continue-implementation">
**Continue implementation from checkpoint:**

Same atomic commit workflow as `/sheep:start`:

1. **Understand context from last commit:**
   - Read the last commit's Acceptance-Criteria footer
   - This tells you exactly where work stopped

2. **Work through remaining acceptance criteria:**
   - Start from the first unchecked criterion
   - Implement each one fully

3. **Make atomic commits after each logical change:**
   - Follow the same format: `type(#issue): subject`
   - Include Acceptance-Criteria footer
   - Each commit is a checkpoint for future resumes

4. **Run checks** after implementation

Reference the issue body as the spec.

**Example continuation:**
```
Last commit was: feat(#22): add configuration UI
  └─ Acceptance-Criteria: Configuration UI allows editing hours

Next up: Validation rules

[Implements validation...]

git commit -m "$(cat <<'EOF'
feat(#22): add validation rules for working hours

Added validations to WorkingHour model:
- opens_at must be before closes_at
- hours cannot overlap for same day
- Required fields validation

Acceptance-Criteria: Validation rules prevent invalid data
EOF
)"
```
</step>

<step name="complete">
**When done:**

```
🐑 Completed #22: Studio Working Hours

Atomic commits (full history):
  • abc1234 feat(#22): add working hours model
  • def5678 feat(#22): add configuration UI
  • ghi9012 feat(#22): add validation rules       ← resumed here
  • jkl3456 feat(#22): add API endpoint
  • mno7890 test(#22): add model and API specs

Acceptance Criteria (mapped to commits):
✅ Working hours model exists (abc1234)
✅ Configuration UI (def5678)
✅ Validation rules (ghi9012)
✅ API endpoint (jkl3456)
✅ Tests (mno7890)

All criteria met! Ready to ship: /sheep:it 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
💡 Each commit is traceable to #22 and its acceptance criteria.
```
</step>

</process>

<interaction-style>
- Auto-detect as much as possible from git state
- Show clear progress summary
- Let user choose where to continue
- Reference the issue as the source of truth
</interaction-style>
