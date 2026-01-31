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

Try to list projects to verify project permissions:
```bash
gh project list --limit 1 2>&1
```

If you see an error like `HTTP 403: Resource not accessible` or `does not have the required scope`, the user needs to add project permissions.

**If permissions are missing, guide user:**

```
⚠️  Missing GitHub Project permissions!

Sheep It uses GitHub Projects to manage your board.
Run this command to add the required permissions:

  gh auth refresh -h github.com -s project,read:project

Then run /sheep:init again.
```

Wait for user to confirm they've added permissions before continuing.
</step>

<step name="parse-args">
**Parse arguments:**

- If project name given → create new repo
- If `--public` flag → create as public (otherwise private)
- If no args and in git repo → setup in existing repo
</step>

<step name="create-or-setup">

**First, check if repo already exists on GitHub:**

```bash
gh repo view 2>/dev/null
```

**If repo ALREADY exists on GitHub:**
- Skip repo creation entirely
- Just proceed to project board setup
- Show: "✓ Found existing repo: owner/repo-name"

**If NO repo on GitHub but git repo exists locally:**
- Ask user if they want to create it on GitHub
- If yes, create as PRIVATE by default:
```bash
gh repo create --private --source=. --push
```

**If creating brand new project (name provided):**

1. Create directory:
```bash
mkdir -p <project-name> && cd <project-name>
```

2. Initialize git:
```bash
git init
```

3. Create basic README:
```bash
echo "# <project-name>" > README.md
```

4. Initial commit:
```bash
git add . && git commit -m "Initial commit"
```

5. Create GitHub repo (PRIVATE by default):
```bash
# Private (default - safe)
gh repo create <project-name> --private --source=. --push

# Public (only if --public flag)
gh repo create <project-name> --public --source=. --push
```

If `--public` was used, show warning first:
```
⚠️  Creating PUBLIC repository - code will be visible to everyone.
```
</step>

<step name="create-board">
**Create GitHub Project board and link to repo:**

```bash
# Create project and capture the project number
gh project create --owner @me --title "<project-name>" --format json
```

Then link the repo to the project:
```bash
# Get the project number from the create output, then link
gh project link <project-number> --owner @me --repo <owner>/<repo-name>
```

Note: The project board columns (Backlog, In Progress, Review, Done) are created by default in GitHub Projects v2.
</step>

<step name="confirm">
**Show success message:**

```
🐑 Sheep It - Initialized!

✓ GitHub CLI authenticated as @<username>
✓ Created repository: <owner>/<project-name> (private)
✓ Created project board
✓ Pushed initial commit

🎉 Ready to herd!
   Repo:  https://github.com/<owner>/<project-name>
   Board: https://github.com/users/<owner>/projects/<number>

Next steps:
  /sheep:milestone "v1.0.0"    # Create your first milestone
  /sheep:task "First task"     # Create your first task
  /sheep:board                 # View your project board
```
</step>

</process>

<important>
- ALWAYS check if repo exists on GitHub FIRST before trying to create
- NEVER create a repo if one already exists - just setup the board
- ALWAYS create repos as PRIVATE unless `--public` is explicitly provided
- This protects users from accidentally exposing code
- Show a warning when creating public repos
</important>

<examples>

**Most common: Existing repo already on GitHub**
```
> /sheep:init

🐑 Sheep It - Initializing...
✓ GitHub CLI authenticated as @Xavier-IV
✓ Found existing repo: Xavier-IV/my-project
✓ Created project board

🎉 Ready to herd!
   Repo:  https://github.com/Xavier-IV/my-project
   Board: https://github.com/users/Xavier-IV/projects/5
```

**Local git repo not yet on GitHub:**
```
> /sheep:init

🐑 Sheep It - Initializing...
✓ GitHub CLI authenticated as @Xavier-IV
ℹ️  Local repo not on GitHub yet.

Create GitHub repo? (will be private)
> Yes

✓ Created repository: Xavier-IV/my-project (private)
✓ Pushed to GitHub
✓ Created project board

🎉 Ready to herd!
```

**New project from scratch:**
```
> /sheep:init "my-new-app"

🐑 Sheep It - Initializing...
✓ Created directory: my-new-app
✓ Initialized git
✓ Created repository: Xavier-IV/my-new-app (private)
✓ Created project board

🎉 Ready to herd!
```

</examples>
