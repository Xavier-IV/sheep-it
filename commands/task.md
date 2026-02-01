---
name: sheep:task
description: Create a GitHub Issue
allowed-tools:
  - Bash(gh issue create *)
  - Bash(gh issue list *)
  - Bash(gh label list *)
  - Bash(gh api repos/:owner/:repo/milestones *)
  - Bash(gh search issues *)
  - Glob
  - Grep
  - Read
  - AskUserQuestion
  - Task
  - WebSearch
  - WebFetch
---

<objective>
Brainstorm and refine a task through interactive conversation before creating a well-structured GitHub Issue.
Use AskUserQuestion tool for all clarifications - make it feel like a collaborative session.
</objective>

<usage>
```
/sheep:task "Add user login"      # Start brainstorming with initial idea
/sheep:task                       # Start from scratch
/sheep:task "Add payments" --deep # Deep research before creating issue
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

<step name="deep-research" condition="--deep flag present">
**Run deep research before creating issue (if --deep flag):**

If the user ran `/sheep:task "feature" --deep`, spawn parallel research agents to gather
comprehensive information BEFORE creating the issue. This creates a much better spec.

**Spawn parallel research agents:**

Use the Task tool to launch multiple agents concurrently:

```
[Task subagent_type="Explore" description="Codebase analysis for task"]
prompt: |
  Research the codebase for a new feature: {task_title}

  User's description: {user_description}

  Find:
  1. Related files and existing patterns
  2. Dependencies (code this feature will rely on)
  3. Impact areas (code that may be affected)
  4. Similar implementations to reference
  5. Conventions to follow

  Return structured analysis with file paths and descriptions.
```

```
[Task subagent_type="general-purpose" description="External docs research"]
prompt: |
  Research external documentation for: {task_title}

  Context: {user_description}

  Find:
  1. Relevant framework/library documentation
  2. Best practices for this type of feature
  3. Common pitfalls to avoid
  4. Security considerations

  Return practical information with source URLs.
```

```
[Task subagent_type="general-purpose" description="Approach evaluation"]
prompt: |
  Evaluate implementation approaches for: {task_title}

  Context: {user_description}

  Identify 2-3 approaches with:
  - Description, Pros, Cons
  - Effort estimate (Low/Medium/High)
  - Recommend best approach with reasoning
```

**Synthesize research into issue content:**

The research findings will be used to create a more detailed issue:
- Dependencies section from codebase analysis
- Impact Analysis from codebase analysis
- Recommended Approach section from approach evaluation
- Best Practices/Pitfalls in description from external research
- More informed Acceptance Criteria

**Show research summary to user:**

```
Deep Research Complete

📁 Codebase Analysis:
  • Found 5 related files
  • 3 dependencies identified
  • 2 potential impact areas

⚖️ Approaches Evaluated:
  • Approach A: [name] - Recommended
  • Approach B: [name] - Alternative

🌐 External Research:
  • Found relevant documentation
  • 3 best practices identified
  • 2 pitfalls to avoid

This research will be included in the issue for better context.
```

Continue to structure step with enriched content.
</step>

<step name="analyze-impact">
**Analyze codebase for dependencies and impact:**

Once you understand the task scope, explore the codebase to identify:
1. **Dependencies** - What existing code this feature will rely on
2. **Impact** - What existing code might be affected by these changes (domino effect)

**Use Glob to find related files by naming patterns:**
```
[Glob pattern="app/models/*related*.rb"]
[Glob pattern="src/components/*Related*"]
[Glob pattern="**/*FeatureName*"]
```

**Use Grep to search for code patterns:**

For Rails projects:
```
[Grep pattern="belongs_to|has_many|has_one" path="app/models/"]
[Grep pattern="ClassName" path="app/"]
[Grep pattern="def.*action_name|@variable_name" path="app/controllers/"]
```

For Next.js/React projects:
```
[Grep pattern="import.*ComponentName" glob="*.tsx"]
[Grep pattern="fetch.*api/route|useQuery|useMutation" glob="*.tsx"]
[Grep pattern="useHookName|utilityFunction" path="src/"]
```

For generic codebases:
```
[Grep pattern="import|require.*related_term"]
[Grep pattern="functionName|ClassName"]
```

**Use Read to examine key files:**
```
[Read file_path="path/to/relevant/file.rb"]
```

**Document findings for the issue body:**
- List files that will be dependencies (code this feature relies on)
- List files that may be impacted (code that depends on what you'll change)
- Note any tests that cover impacted areas

This analysis will be included in the issue body to help AI implementation understand context and verify impacted areas.
</step>

<step name="find-related">
**Look for related context:**

Search for similar or related issues/PRs:
```bash
gh search issues "login" --repo :owner/:repo --limit 5
gh issue list --label "auth" --state all --limit 5
```

If related issues found:
```
I found some related issues:
  • #15 Add OAuth login (closed) - might have useful patterns
  • #18 Password reset (open) - related feature

[AskUserQuestion]
Question: "Want to link or reference these?"
Header: "Related"
Options:
- "Reference #15 in description" - description: "Add 'Related to #15'"
- "No references needed (Recommended)" - description: "Standalone issue"
```

This helps build context and avoid duplicate work.
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

   ## Dependencies
   > This feature relies on:
   - `path/to/file.rb` - Brief description of dependency
   - `path/to/service.rb` - What it provides

   ## Impact Analysis
   > Changes here may affect:
   - `path/to/controller.rb` - Uses the modified code
   - `path/to/view.erb` - Displays related data
   - `spec/path/to/spec.rb` - Existing tests to verify

   ## Acceptance Criteria
   - [ ] Criterion 1
   - [ ] Criterion 2
   - [ ] Criterion 3

   ## Tasks (if complex)
   - [ ] Subtask 1
   - [ ] Subtask 2
   ```

   **Additional sections when --deep flag used:**
   ```markdown
   ## Recommended Approach
   **[Approach Name]** - [Brief description]

   Why this approach:
   - Reason 1
   - Reason 2

   <details>
   <summary>Alternative approaches considered</summary>

   ### Approach B: [Name]
   **Pros:** ...
   **Cons:** ...

   ### Approach C: [Name]
   **Pros:** ...
   **Cons:** ...

   </details>

   ## Research Notes
   <details>
   <summary>Best practices & pitfalls</summary>

   **Best Practices:**
   - Practice 1
   - Practice 2

   **Pitfalls to Avoid:**
   - Pitfall 1
   - Pitfall 2

   **References:**
   - [Doc 1](url)
   - [Doc 2](url)

   </details>
   ```

**Note:** The Dependencies and Impact Analysis sections come from the `analyze-impact` step (or `deep-research` step if --deep was used).
If no significant dependencies or impacts were found, these sections can be omitted or marked as "None identified".
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

## Dependencies
> This feature relies on:
- `app/models/user.rb` - User model for authentication
- `app/services/auth_service.rb` - Authentication logic

## Impact Analysis
> Changes here may affect:
- `app/controllers/sessions_controller.rb` - Login flow
- `app/views/layouts/application.html.erb` - Nav login link
- `spec/features/login_spec.rb` - Existing login tests

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

## Dependencies
> This feature relies on:
- `app/models/user.rb` - User model for authentication
- `app/services/auth_service.rb` - Authentication logic

## Impact Analysis
> Changes here may affect:
- `app/controllers/sessions_controller.rb` - Login flow
- `app/views/layouts/application.html.erb` - Nav login link
- `spec/features/login_spec.rb` - Existing login tests

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
💡 Used --deep? Your research is saved in the issue body!
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

**Example 3: Deep research mode**
```
User: /sheep:task "Add user authentication" --deep

Claude: Got it - adding authentication with deep research. Let me gather comprehensive information first.

[Spawns parallel research agents...]

Deep Research Complete

📁 Codebase Analysis:
  • Found User model at app/models/user.rb
  • Session handling in app/controllers/application_controller.rb
  • No existing auth gem detected

⚖️ Approaches Evaluated:
  • Devise gem - Recommended (battle-tested, full-featured)
  • Roll your own - More control, more work
  • Auth0/external - Good for enterprise, adds dependency

🌐 External Research:
  • Rails security guide recommends bcrypt
  • OWASP: rate limiting, secure sessions
  • Pitfall: Don't store passwords in plain text

Now let me structure the issue with this research...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 PREVIEW

Title: Add user authentication with Devise
Labels: enhancement

## Why
Users need to securely log in to access personalized features.

## What
Implement authentication using Devise gem with email/password.

## Dependencies
> This feature relies on:
- `app/models/user.rb` - User model (needs email, password fields)
- `app/controllers/application_controller.rb` - Will add auth helpers

## Impact Analysis
> Changes here may affect:
- `config/routes.rb` - Devise routes
- `app/views/layouts/application.html.erb` - Login/logout links

## Recommended Approach
**Devise gem** - Battle-tested Rails authentication

Why this approach:
- Widely used, well-documented
- Handles security best practices
- Easy to extend (confirmable, lockable, etc.)

<details>
<summary>Alternative approaches considered</summary>

### Roll your own
**Pros:** Full control, no dependencies
**Cons:** Security risks, more code to maintain

### Auth0
**Pros:** Enterprise features, SSO
**Cons:** External dependency, cost at scale

</details>

## Acceptance Criteria
- [ ] Users can register with email/password
- [ ] Users can log in and log out
- [ ] Protected routes require authentication
- [ ] Password reset flow works
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[AskUserQuestion: "Create this issue?" → Yes / Edit / Cancel]
```

</examples>
