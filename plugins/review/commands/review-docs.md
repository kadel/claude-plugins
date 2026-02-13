---
description: Review documentation changes in a GitHub PR for clarity and technical correctness
argument-hint: Optional PR number or URL (auto-detects current branch PR if omitted)
allowed-tools: ["Read", "Bash", "Grep", "Glob", "Write"]
---

# Review Documentation in a PR

Review documentation changes in a GitHub pull request, focusing on ease of understanding and technical correctness.

**Arguments:** $ARGUMENTS

## Workflow

1. **Determine the PR to review:**
   - If `$ARGUMENTS` contains a PR number or URL, use that directly
   - If `$ARGUMENTS` is empty, detect the PR for the current branch:
     ```bash
     gh pr view --json number --jq '.number'
     ```
   - If no PR is found, inform the user and stop

2. **Fetch the PR diff and metadata:**
   ```bash
   gh pr diff <PR_NUMBER>
   gh pr view <PR_NUMBER> --json title,body,files
   ```

3. **Fetch existing PR comments** for additional context:
   ```bash
   # Inline review comments on specific lines
   gh api repos/{owner}/{repo}/pulls/<PR_NUMBER>/comments --jq '.[] | {user: .user.login, body: .body, path: .path, line: .line}'
   # General conversation comments
   gh api repos/{owner}/{repo}/issues/<PR_NUMBER>/comments --jq '.[] | {user: .user.login, body: .body}'
   ```
   - Use `gh repo view --json nameWithOwner --jq .nameWithOwner` to get `{owner}/{repo}`
   - Consider existing comments when reviewing — avoid duplicating feedback already given, and prioritize unresolved concerns

4. **Identify documentation files** from the changed files:
   - Include: `.md`, `.mdx`, `.rst`, `.adoc`, `.asciidoc`, `.txt` (prose-heavy)
   - If no documentation files are changed, report that and stop

5. **Read the full content** of each changed documentation file to understand context
   - Do not inspect raw file bytes or encoding. Do not use `xxd`, `od`, `hexdump`, or similar binary inspection tools. Focus only on the textual content.

6. **Apply the documentation skill** to evaluate changes across four categories:
   - **Clarity** - ease of understanding, ambiguity, complexity
   - **Technical Accuracy** - correctness of commands, examples, facts
   - **Structure** - organization, formatting, heading hierarchy
   - **Grammar and Style** - spelling, consistency, tone

7. **Produce the structured report** with:
   - Summary with file count and finding counts
   - Findings grouped by severity (Critical, Warning, Suggestion)
   - Each finding tagged with its category, file, and line numbers
   - Actionable suggestions for each finding
   - Final verdict: APPROVE, REQUEST_CHANGES, or COMMENT
