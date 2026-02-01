---
name: sheep:research
description: Deep research mode - parallel agents explore codebase, docs, and approaches
allowed-tools:
  - Bash(gh issue view *)
  - Bash(gh issue edit *)
  - Bash(gh issue list *)
  - Bash(gh issue comment *)
  - Read
  - Glob
  - Grep
  - AskUserQuestion
  - Task
  - WebSearch
  - WebFetch
---

<objective>
Run deep research on an issue before implementation. Spawns parallel agents to:
1. Explore the codebase (patterns, conventions, related files)
2. Research external docs and best practices
3. Evaluate approaches and trade-offs

Results are posted as collapsible comments and summarized in the issue description.
</objective>

<usage>
```
/sheep:research 22             # Research issue #22
/sheep:research                # Pick from open issues
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
Question: "Which issue do you want to research?"
Header: "Issue"
Options (from issue list, mark oldest/priority as Recommended):
- "#22 Studio Working Hours (Recommended)" - description: "enhancement"
- "#23 Fix login button" - description: "bug"
```
</step>

<step name="get-issue-details">
**Get full issue details:**

```bash
gh issue view 22 --json number,title,body,labels
```

Parse the issue body for:
- **Why** section - understand the problem
- **What** section - understand the solution
- **Acceptance Criteria** - what needs to be achieved
- **Tasks** - implementation subtasks

This is what we're researching!
</step>

<step name="announce-research">
**Post research-started comment:**

```bash
gh issue comment 22 --body "$(cat <<'EOF'
## Research Started

Spawning parallel research agents to explore:
- Codebase patterns and conventions
- External documentation and best practices
- Implementation approaches and trade-offs

Results will be posted as collapsible sections below.
EOF
)"
```
</step>

<step name="spawn-parallel-agents">
**Spawn parallel research agents:**

Use the Task tool to launch multiple agents concurrently. Each agent focuses on a specific research area.

**IMPORTANT:** Call all three Task tools in a single message to run them in parallel.

```
[Task subagent_type="Explore" description="Codebase analysis for issue"]
prompt: |
  Research the codebase for issue #22: [Issue Title]

  Issue context:
  [Paste Why/What sections from issue]

  Your task:
  1. Find files related to this feature
  2. Identify existing patterns and conventions
  3. Find code that will be dependencies (code this feature relies on)
  4. Find code that may be impacted (code that uses what we'll change)
  5. Note any tests covering related areas

  Return a structured analysis with:
  - Related files (with brief descriptions)
  - Patterns to follow
  - Dependencies identified
  - Impact areas identified
  - Recommended approach based on codebase patterns
```

```
[Task subagent_type="general-purpose" description="External docs research"]
prompt: |
  Research external documentation and best practices for: [Issue Title]

  Context:
  [Paste Why/What sections]

  Your task:
  1. Search for relevant documentation (framework docs, library docs)
  2. Find best practices for this type of feature
  3. Look for common pitfalls to avoid
  4. Find example implementations if relevant

  Return:
  - Relevant documentation links
  - Best practices summary
  - Common pitfalls
  - Example references (if found)
```

```
[Task subagent_type="general-purpose" description="Approach evaluation"]
prompt: |
  Evaluate implementation approaches for: [Issue Title]

  Context:
  [Paste Why/What sections]
  [Paste acceptance criteria]

  Your task:
  1. Identify 2-3 possible approaches
  2. Analyze trade-offs for each
  3. Consider maintainability, performance, complexity
  4. Recommend best approach with reasoning

  Return:
  - Approach 1: [Name] - Description, Pros, Cons
  - Approach 2: [Name] - Description, Pros, Cons
  - Approach 3: [Name] - Description, Pros, Cons (if applicable)
  - Recommendation: [Which approach and why]
```
</step>

<step name="synthesize-results">
**Synthesize agent results:**

Once all agents complete, combine their findings:

1. **Codebase Analysis** - from Explore agent
2. **External Research** - from first general-purpose agent
3. **Approaches Evaluated** - from second general-purpose agent

Create a comprehensive research summary.
</step>

<step name="post-collapsible-comment">
**Post research findings as collapsible comment:**

```bash
gh issue comment 22 --body "$(cat <<'EOF'
## Research Complete

<details>
<summary>Codebase Analysis</summary>

### Related Files
- `path/to/file1.rb` - Description
- `path/to/file2.rb` - Description

### Patterns to Follow
- Pattern 1: Description
- Pattern 2: Description

### Dependencies
> Code this feature relies on:
- `path/to/dependency.rb` - What it provides

### Impact Areas
> Code that may be affected:
- `path/to/impacted.rb` - Why it's affected

</details>

<details>
<summary>Approaches Considered</summary>

### Approach 1: [Name]
**Description:** Brief description
**Pros:**
- Pro 1
- Pro 2
**Cons:**
- Con 1

### Approach 2: [Name]
**Description:** Brief description
**Pros:**
- Pro 1
**Cons:**
- Con 1
- Con 2

### Recommendation
[Selected approach] because [reasoning]

</details>

<details>
<summary>External Research</summary>

### Documentation
- [Link 1](url) - Description
- [Link 2](url) - Description

### Best Practices
- Practice 1
- Practice 2

### Pitfalls to Avoid
- Pitfall 1
- Pitfall 2

</details>
EOF
)"
```
</step>

<step name="update-issue-summary">
**Update issue description with research summary:**

Get current issue body, then append or update Research Summary section:

```bash
# Get current body
gh issue view 22 --json body --jq '.body'
```

Add/update Research Summary section in issue body:

```bash
gh issue edit 22 --body "$(cat <<'EOF'
[Original issue body...]

---

## Research Summary

**Recommended Approach:** [Approach name]

**Key Findings:**
- Finding 1
- Finding 2
- Finding 3

**Files to Modify:**
- `path/to/file1.rb`
- `path/to/file2.rb`

**New Files to Create:**
- `path/to/new_file.rb`

See collapsible comments below for detailed research.
EOF
)"
```
</step>

<step name="complete">
**Show research completion:**

```
Research complete for #22: Studio Working Hours

Research agents completed:
  Codebase analysis
  External documentation
  Approach evaluation

Posted to issue:
  Collapsible research comment (click to expand sections)
  Research summary added to issue description

Recommended approach: [Approach name]

Key findings:
  [Finding 1]
  [Finding 2]
  [Finding 3]

Ready to implement? Run: /sheep:start 22
Or research + implement: /sheep:start 22 --deep

Tip: Run /clear to start fresh - your context is saved in GitHub!
```
</step>

</process>

<agent-prompts>
These are the actual prompts to use when spawning agents:

**Codebase Exploration Agent (Explore):**
```
You are researching the codebase for issue #{number}: {title}

Issue context:
{why_section}
{what_section}

Your task is to thoroughly explore the codebase and find:

1. **Related Files**: Find all files that relate to this feature
   - Use Glob to find files by name patterns
   - Use Grep to search for relevant terms
   - Read key files to understand their purpose

2. **Existing Patterns**: What conventions does this codebase follow?
   - Naming conventions
   - File organization
   - Common patterns (services, helpers, etc.)

3. **Dependencies**: Code this feature will rely on
   - Models, services, utilities it will use
   - APIs or external integrations involved

4. **Impact Areas**: Code that may be affected
   - Files that import/use code we'll modify
   - Tests that cover related functionality

Return your findings in a structured format with file paths and brief descriptions.
```

**External Research Agent (general-purpose):**
```
You are researching external documentation for: {title}

Context:
{why_section}
{what_section}

Use WebSearch and WebFetch to find:

1. **Official Documentation**: Framework/library docs relevant to this feature
2. **Best Practices**: Industry standards for this type of feature
3. **Common Pitfalls**: What mistakes to avoid
4. **Example Implementations**: Reference implementations if helpful

Focus on practical, actionable information. Cite sources with URLs.
```

**Approach Evaluation Agent (general-purpose):**
```
You are evaluating implementation approaches for: {title}

Context:
{why_section}
{what_section}

Acceptance Criteria:
{acceptance_criteria}

Identify 2-3 distinct approaches to implement this feature:

For each approach:
1. **Name**: Give it a descriptive name
2. **Description**: How would it work?
3. **Pros**: Benefits of this approach
4. **Cons**: Drawbacks or risks
5. **Effort**: Relative complexity (Low/Medium/High)

Then recommend the best approach with clear reasoning based on:
- Alignment with acceptance criteria
- Maintainability
- Performance implications
- Fits with existing codebase patterns
```
</agent-prompts>

<interaction-style>
- Announce research start clearly
- Show progress as agents complete
- Use collapsible sections to avoid clutter
- Summarize key findings prominently
- Make next steps clear (implement with /sheep:start)
</interaction-style>
