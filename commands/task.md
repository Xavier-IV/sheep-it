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
Brainstorm and refine a task before creating a well-structured GitHub Issue.
Don't just accept the title - help the user think through what they actually need.
</objective>

<usage>
```
/sheep:task "Add user login"      # Start brainstorming with initial idea
/sheep:task                       # Start from scratch
```
</usage>

<process>

<step name="understand">
**Understand the task:**

Start with the user's initial idea and ask clarifying questions:

1. **What problem does this solve?**
   - Why is this needed?
   - What's broken or missing?

2. **Who is this for?**
   - End user? Admin? Developer?
   - What's their goal?

3. **What does success look like?**
   - How will we know it's done?
   - What can the user do after this is shipped?

Keep it conversational - 2-3 questions at a time, not an interrogation.
</step>

<step name="refine">
**Refine the scope:**

Based on answers, help clarify:

1. **Is this one task or multiple?**
   - If it's too big, suggest breaking it down
   - "This sounds like 3 separate tasks: X, Y, Z. Want to create them separately?"

2. **What's in scope vs out of scope?**
   - Help define boundaries
   - "So we're doing X but NOT Y, correct?"

3. **Any dependencies?**
   - Does this need something else first?
   - "This needs the auth system - is that already done?"
</step>

<step name="structure">
**Structure the issue:**

Build out the issue content:

1. **Title** - Clear, actionable (verb + noun)
   - ❌ "Login stuff"
   - ✅ "Add email/password login for customers"

2. **Description** - Context and user story
   ```
   ## Why
   [Problem this solves]

   ## User Story
   As a [who], I want to [what], so that [why].
   ```

3. **Acceptance Criteria** - Checkboxes for "done"
   ```
   ## Acceptance Criteria
   - [ ] User can enter email and password
   - [ ] Invalid credentials show error message
   - [ ] Successful login redirects to dashboard
   ```

4. **Subtasks** (if complex)
   ```
   ## Tasks
   - [ ] Create login form component
   - [ ] Add authentication endpoint
   - [ ] Handle session/token storage
   ```
</step>

<step name="categorize">
**Suggest categorization:**

Based on the discussion, suggest:

1. **Labels** - Show available labels and recommend
   ```bash
   gh label list
   ```
   - bug, enhancement, documentation, etc.

2. **Milestone** - If relevant
   ```bash
   gh api repos/:owner/:repo/milestones --jq '.[].title'
   ```

3. **Priority/Size** - If you have those labels
   - "This seems like a medium-sized task"
</step>

<step name="preview">
**Preview before creating:**

Show the full issue as it will appear:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 PREVIEW

Title: Add email/password login for customers
Labels: enhancement
Milestone: v1.0.0

## Why
Customers currently can't access their accounts.

## User Story
As a customer, I want to log in with my email and password,
so that I can view my order history.

## Acceptance Criteria
- [ ] User can enter email and password
- [ ] Invalid credentials show error message
- [ ] Successful login redirects to dashboard
- [ ] "Forgot password" link is visible

## Tasks
- [ ] Create login form component
- [ ] Add POST /auth/login endpoint
- [ ] Store JWT in httpOnly cookie
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Create this issue? (Yes / Edit / Cancel)
```
</step>

<step name="create">
**Create the issue:**

```bash
gh issue create \
  --title "Add email/password login for customers" \
  --body "$(cat <<'EOF'
## Why
Customers currently can't access their accounts.

## User Story
As a customer, I want to log in with my email and password,
so that I can view my order history.

## Acceptance Criteria
- [ ] User can enter email and password
- [ ] Invalid credentials show error message
- [ ] Successful login redirects to dashboard
- [ ] "Forgot password" link is visible

## Tasks
- [ ] Create login form component
- [ ] Add POST /auth/login endpoint
- [ ] Store JWT in httpOnly cookie
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

Ready to start? Run: /sheep:start 22
```
</step>

</process>

<guidelines>
- Be conversational, not robotic
- Ask 2-3 questions at a time, not a wall of questions
- If user gives short answers, that's fine - don't force detail
- Help them think, don't interrogate
- Suggest structure but let them override
- Always preview before creating
- A well-defined task saves hours of confusion later
</guidelines>

<examples>

**Quick task (user knows what they want):**
```
> /sheep:task "Fix: login button not working on mobile"

Sounds like a bug fix. Quick questions:
- What happens when they tap it? (nothing, error, wrong page?)
- Which mobile browser/device?

> Nothing happens, iOS Safari

Got it. Here's what I'm thinking:

Title: Fix: login button unresponsive on iOS Safari
Labels: bug

## Problem
Login button doesn't respond to taps on iOS Safari.

## Acceptance Criteria
- [ ] Login button works on iOS Safari
- [ ] Tested on iPhone 12+ and iPad

Create this issue?
```

**Complex feature (needs refinement):**
```
> /sheep:task "Add payments"

Payments is a big topic! Let's narrow it down:
- What are users paying for? (subscription, one-time, both?)
- What payment methods? (card, PayPal, bank transfer?)

> Just credit card for monthly subscription

Makes sense. A few more:
- Which payment provider? (Stripe, Paddle, etc.)
- Does the user need to manage their subscription? (cancel, change plan?)

> Stripe. Yes they need to cancel/change

This is actually 3-4 tasks. Want to break it down?
1. Stripe integration setup
2. Subscription checkout flow
3. Customer portal (manage/cancel)
4. Webhook handling (payment events)

> Yeah break it down

I'll create 4 linked issues. Starting with #1...
```

</examples>
