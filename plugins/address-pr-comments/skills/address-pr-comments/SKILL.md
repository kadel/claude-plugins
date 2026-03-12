---
name: address-pr-comments
description: "This skill should be used when the user asks to \"address PR comments\", \"fix review feedback\", \"handle PR reviews\", \"resolve review threads\", \"address review comments\", or mentions handling pull request review comments on GitHub."
argument-hint: "<pr-number>"
version: 0.1.0
---

# Address PR Review Comments

Automate addressing pull request review feedback: analyze comments, assess validity, make fixes, reply to explain changes, and resolve threads.

## Prerequisites

- `gh` CLI must be authenticated (`gh auth status`)
- Must be in a git repository with a GitHub remote

## Step 1: Determine PR Number


**If $ARGUMENTS is provided:**
- Extract PR number from $ARGUMENTS
- Validate that it is existing PR

**If $ARGUMENTS is empty:**
- Use gh to get the PR number for the current branch `gh pr list --head "$(git branch --show-current)" --json number --jq '.[0].number'`
- If no PR is found, use AskUserQuestion to ask for the PR number
- Validate that it is existing PR


## Step 2: Determine Repository Info

Extract the owner and repo name from the git remote:

```bash
gh repo view --json owner,name -q '.owner.login + "/" + .name'
```

## Step 3: Fetch PR Review Threads

Run this GraphQL query to get all unresolved review threads:

```bash
gh api graphql -f query='
query {
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: PR_NUMBER) {
      id
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          path
          line
          comments(first: 10) {
            nodes {
              id
              databaseId
              body
              author {
                login
              }
            }
          }
        }
      }
    }
  }
}'
```

Replace `OWNER`, `REPO`, and `PR_NUMBER` with actual values.

Filter to only unresolved threads (`isResolved: false`).

If there are no unresolved threads, inform the user and exit.

## Step 4: Analyze and Categorize Comments

For each unresolved thread:

1. Read the comment body to understand the feedback
2. Identify the file path and line number
3. Read the relevant file section to understand the context
4. Categorize the type of feedback:
   - **Code change needed** - requires file modification
   - **Documentation** - needs comment/doc update
   - **Question** - requires explanation only, no code change
   - **Disagree/Won't fix** - ASK USER before responding
5. Assess validity: does the feedback make sense given the code context? Is it actionable?

Present a summary to the user showing:
- Number of comments found
- File paths affected
- Brief description of each comment
- Assessment of each comment (valid, questionable, not applicable)

**IMPORTANT**: For any comment where you disagree or think "won't fix" is appropriate, use AskUserQuestion to get user confirmation before replying. Never auto-resolve disagreements.

**IMPORTANT**: For comments that don't make sense or seem incorrect, use AskUserQuestion to confirm with the user before skipping or responding.

## Step 5: Address Each Comment

For each comment the user agrees should be addressed:

### 5a. Read the relevant file

Use the Read tool to understand the context around the specified line.

### 5b. Make the fix

Make the necessary changes based on the feedback.

### 5c. Reply to the comment

Use REST API to reply to the comment explaining what was done:

```bash
gh api --method POST \
  repos/OWNER/REPO/pulls/PR_NUMBER/comments/COMMENT_DB_ID/replies \
  -f body='Fixed: [explanation of what was changed and why]'
```

Keep replies concise but informative. Explain WHAT was changed and WHY.

**IMPORTANT**: Ask user to confirm before posting any reply using AskUserQuestion.


### 5d. Resolve the thread

Use GraphQL mutation to resolve the thread:

```bash
gh api graphql -f query='
mutation {
  resolveReviewThread(input: {threadId: "THREAD_NODE_ID"}) {
    thread { isResolved }
  }
}'
```
**IMPORTANT**: Ask user to confirm before resolving  using AskUserQuestion.

## Step 6: Commit Changes

After all fixes are made:

1. Stage all changed files with `git add` (stage specific files by name)
2. Create a commit with a descriptive message following conventional commits format:

```bash
git commit -m "$(cat <<'EOF'
fix: address PR review feedback

- [list each fix made]
- [reference comment IDs if helpful]
EOF
)"
```

3. Push the changes to the remote branch

## Step 7: Summary

Present a summary to the user:

- Number of comments addressed
- Number of comments skipped (with reasons)
- Files modified
- Commit hash created
- Any comments that were NOT addressed (with reasons)
- Link to the PR

## Error Handling

- If `gh` CLI is not authenticated, instruct user to run `gh auth login`
- If PR number is invalid, show error and ask for correct number
- If a thread fails to resolve, log the error but continue with other threads
- If commit fails, show the error and suggest manual resolution
