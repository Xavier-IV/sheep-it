---
name: sheep:help
description: Show all Sheep It commands
allowed-tools: []
---

<objective>
Show all available Sheep It commands and usage.
</objective>

<usage>
```
/sheep:help                    # Show all commands
```
</usage>

<process>

<step name="show-help">
**Display help:**

```
🐑 Sheep It - GitHub-native project flow

"Herd your tasks, not markdown files"

Prerequisites:
  1. Install GitHub CLI: https://cli.github.com
  2. Authenticate: gh auth login
  3. Add project permissions:
     gh auth refresh -h github.com -s project,read:project

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SETUP
  /sheep:init [name]           Create/setup project (private by default)
  /sheep:config                Configure project settings

PLANNING (Interactive brainstorming)
  /sheep:task "title"          Brainstorm → refine → create issue
  /sheep:milestone "v1.0"      Create milestone with due date

WORKING
  /sheep:start [issue]         Pick issue → implement → commit
  /sheep:resume                Continue after context reset
  /sheep:status                Quick "where am I?" check
  /sheep:verify [issue]        Verify against acceptance criteria

SHIPPING
  /sheep:it [issue]            🐑 Ship it! Create PR
  /sheep:release <version>     Create GitHub release

TRACKING
  /sheep:tasks                 List open issues
  /sheep:milestones            List milestones with progress
  /sheep:progress [milestone]  Detailed progress view
  /sheep:board                 View project board

COLLABORATION
  /sheep:review [PR]           Review a pull request

HELP
  /sheep:help                  Show this help

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TYPICAL WORKFLOW

  ┌─────────────────────────────────────────────────────┐
  │  /sheep:task "Add login"                            │
  │      ↓ Brainstorm & create detailed issue           │
  │  /sheep:start 22                                    │
  │      ↓ Branch, assign, IMPLEMENT the code           │
  │      ↓ Auto-updates issue checkboxes                │
  │  /sheep:verify 22                                   │
  │      ↓ Check all acceptance criteria met            │
  │  /sheep:it 22                                       │
  │      ↓ Create PR, link to issue                     │
  │  [PR merged → issue auto-closes]                    │
  │  /sheep:release v1.0.0                              │
  │      ↓ Tag, release, close milestone                │
  └─────────────────────────────────────────────────────┘

BOARD FLOW
  ┌──────────┐   ┌─────────────┐   ┌────────┐   ┌──────┐
  │ Backlog  │ → │ In Progress │ → │ Review │ → │ Done │
  └──────────┘   └─────────────┘   └────────┘   └──────┘
     task           start             it         merged

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

KEY FEATURES
  • Interactive questions for all decisions
  • /sheep:start WRITES CODE, not just creates branch
  • Auto-updates issue checkboxes as you complete them
  • Posts progress comments on issues
  • /sheep:resume picks up after context resets
  • All context saved in GitHub - run /clear anytime

PHILOSOPHY
  • GitHub IS the source of truth
  • Issues ARE the PRD
  • No duplicate state in markdown files
  • Ship incrementally, verify against spec

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Docs: https://github.com/Xavier-IV/sheep-it

🐑 Don't be sheepish, ship it!
```
</step>

</process>
