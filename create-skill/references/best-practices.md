# Skill Best Practices Reference

Comprehensive best practices synthesized from Anthropic's official skill documentation and "The Complete Guide to Building Skills for Claude", adapted for the open [Agent Skills specification](https://agentskills.io/specification).

## Contents

- Description writing
- Progressive disclosure patterns
- Naming conventions and portable metadata
- Content guidelines
- Common patterns
- Executable scripts
- Evaluation-driven development
- Anti-patterns

---

## Description Writing

The description field is the single most important part of a skill. The coding agent uses it to decide whether to trigger the skill from potentially 100+ available skills.

### Formula

```
[What it does] + [When to use it with specific trigger phrases] + [Key capabilities]
```

### Rules

- MUST use third person ("This skill should be used when the user asks to...")
- MUST include specific trigger phrases in quotes
- MUST be under 1024 characters
- MUST NOT contain XML angle brackets (< >)
- Include file types if relevant
- Add negative triggers if over-triggering is a risk ("Do NOT use for simple data exploration")

### Good Examples

```yaml
# Specific, actionable, includes trigger phrases
description: Analyzes Figma design files and generates developer handoff documentation. Use when user uploads .fig files, asks for "design specs", "component documentation", or "design-to-code handoff".

# Includes both positive and negative triggers
description: Advanced data analysis for CSV files. Use for statistical modeling, regression, clustering. Do NOT use for simple data exploration (use data-viz skill instead).

# Clear scope with trigger phrases
description: End-to-end customer onboarding workflow for PayFlow. Handles account creation, payment setup, and subscription management. Use when user says "onboard new customer", "set up subscription", or "create PayFlow account".
```

### Bad Examples

```yaml
# Too vague, no triggers
description: Helps with projects.

# Missing trigger phrases
description: Creates sophisticated multi-page documentation systems.

# Too technical, no user triggers
description: Implements the Project entity model with hierarchical relationships.

# Wrong person
description: Use this skill when you want to create X.

# Not specific enough
description: Processes documents.
```

### Debugging Triggering

Ask the agent: "When would you use the [skill name] skill?" The agent will quote the description back. Adjust based on what is missing or ambiguous.

---

## Progressive Disclosure Patterns

### Pattern 1: High-Level Guide with References

Best for most skills. `SKILL.md` provides overview and quick-start, references hold details.

```markdown
# PDF Processing

## Quick Start
[Essential instructions]

## Advanced Features
**Form filling**: See [FORMS.md](references/forms.md) for complete guide
**API reference**: See [REFERENCE.md](references/reference.md) for all methods
**Examples**: See [EXAMPLES.md](examples/examples.md) for common patterns
```

### Pattern 2: Domain-Specific Organization

Best for skills with multiple distinct domains. Keeps irrelevant context unloaded.

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

Include grep patterns in `SKILL.md` for large reference files:

```markdown
## Quick Search
Find specific metrics:
- `grep -i "revenue" references/finance.md`
- `grep -i "pipeline" references/sales.md`
```

### Pattern 3: Conditional Details

Show basic content, link to advanced content based on task type.

```markdown
## Editing Documents
For simple edits, modify the XML directly.
**For tracked changes**: See [REDLINING.md](references/redlining.md)
**For OOXML details**: See [OOXML.md](references/ooxml.md)
```

### Key Rules

- Keep references **one level deep** from `SKILL.md` — never chain A → B → C
- Add a **table of contents** to reference files over 100 lines
- Name files descriptively: `form_validation_rules.md`, not `doc2.md`
- Organize directories by domain or feature, not generically (`references/finance.md`, not `docs/file1.md`)

---

## Naming Conventions and Portable Metadata

### Skill Names (`name` field)

- kebab-case only: `processing-pdfs`, `managing-databases`
- MUST match the directory name exactly
- Max 64 characters
- Must be unique within the repository or collection

**Preferred:** Gerund form (verb + -ing): `processing-pdfs`, `analyzing-spreadsheets`
**Acceptable:** Noun phrases (`pdf-processing`) or action-oriented (`process-pdfs`)
**Avoid:** Vague names (`helper`, `utils`, `tools`), overly generic (`documents`, `data`)

### Portable Metadata

Place non-standard top-level fields under `metadata:`:

```yaml
---
name: my-skill
description: Use when...
metadata:
  version: "0.1.0"
---
```

Do not include harness-specific fields like `model`, `argument-hint`, or client-specific tool whitelist fields in frontmatter.

### Folder Names

- kebab-case: `notion-project-setup`
- No spaces, underscores, or capitals
- Must match `name` in frontmatter

### File Names

- Descriptive: `form_validation_rules.md`, not `doc2.md`
- Always use forward slashes in paths (never backslashes)

---

## Content Guidelines

### Consistent Terminology

Pick one term and use it everywhere:
- Always "API endpoint" (not mix of "URL", "API route", "path")
- Always "field" (not mix of "box", "element", "control")
- Always "extract" (not mix of "pull", "get", "retrieve")

### Avoid Time-Sensitive Information

Don't include dates that will become outdated. Use "old patterns" sections:

```markdown
## Current Method
Use the v2 API endpoint: `api.example.com/v2/messages`

## Old Patterns
<details>
<summary>Legacy v1 API (deprecated)</summary>
The v1 API used: `api.example.com/v1/messages`
This endpoint is no longer supported.
</details>
```

### Provide Defaults, Not Menus

Don't present multiple competing approaches. Provide a default with an escape hatch:

```markdown
Use pdfplumber for text extraction:
    import pdfplumber

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

---

## Common Patterns

### Template Pattern

For strict output requirements:
```markdown
ALWAYS use this exact template structure:
[template]
```

For flexible guidance:
```markdown
Here is a sensible default format, but use best judgment:
[template]
Adjust sections as needed for the specific context.
```

### Examples Pattern (Input/Output Pairs)

When output quality depends on seeing examples:

```markdown
## Commit Message Format

**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication

**Example 2:**
Input: Fixed bug where dates displayed incorrectly
Output: fix(reports): correct date formatting in timezone conversion
```

### Conditional Workflow Pattern

Guide through decision points:

```markdown
1. Determine the task type:
   **Creating new content?** → Follow "Creation workflow" below
   **Editing existing content?** → Follow "Editing workflow" below
```

### Sequential Workflow Orchestration

For multi-step processes in specific order with dependencies, validation at each stage, and rollback instructions for failures.

### Iterative Refinement

For output that improves with iteration: generate draft → run quality check → fix issues → re-validate → repeat until threshold met.

### Feedback Loops

For quality-critical tasks: run validator → fix errors → repeat. Validation scripts provide objective verification. Verbose error messages help the agent fix issues.

---

## Executable Scripts

### When to Include Scripts

- Same code is rewritten repeatedly
- Deterministic reliability needed
- Operations are fragile or error-prone

### Script Guidelines

**Handle errors explicitly** — don't punt to the agent:

```python
def process_file(path):
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        print(f"File {path} not found, creating default")
        with open(path, "w") as f:
            f.write("")
        return ""
```

**Document magic numbers:**

```python
# HTTP requests typically complete within 30 seconds
REQUEST_TIMEOUT = 30

# Most intermittent failures resolve by second retry
MAX_RETRIES = 3
```

**Make execution intent clear in SKILL.md:**
- Execute: "Run `scripts/analyze_form.py` to extract fields"
- Read as reference: "See `scripts/analyze_form.py` for the extraction algorithm"

### Verifiable Intermediate Outputs

For complex/destructive operations, use the plan-validate-execute pattern:
1. Analyze input
2. Create plan file (e.g., `changes.json`)
3. Validate plan with script
4. Execute only after validation passes

Make validation scripts verbose: "Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed"

### Package Dependencies

List required packages in `SKILL.md`. Don't assume packages are installed — be explicit:

```markdown
Install required package: `pip install pypdf`
```

---

## Evaluation-Driven Development

Build evaluations BEFORE writing extensive documentation:

1. **Identify gaps**: Run the agent on representative tasks without a skill. Document specific failures.
2. **Create evaluations**: Build 3+ scenarios that test these gaps.
3. **Establish baseline**: Measure the agent's performance without the skill.
4. **Write minimal instructions**: Just enough to address gaps and pass evaluations.
5. **Iterate**: Execute evaluations, compare against baseline, refine.

### Iterative Development Pattern

Work with one agent instance ("Authoring Agent") to create skills tested by another ("Testing Agent"):

1. Complete a task with the Authoring Agent using normal prompting
2. Identify what context was repeatedly provided
3. Ask the Authoring Agent to create a skill capturing the pattern
4. Review for conciseness — remove obvious explanations
5. Test with the Testing Agent on similar tasks
6. Iterate: bring the Testing Agent's struggles back to refine the instructions

### Observing Skill Usage

Watch for:
- **Unexpected exploration paths**: Structure may not be intuitive
- **Missed connections**: References need to be more explicit
- **Overreliance on certain sections**: Content may belong directly in `SKILL.md`
- **Ignored content**: Files may be unnecessary or poorly signaled

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|---|---|---|
| Windows-style paths (`scripts\helper.py`) | Breaks on Unix | Use forward slashes (`scripts/helper.py`) |
| Too many options | Confuses agents | Provide one default with escape hatch |
| Vague names (`helper`, `utils`) | Poor discoverability | Descriptive names (`form-validation`) |
| Time-sensitive info | Becomes wrong | Use "old patterns" sections |
| Deeply nested references | Agents partially read | Keep one level deep |
| README.md in skill folder | Conflicts with SKILL.md | All docs in SKILL.md or references/ |
| Inconsistent terminology | Confuses agents | Pick one term, use everywhere |
| Over-explaining basics | Wastes tokens | Trust the agent's baseline knowledge |
| Vague description | Never triggers | Include specific trigger phrases |
| No README.md for distribution | Humans can't find/understand | Add repo-level README (outside skill folder) |
