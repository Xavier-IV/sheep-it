# /sheep:init

Initialize a new project with Sheep It or setup Sheep It in an existing repo.

## Usage

```
/sheep:init                      # Setup in current repo
/sheep:init "project-name"       # Create new private repo + setup
/sheep:init "name" --public      # Create as public repo (explicit)
```

**Note:** Repos are **private by default** to avoid accidental exposure. Use `--public` explicitly for open source projects.

## Behavior

### When in an existing git repo (no project name given):

1. **Verify GitHub CLI**: Run `gh auth status` to ensure authenticated
2. **Check if repo exists on GitHub**: Run `gh repo view`
3. **If not on GitHub**: Offer to create it (private by default)
4. **Create Project board**: Setup GitHub Project with columns
5. **Setup complete**: Confirm Sheep It is ready

### When creating a new project (project name given):

1. **Verify GitHub CLI**: Run `gh auth status`
2. **Create directory**: `mkdir -p <project-name> && cd <project-name>`
3. **Initialize git**: `git init`
4. **Create README**: Basic README.md with project name
5. **Initial commit**: `git add . && git commit -m "Initial commit"`
6. **Create GitHub repo**:
   - Default: `gh repo create <project-name> --private --source=. --push`
   - Public: `gh repo create <project-name> --public --source=. --push`
7. **Create Project board**: Setup GitHub Project with Kanban columns
8. **Confirm success**: Show repo URL and board URL

## GitHub Project Board Setup

Creates a GitHub Project (v2) with these columns:

```
┌────────────┬──────────────┬────────────┬──────────┐
│  Backlog   │ In Progress  │   Review   │   Done   │
└────────────┴──────────────┴────────────┴──────────┘
```

Commands Used:
```bash
# Create project
gh project create --owner @me --title "project-name"

# The project board will be linked to the repo
# Issues added via /sheep:task auto-appear in Backlog
```

## Output Format

```
🐑 Sheep It - Initializing...

✓ GitHub CLI authenticated as @username
✓ Created repository: username/project-name (private)
✓ Pushed initial commit
✓ Created project board: "project-name"

🎉 Ready to herd!
   Repo:  https://github.com/username/project-name
   Board: https://github.com/users/username/projects/1

Next steps:
  /sheep:milestone "v1.0.0"    # Create your first milestone
  /sheep:task "First task"     # Create your first task
  /sheep:board                 # View your project board
```

## Error Handling

- If `gh` not installed: Show install instructions
- If not authenticated: Run `gh auth login`
- If repo name taken: Suggest alternative or ask user
- If not in a git repo and no name given: Ask for project name

## Examples

**New project (private by default):**
```
> /sheep:init "my-cool-app"

🐑 Sheep It - Initializing...
✓ GitHub CLI authenticated as @Xavier-IV
✓ Created directory: my-cool-app
✓ Initialized git repository
✓ Created repository: Xavier-IV/my-cool-app (private)
✓ Created project board
✓ Pushed initial commit

🎉 Ready to herd!
   Repo:  https://github.com/Xavier-IV/my-cool-app
   Board: https://github.com/users/Xavier-IV/projects/5
```

**New public project (explicit):**
```
> /sheep:init "open-source-lib" --public

⚠️  Creating PUBLIC repository - code will be visible to everyone.

🐑 Sheep It - Initializing...
✓ Created repository: Xavier-IV/open-source-lib (public)
✓ Created project board
...
```

**Existing repo:**
```
> /sheep:init

🐑 Sheep It - Initializing...
✓ GitHub CLI authenticated as @Xavier-IV
✓ Found existing repo: Xavier-IV/existing-project
✓ Created project board: "existing-project"

🎉 Ready to herd!
   Repo:  https://github.com/Xavier-IV/existing-project
   Board: https://github.com/users/Xavier-IV/projects/5
```
