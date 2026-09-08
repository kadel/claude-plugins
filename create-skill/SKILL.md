---
name: create-skill
description: Guides creation of agent-neutral skills following the Agent Skills specification and best practices, including SKILL.md authoring, frontmatter, progressive disclosure, and validation. This skill should be used when the user asks to "create a skill", "new skill", "build a skill", "scaffold a skill", "write a SKILL.md", "design a skill", "skill authoring", or wants guidance on skill structure, frontmatter fields, description triggers, or skill development.
metadata:
  version: "0.1.0"
---

# Create Skill

Guide for creating effective, agent-neutral skills that trigger reliably, use context efficiently, and follow open Agent Skills best practices.

## Core Principles

### Context Window is a Shared Resource

Only include information the coding agent does not already know. Challenge each piece of content:
- Does the agent really need this explanation?
- Can the agent be assumed to know this from training or standard documentation?
- Does this paragraph justify its token cost?

### Progressive Disclosure (Three Levels)

Skills use a three-level loading system:

| Level | Content | When Loaded | Budget |
|-------|---------|-------------|--------|
| 1. YAML frontmatter | `name` + `description` | Always in agent system prompt | ~100 words |
| 2. `SKILL.md` body | Core instructions | When skill triggers | <500 lines |
| 3. Bundled resources | `references/`, `scripts/`, `assets/`, `examples/` | On-demand by the agent | Unlimited |

### Degrees of Freedom

Match specificity to fragility:
- **High freedom** (prose instructions): Multiple valid approaches, context-dependent decisions.
- **Medium freedom** (pseudocode/templates): Preferred patterns with acceptable variation.
- **Low freedom** (exact scripts): Fragile operations, consistency critical, specific sequence required.

## Skill Creation Workflow

### Step 1: Understand Use Cases

Before writing anything, identify 2-3 concrete use cases. Clarify:
- What tasks should this skill handle?
- What would a user say to trigger it?
- What does success look like?

Define each use case with: trigger phrase, workflow steps, expected result.

### Step 2: Plan Resources

Analyze each use case to identify reusable resources:

| Resource Type | Directory | Purpose | When to Use |
|---|---|---|---|
| Scripts | `scripts/` | Deterministic, repeatedly-written code | Same code rewritten each time |
| References | `references/` | Documentation loaded into context as needed | Schemas, API docs, detailed guides |
| Assets | `assets/` | Files used in output, not loaded into context | Templates, boilerplate, non-text files |
| Examples | `examples/` | Working code or sample configurations | Concrete reference patterns |

### Step 3: Scaffold Directory Structure

Scaffold the skill using `npx skills init`:

```bash
npx skills init <skill-name>
```

This creates `<skill-name>/SKILL.md` with starter frontmatter and sections.

Create only the supporting subdirectories actually needed:

```bash
mkdir -p <skill-name>/references  # if detailed docs or schemas needed
mkdir -p <skill-name>/scripts     # if deterministic utility scripts needed
mkdir -p <skill-name>/examples    # if working sample files needed
mkdir -p <skill-name>/assets      # if static output assets needed
```

All resources must be self-contained within `<skill-name>/`.

### Step 4: Author SKILL.md

#### Frontmatter (Level 1)

The frontmatter is the discovery entrypoint — it determines when the agent loads the skill.

```yaml
---
name: skill-name-in-kebab-case
description: This skill should be used when the user asks to "phrase 1", "phrase 2", "phrase 3", or mentions [specific terms]. Provides [what it does].
metadata:
  version: "0.1.0"
---
```

**Required fields:**
- `name` — kebab-case, max 64 characters, MUST match the directory name exactly.
- `description` — max 1024 characters, non-empty, plain text (no angle brackets `< >`).

**Optional portable metadata:**
- `metadata.version` — quoted semver string (e.g. `"0.1.0"`).

**Description formula:** `[What it does] + [When to use it with trigger phrases] + [Key capabilities]`

**Description rules:**
- MUST use third person ("This skill should be used when the user asks to...")
- MUST include specific trigger phrases users would say
- MUST mention relevant file types or command names if applicable
- Include negative triggers if over-triggering is a risk ("Do NOT use for...")

For detailed examples of good and bad descriptions, see `references/best-practices.md`.

#### Body (Level 2)

Write the core instructions in imperative form, not second person:
- **Correct:** "Create the configuration file." / "Run validation before proceeding."
- **Incorrect:** "You should create..." / "You need to run..."

**Body guidelines:**
- Keep under 500 lines (~2,000 words).
- Include only what the agent does not already know.
- Reference bundled resources clearly with relative paths so the agent discovers them.
- Structure with clear headings and steps.
- Provide a default approach with escape hatches, not multiple competing options.

**Recommended body structure:**

```markdown
# Skill Name

## Purpose
[2-3 sentences on what this skill does]

## Prerequisites
[Required tools, credentials, or environment variables]

## Instructions / Workflow
[Core steps in imperative form]

## Important Rules
[Critical constraints — use strong language like MUST, NEVER]

## Additional Resources
[Pointers to references/, examples/, scripts/]
```

#### Bundled Resources (Level 3)

Reference all bundled files from `SKILL.md` so the agent discovers them:

```markdown
## Additional Resources

For detailed patterns: see `references/patterns.md`
For working examples: see `examples/`
For validation: run `scripts/validate.sh`
```

**Rules for bundled resources:**
- Keep references one level deep from `SKILL.md` (no chains: A → B → C).
- Add a table of contents to reference files over 100 lines.
- Name files descriptively (`form_validation_rules.md`, not `doc2.md`).
- Use forward slashes in all paths (`references/spec.md`).
- Make clear whether scripts should be executed or read as reference.
- Do NOT place `README.md` inside skill folders.
- Information should live in either `SKILL.md` or references, not both.

### Step 5: Write Bundled Resources

Start with the reusable resources identified in Step 2 before finalizing `SKILL.md`.

**For scripts:** Handle errors explicitly rather than failing silently. Document any magic numbers. Ensure scripts are executable if intended to run.

**For references:** Move anything beyond core instructions here — detailed patterns, API docs, schemas, edge cases.

### Step 6: Validate

Run through the checklist in `references/checklist.md`. Key checks:

1. **Naming agreement** — folder name matches frontmatter `name` exactly.
2. **Triggering** — description has specific trigger phrases in third person.
3. **Conciseness** — `SKILL.md` body under 500 lines, no redundant explanations.
4. **Progressive disclosure** — detailed content in references, not `SKILL.md`.
5. **References exist** — all files mentioned in `SKILL.md` actually exist.
6. **Writing style** — imperative form throughout body, third person in description.
7. **Portable metadata** — version in `metadata.version`, no harness-specific frontmatter fields.

### Step 7: Test

Test the skill locally using `npx skills`:

```bash
# Discover skills locally
npx skills add . --list

# Test installing in an isolated test directory outside the repo
cd $(mktemp -d)
npx skills add /path/to/collection --skill <skill-name> -a claude-code codex -y
npx skills list
```

Test triggering and functionality with representative queries against your target coding agents:
- **Triggering tests**: Does the skill trigger on obvious tasks? Paraphrased requests? Does it avoid triggering on unrelated topics?
- **Functional tests**: Does it produce correct outputs and handle edge cases?

Keep all generated test installations and scratch skills outside this repository.

### Step 8: Iterate

Skills are living documents:
- **Under-triggering**: Add more trigger phrases and keywords to the description.
- **Over-triggering**: Add negative triggers, tighten scope.
- **Ignored content**: If agents never access a file, it may be unnecessary or poorly signaled.
- **Overreliance**: If agents repeatedly read one reference file, its core summary may belong in `SKILL.md`.

## Additional Resources

### Best Practices Reference

For comprehensive, agent-neutral best practices adapted from the original Anthropic sources and aligned with the [Agent Skills specification](https://agentskills.io/specification), see `references/best-practices.md`.

### Validation Checklist

For a complete pre-publish checklist, see `references/checklist.md`.
