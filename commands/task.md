---
name: sheep:task
description: Create a GitHub Issue
allowed-tools:
  - Bash(gh issue create *)
  - Bash(gh label list *)
  - Bash(gh api repos/:owner/:repo/milestones *)
  - AskUserQuestion
---

<objective>
Brainstorm and refine a task through interactive conversation before creating a well-structured GitHub Issue.
Use AskUserQuestion tool for all clarifications - make it feel like a collaborative session.
</objective>

<usage>
```
/sheep:task "Add user login"      # Start brainstorming with initial idea
/sheep:task                       # Start from scratch
```
</usage>

<process>

<step name="understand">
**Understand the task (use AskUserQuestion):**

Start by acknowledging the idea, then ask clarifying questions using AskUserQuestion tool.

Example flow:
```
User: /sheep:task "Add payments"

You: Got it - adding payments. Let me understand what you need.

[Use AskUserQuestion with questions like:]
- "What type of payment?" with options: One-time purchase, Subscription, Both, Other
- "Payment provider preference?" with options: Stripe (Recommended), Paddle, PayPal, Not sure yet
```

Ask 1-2 questions at a time using AskUserQuestion. Keep it conversational.

Key questions to cover (adapt based on context):
1. **What type of task?** - Feature, Bug fix, Improvement, Chore
2. **What problem does this solve?** - Free text or suggest common problems
3. **Who is this for?** - End user, Admin, Developer, etc.
4. **Scope check** - Is this small, medium, or large?
</step>

<step name="refine">
**Refine scope (use AskUserQuestion if needed):**

If the task seems big, use AskUserQuestion to confirm:

```
[AskUserQuestion]
Question: "This sounds like a bigger feature. Want to break it down?"
Options:
- "Yes, break into smaller tasks"
- "No, keep as one task"
- "Let me explain more"
```

If breaking down:
```
[AskUserQuestion]
Question: "I see these subtasks - which ones do you want?"
Options (multiSelect: true):
- "Setup Stripe integration"
- "Checkout flow UI"
- "Subscription management"
- "Webhook handling"
```
</step>

<step name="categorize">
**Categorize (use AskUserQuestion):**

Fetch available labels and milestones, then ask:

```bash
gh label list --json name --jq '.[].name'
gh api repos/:owner/:repo/milestones --jq '.[].title'
```

```
[AskUserQuestion]
Question: "What type of task is this?"
Options:
- "enhancement" (new feature)
- "bug" (something broken)
- "chore" (maintenance/cleanup)
- "documentation"
```

```
[AskUserQuestion]
Question: "Assign to a milestone?"
Options:
- "v1.0.0"
- "v1.1.0"
- "No milestone"
```
</step>

<step name="structure">
**Structure the issue:**

Based on conversation, build:

1. **Title** - Clear, actionable (verb + noun)
   - ❌ "Login stuff"
   - ✅ "Add email/password login for customers"

2. **Body** with sections:
   ```markdown
   ## Why
   [Problem this solves - from conversation]

   ## What
   [Brief description of the solution]

   ## Acceptance Criteria
   - [ ] Criterion 1
   - [ ] Criterion 2
   - [ ] Criterion 3

   ## Tasks (if complex)
   - [ ] Subtask 1
   - [ ] Subtask 2
   ```
</step>

<step name="preview">
**Preview and confirm (use AskUserQuestion):**

Show the full issue preview:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 PREVIEW

Title: Add email/password login for customers
Labels: enhancement
Milestone: v1.0.0

## Why
Customers need to access their order history.

## What
Add a login form with email/password authentication.

## Acceptance Criteria
- [ ] Login form with email and password fields
- [ ] Error message for invalid credentials
- [ ] Redirect to dashboard on success
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Then use AskUserQuestion:
```
[AskUserQuestion]
Question: "Create this issue?"
Options:
- "Yes, create it"
- "Edit something first"
- "Cancel"
```
</step>

<step name="create">
**Create the issue:**

```bash
gh issue create \
  --title "Add email/password login for customers" \
  --body "$(cat <<'EOF'
## Why
Customers need to access their order history.

## What
Add a login form with email/password authentication.

## Acceptance Criteria
- [ ] Login form with email and password fields
- [ ] Error message for invalid credentials
- [ ] Redirect to dashboard on success
EOF
)" \
  --label "enhancement" \
  --milestone "v1.0.0"
```
</step>

<step name="confirm">
**Show result:**

```
🐑 Created task #22: Add email/password login for customers
   https://github.com/owner/repo/issues/22

   Labels: enhancement
   Milestone: v1.0.0
   → Added to Backlog

🚀 Ready to start? Run: /sheep:start 22

💡 Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<interaction-style>
CRITICAL: Always use AskUserQuestion tool for choices and clarifications.

DO NOT just print questions as text. USE the AskUserQuestion tool:

```json
{
  "questions": [{
    "question": "What type of task is this?",
    "header": "Task type",
    "options": [
      {"label": "Feature", "description": "New functionality"},
      {"label": "Bug fix", "description": "Something is broken"},
      {"label": "Improvement", "description": "Enhance existing feature"},
      {"label": "Chore", "description": "Maintenance or cleanup"}
    ],
    "multiSelect": false
  }]
}
```

This creates the nice interactive UI with selectable options.

Guidelines:
- Mark recommended options with "(Recommended)" to reduce decision friction
- Put recommended option FIRST in the list
- Acknowledge each answer before asking next question
- Summarize understanding periodically
- 3-5 questions total is usually enough
- If user gives detailed initial description, skip redundant questions
- Can ask up to 4 questions in one AskUserQuestion call
- Use multiSelect: true when multiple options can apply (checkboxes, not radio buttons)
  - Good for: subtask selection, feature toggles, "select all that apply"
  - Bad for: single choices like "create/cancel", "yes/no"

Example with recommendation:
```json
{
  "questions": [{
    "question": "Which payment provider?",
    "header": "Provider",
    "options": [
      {"label": "Stripe (Recommended)", "description": "Most popular, great docs, easy setup"},
      {"label": "Paddle", "description": "Handles tax/VAT automatically"},
      {"label": "PayPal", "description": "Widely recognized"},
      {"label": "Not sure yet", "description": "We can decide later"}
    ],
    "multiSelect": false
  }]
}
```
</interaction-style>

<examples>

**Example 1: Simple bug**
```
User: /sheep:task "Login button broken"

Claude: Got it - sounds like a bug. Let me get a few details.

[AskUserQuestion]
- "What happens when you click it?" → Nothing / Error message / Wrong page / Other
- "Which browser/device?" → Chrome / Safari / Mobile / All

User selects: "Nothing" and "Mobile"

Claude: Thanks! Here's what I'm thinking:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 PREVIEW

Title: Fix: Login button unresponsive on mobile
Labels: bug

## Problem
Login button doesn't respond to taps on mobile devices.

## Acceptance Criteria
- [ ] Login button works on mobile browsers
- [ ] Tested on iOS Safari and Chrome Android
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[AskUserQuestion: "Create this issue?" → Yes / Edit / Cancel]
```

**Example 2: Big feature (needs breakdown)**
```
User: /sheep:task "Add payments"

Claude: Payments is a big topic! Let me understand what you need.

[AskUserQuestion]
- "Payment type?" → One-time / Subscription / Both
- "Provider?" → Stripe (Recommended) / Paddle / PayPal / Not sure

User: Subscription, Stripe

Claude: Got it - Stripe subscriptions. This is actually a few tasks:

[AskUserQuestion with multiSelect: true]
"Which parts do you want to tackle?"
- Setup Stripe integration
- Subscription checkout flow
- Customer portal (manage/cancel)
- Webhook handling

User selects: All of them

Claude: I'll create 4 linked issues. Let's start with the first one...
```

</examples>
