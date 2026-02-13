---
name: documentation
description: >
  This skill should be used when the user asks to "review documentation",
  "review docs in a PR", "check documentation quality", "review docs changes",
  "review technical documentation", "check docs for clarity",
  "review PR documentation", or mentions reviewing documentation changes
  for ease of understanding and technical correctness.
version: 0.1.0
---

# Documentation Review for Pull Requests

Review documentation changes proposed in a GitHub pull request, evaluating them across two primary dimensions: **ease of understanding** and **technical correctness**. Produce a structured report with categorized findings and severity levels.

## Review Process

### Step 1: Retrieve the PR Diff

Obtain the documentation changes from the pull request. Accept either a PR number/URL as an argument or auto-detect the PR for the current branch.

**With a PR number or URL:**

```bash
gh pr diff <PR_NUMBER_OR_URL>
```

**Auto-detect from current branch:**

```bash
gh pr view --json number --jq '.number'
gh pr diff <detected_number>
```

### Step 2: Identify Documentation Files

Filter the diff to focus on documentation files. Include files with these extensions and patterns:

- Markdown: `.md`, `.mdx`
- reStructuredText: `.rst`
- AsciiDoc: `.adoc`, `.asciidoc`
- Plain text: `.txt` (when prose-heavy)
- YAML front matter files used for docs (e.g., in static site generators)
- Inline documentation in code files (docstrings, JSDoc, comment blocks) only when substantially changed

If no documentation files are found in the diff, report that clearly and stop.

### Step 3: Review Each File

For every documentation file changed in the PR, evaluate the changes against the four review categories below. Focus on the **changed lines** but consider surrounding context for coherence.

Read the full file content when necessary to assess whether changes fit within the broader document structure.

## Review Categories

### 1. Clarity

Evaluate how easy the documentation is to understand for the target audience.

**Check for:**
- Ambiguous or vague language that could confuse readers
- Overly complex sentences that should be simplified
- Missing context or prerequisite knowledge assumptions
- Jargon used without explanation
- Unclear pronoun references (e.g., "it", "this" without a clear antecedent)
- Logical flow and coherence between sections
- Paragraph and section length (break up walls of text)
- Effective use of headings to aid navigation

### 2. Technical Accuracy

Evaluate whether the technical content is correct and reliable.

**Check for:**
- Incorrect command syntax or API usage
- Wrong parameter names, types, or default values
- Outdated version references or deprecated features
- Code examples that would not compile or run
- Incorrect file paths or URLs
- Factual errors about how systems, libraries, or tools behave
- Mismatched descriptions and code examples
- Missing error handling or caveats in examples

When uncertain about a technical claim, flag it as needing verification rather than marking it incorrect.

### 3. Structure

Evaluate the organization and formatting of the documentation.

**Check for:**
- Logical ordering of sections (general to specific, prerequisites before usage)
- Consistent heading hierarchy (no skipped levels)
- Appropriate use of lists, tables, and code blocks
- Broken markdown/formatting syntax
- Missing or inconsistent table of contents entries
- Orphaned sections that don't connect to the document flow
- Duplicate content within the same document or across related docs

### 4. Grammar and Style

Evaluate the writing quality and consistency.

**Check for:**
- Spelling and grammatical errors
- Inconsistent terminology (using different terms for the same concept)
- Inconsistent formatting conventions (e.g., mixed use of bold/italic for emphasis)
- Passive voice where active voice would be clearer
- Inconsistent capitalization of product names or technical terms
- Missing or incorrect punctuation in lists

## Severity Levels

Assign a severity to each finding:

- **Critical**: Technically incorrect information that could cause errors, data loss, or security issues. Broken examples that will not work. Must be fixed before merging.
- **Warning**: Misleading or confusing content that could cause readers to misunderstand. Structural issues that significantly hurt usability. Should be fixed before merging.
- **Suggestion**: Minor improvements to clarity, style, or structure. Nice to have but not blocking.

## Output Format

Structure the review output as follows:

```
## Documentation Review: PR #<number>

### Summary
<2-3 sentence overview of documentation quality and key findings>

**Files reviewed:** <count>
**Findings:** <X critical, Y warnings, Z suggestions>

---

### Critical Issues

#### [Category] Finding title
**File:** `path/to/file.md` (lines X-Y)
**Description:** Clear explanation of the issue.
**Suggestion:** Concrete recommendation for fixing it.

---

### Warnings

#### [Category] Finding title
**File:** `path/to/file.md` (lines X-Y)
**Description:** Clear explanation of the issue.
**Suggestion:** Concrete recommendation for fixing it.

---

### Suggestions

#### [Category] Finding title
**File:** `path/to/file.md` (lines X-Y)
**Description:** Clear explanation of the issue.
**Suggestion:** Concrete recommendation for fixing it.

---

### Verdict
<APPROVE | REQUEST_CHANGES | COMMENT>
<Brief justification for the verdict>
```

## Verdict Criteria

- **APPROVE**: No critical issues. Warnings are minor or few.
- **REQUEST_CHANGES**: Any critical issue exists, or multiple warnings indicate significant quality problems.
- **COMMENT**: No critical issues, but enough warnings or suggestions to warrant discussion.

## Guidelines

- Be specific in findings. Reference exact lines and quote the problematic text.
- Provide actionable suggestions. Do not just point out problems; offer concrete fixes.
- Respect the author's voice. Do not rewrite entire sections to match a personal preference.
- Focus on the diff. Avoid reviewing unchanged content unless it directly impacts the changes.
- Consider the audience. Assess clarity relative to the document's intended readers.
- When a PR has no documentation files changed, state that clearly rather than forcing a review.
- Group related findings together rather than reporting the same pattern multiple times.
