---
name: Git Commit
description: This skill should be used when the user asks to "commit changes", "create a commit", "commit my work", "stage and commit", "write commit message", "make a commit", or mentions committing code changes to a git repository.
version: 0.1.0
---

## Purpose

Guide the process of creating well-structured git commits with meaningful commit messages. This skill ensures commits follow best practices and include proper attribution.

## Workflow

1. Check git status to see untracked and modified files
2. Review staged and unstaged changes with git diff
3. Examine recent commit messages for style consistency
4. Analyze changes and draft an appropriate commit message
5. Stage relevant files and create the commit
6. Verify the commit succeeded

## Instructions

When the user wants to commit changes:

### Step 1: Gather Context

Run the following commands in parallel to understand the current state:

```bash
# See all untracked and modified files (never use -uall flag)
git status

# See both staged and unstaged changes
git diff
git diff --staged

# See recent commit messages for style reference
git log --oneline -10
```

### Step 2: Analyze Changes

Review all changes (staged and unstaged) and determine:

- **Nature of changes**: New feature, enhancement, bug fix, refactoring, test, docs, etc.
- **Scope**: Which components or areas are affected
- **Purpose**: Why these changes were made (the "why" not the "what")

### Step 3: Draft Commit Message

Create a concise commit message following these guidelines:

- **First line**: Imperative mood, under 72 characters, summarizes the change
- **Use accurate verbs**: "add" for new features, "update" for enhancements, "fix" for bug fixes
- **Focus on "why"**: Explain the purpose rather than describing the code changes
- **Keep it brief**: 1-2 sentences for simple changes

Examples of good commit messages:
- `Add validation for user email input`
- `Fix race condition in connection pooling`
- `Update authentication flow to support OAuth2`
- `Refactor database queries for better performance`

### Step 4: Security Check

Before committing, verify:

- No sensitive files are being committed (.env, credentials.json, private keys)
- No secrets or API keys in the changes
- Warn the user if any suspicious files are detected

### Step 5: Stage and Commit

Stage specific files by name rather than using `git add -A` or `git add .`:

```bash
# Stage specific files
git add path/to/file1 path/to/file2

# Create commit with sign-off flag and HEREDOC for proper formatting
git commit --signoff -m "$(cat <<'EOF'
Commit message here.

Assisted-by: <assistant-name>
EOF
)"
```

### Step 6: Verify Success

After committing, run `git status` to confirm the commit succeeded.

## Important Rules

- **Never commit without user request**: Only create commits when explicitly asked
- **Never push code**: Do not run `git push` under any circumstances, uless user explicitly requests it
- **Never amend unless requested**: Always create new commits, not amend existing ones
- **Never skip hooks**: Do not use --no-verify or --no-gpg-sign unless user requests
- **Never force push**: Avoid destructive git operations
- **Never update git config**: Do not modify user's git configuration
- **Stage files explicitly**: Prefer specific file paths over `git add -A`
- **Always sign off**: Use `--signoff` flag with every commit

## Attribution

Always include the `Assisted-by:` trailer at the end of commit messages. The coding agent should use its own identity from context to fill in the appropriate value (e.g., "Claude Code", "Cursor", "GitHub Copilot").

## Sign-off

Always use the `--signoff` (or `-s`) flag when creating commits. This adds a `Signed-off-by:` trailer with the committer's identity from git config.

## Handling Pre-commit Hook Failures

If a pre-commit hook fails:

1. The commit did NOT happen - do not use --amend
2. Fix the issues identified by the hook
3. Re-stage the fixed files
4. Create a NEW commit (not amend)

## Example Usage

User: "Commit my changes"

Response:
1. Run git status and git diff to see changes
2. Analyze the modifications
3. Draft: "Add CODEOWNERS validation script and GitHub workflow"
4. Stage the specific files changed
5. Create the commit with --signoff and appropriate "Assisted-by:" trailer
6. Confirm success with git status