---
name: sheep:init
description: Initialize new project (private by default) or setup Sheep It in existing repo
allowed-tools:
  - Bash(gh auth status)
  - Bash(gh project list *)
  - Bash(gh project create *)
  - Bash(gh project link *)
  - Bash(gh repo view *)
  - Bash(gh repo create *)
  - Bash(git init)
  - Bash(git add *)
  - Bash(git commit *)
  - Bash(mkdir *)
  - Write
  - Read
  - AskUserQuestion
---

<objective>
Initialize a new project with Sheep It or setup Sheep It in an existing repo.
Creates GitHub repo (private by default) and GitHub Project board.
Use interactive questions for decisions.
</objective>

<usage>
```
/sheep:init                      # Setup in current repo
/sheep:init "project-name"       # Create new private repo + setup
/sheep:init "name" --public      # Create public repo (explicit)
```
</usage>

<process>

<step name="verify-gh">
**Verify GitHub CLI is installed and authenticated:**

```bash
gh auth status
```

If not authenticated, tell user to run `gh auth login` first.
</step>

<step name="verify-permissions">
**Check for required GitHub permissions:**

```bash
gh project list --limit 1 2>&1
```

If error about permissions, show:
```
⚠️  Missing GitHub Project permissions!

Sheep It uses GitHub Projects to manage your board.
Run this command to add the required permissions:

  gh auth refresh -h github.com -s project,read:project

Then run /sheep:init again.
```
</step>

<step name="detect-context">
**Detect current context:**

```bash
gh repo view 2>/dev/null
```

Three scenarios:
1. **Repo exists on GitHub** → Just setup board
2. **Local git repo, not on GitHub** → Ask to create
3. **New project name provided** → Create from scratch
</step>

<step name="scenario-existing">
**If repo already exists on GitHub:**

Show: "✓ Found existing repo: owner/repo-name"

```
[AskUserQuestion]
Question: "Set up Sheep It project board for this repo?"
Header: "Setup"
Options:
- "Yes, create board (Recommended)" - description: "Creates GitHub Project for tracking"
- "Cancel" - description: "Not now"
```
</step>

<step name="scenario-local">
**If local git repo not on GitHub:**

```
[AskUserQuestion]
Question: "This repo isn't on GitHub yet. Create it?"
Header: "Create repo"
Options:
- "Yes, private repo (Recommended)" - description: "Safe default - only you can see it"
- "Yes, public repo" - description: "Anyone can see the code"
- "Cancel" - description: "I'll do this manually"
```

If public selected, show warning:
```
⚠️  Creating PUBLIC repository - code will be visible to everyone.
```

Then create:
```bash
gh repo create --private --source=. --push
# or
gh repo create --public --source=. --push
```
</step>

<step name="scenario-new">
**If creating new project (name provided):**

```
[AskUserQuestion]
Question: "Create new project '<name>'?"
Header: "New project"
Options:
- "Yes, private repo (Recommended)" - description: "Safe default"
- "Yes, public repo" - description: "Open source"
- "Cancel" - description: "Not now"
```

Then create directory, init, and create repo.
</step>

<step name="create-board">
**Create GitHub Project board:**

```bash
gh project create --owner @me --title "<project-name>" --format json
```

Link to repo:
```bash
gh project link <project-number> --owner @me --repo <owner>/<repo-name>
```
</step>

<step name="next-steps">
**Ask about next steps:**

```
[AskUserQuestion]
Question: "What would you like to do next?"
Header: "Next"
Options:
- "Create first milestone (Recommended)" - description: "Plan your first release"
- "Create first task" - description: "Jump straight into work"
- "I'm done for now" - description: "Exit setup"
```

If milestone: route to `/sheep:milestone`
If task: route to `/sheep:task`
</step>

<step name="confirm">
**Show success message:**

```
🐑 Sheep It - Initialized!

✓ GitHub CLI authenticated as @<username>
✓ Repository: <owner>/<project-name> (private)
✓ Project board created and linked

🎉 Ready to herd!
   Repo:  https://github.com/<owner>/<project-name>
   Board: https://github.com/users/<owner>/projects/<number>
```
</step>

</process>

<interaction-style>
- Use AskUserQuestion for all decisions
- Default to private repos - it's safer
- Always confirm before creating resources
- Offer helpful next steps at the end
- Mark "(Recommended)" on sensible defaults
</interaction-style>
