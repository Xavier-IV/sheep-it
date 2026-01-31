# /sheep:init

Initialize a new project with Sheep It or setup Sheep It in an existing repo.

## Usage

```
/sheep:init                      # Setup in current repo
/sheep:init "project-name"       # Create new repo + setup
/sheep:init --private            # Create as private repo
/sheep:init "name" --private     # Create new private repo
```

## Behavior

### When in an existing git repo (no project name given):

1. **Verify GitHub CLI**: Run `gh auth status` to ensure authenticated
2. **Check if repo exists on GitHub**: Run `gh repo view`
3. **If not on GitHub**: Offer to create it with `gh repo create`
4. **Setup complete**: Confirm Sheep It is ready

### When creating a new project (project name given):

1. **Verify GitHub CLI**: Run `gh auth status`
2. **Create directory**: `mkdir -p <project-name> && cd <project-name>`
3. **Initialize git**: `git init`
4. **Create README**: Basic README.md with project name
5. **Initial commit**: `git add . && git commit -m "Initial commit"`
6. **Create GitHub repo**:
   - Private (default): `gh repo create <project-name> --private --source=. --push`
   - Public: `gh repo create <project-name> --public --source=. --push`
7. **Confirm success**: Show repo URL

## Output Format

```
🐑 Sheep It - Initializing...

✓ GitHub CLI authenticated as @username
✓ Created repository: username/project-name (private)
✓ Pushed initial commit

🎉 Ready to herd! Your repo: https://github.com/username/project-name

Next steps:
  /sheep:milestone "v1.0.0"    # Create your first milestone
  /sheep:task "First task"     # Create your first task
```

## Error Handling

- If `gh` not installed: Show install instructions
- If not authenticated: Run `gh auth login`
- If repo name taken: Suggest alternative or ask user
- If not in a git repo and no name given: Ask for project name

## Examples

**New private project:**
```
> /sheep:init "my-cool-app"

🐑 Sheep It - Initializing...
✓ GitHub CLI authenticated as @Xavier-IV
✓ Created directory: my-cool-app
✓ Initialized git repository
✓ Created repository: Xavier-IV/my-cool-app (private)
✓ Pushed initial commit

🎉 Ready to herd! https://github.com/Xavier-IV/my-cool-app
```

**New public project:**
```
> /sheep:init "open-source-lib" --public

🐑 Sheep It - Initializing...
✓ Created repository: Xavier-IV/open-source-lib (public)
...
```

**Existing repo:**
```
> /sheep:init

🐑 Sheep It - Initializing...
✓ GitHub CLI authenticated as @Xavier-IV
✓ Found existing repo: Xavier-IV/existing-project
✓ Sheep It ready!

🎉 Ready to herd! https://github.com/Xavier-IV/existing-project
```
