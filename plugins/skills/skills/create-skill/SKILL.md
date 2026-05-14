---
name: create-skill
description: Guides creation of Claude Code skills following official Anthropic best practices, including SKILL.md authoring, frontmatter, progressive disclosure, and validation. This skill should be used when the user asks to "create a skill", "new skill", "build a skill", "scaffold a skill", "write a SKILL.md", "design a skill", "add a skill to a plugin", "skill authoring", or wants guidance on skill structure, frontmatter fields, description triggers, or skill development. Do NOT use for non-Claude-Code skill concepts (game skill trees, resume skills, etc.).
version: 0.1.0
---

# Create Skill

Guide for creating effective Claude Code skills that trigger reliably, use context efficiently, and follow official best practices.

## Core Principles

### Context Window is a Public Good

Only include information Claude does not already know. Challenge each piece of content:
- Does Claude really need this explanation?
- Can Claude be assumed to know this?
- Does this paragraph justify its token cost?

### Progressive Disclosure (Three Levels)

Skills use a three-level loading system:

| Level | Content | When Loaded | Budget |
|-------|---------|-------------|--------|
| 1. YAML frontmatter | name + description | Always in system prompt | ~100 words |
| 2. SKILL.md body | Core instructions | When skill triggers | <500 lines |
| 3. Bundled resources | references/, scripts/, assets/ | On-demand by Claude | Unlimited |

### Degrees of Freedom

Match specificity to fragility:
- **High freedom** (prose instructions): Multiple valid approaches, context-dependent decisions
- **Medium freedom** (pseudocode/templates): Preferred pattern with acceptable variation
- **Low freedom** (exact scripts): Fragile operations, consistency critical, specific sequence required

## Skill Creation Workflow

### Step 1: Understand Use Cases

Before writing anything, identify 2-3 concrete use cases. Ask the user:
- What tasks should this skill handle?
- What would a user say to trigger it?
- What does success look like?

Define each use case with: trigger phrase, steps, expected result.

### Step 2: Plan Resources

Analyze each use case to identify reusable resources:

| Resource Type | Directory | Purpose | When to Use |
|---|---|---|---|
| Scripts | `scripts/` | Deterministic, repeatedly-written code | Same code rewritten each time |
| References | `references/` | Documentation loaded into context as needed | Schemas, API docs, detailed guides |
| Assets | `assets/` | Files used in output, not loaded into context | Templates, images, fonts, boilerplate |

### Step 3: Create Directory Structure

```bash
mkdir -p plugin-name/skills/skill-name
```

Add only the subdirectories actually needed:
```bash
mkdir -p plugin-name/skills/skill-name/references  # if detailed docs needed
mkdir -p plugin-name/skills/skill-name/scripts      # if utility scripts needed
mkdir -p plugin-name/skills/skill-name/examples      # if working examples needed
mkdir -p plugin-name/skills/skill-name/assets        # if output templates needed
```

### Step 4: Write SKILL.md

#### Frontmatter (Level 1)

The frontmatter is the most important part — it determines when Claude loads the skill.

```yaml
---
name: skill-name-in-kebab-case
description: This skill should be used when the user asks to "phrase 1", "phrase 2", "phrase 3", or mentions [specific terms]. Provides [what it does].
version: 0.1.0
---
```

**Required fields:**
- `name` — kebab-case, max 64 chars, no "claude"/"anthropic", MUST match folder name
- `description` — max 1024 chars, no XML tags

**Description formula:** `[What it does] + [When to use it with trigger phrases] + [Key capabilities]`

**Description rules:**
- MUST use third person ("This skill should be used when the user asks to...")
- MUST include specific trigger phrases users would say
- MUST mention relevant file types if applicable
- Include negative triggers if over-triggering is a risk

For detailed examples of good and bad descriptions, see `references/best-practices.md`.

#### Body (Level 2)

Write the core instructions in imperative form, not second person:
- **Correct:** "Create the configuration file." / "Run validation before proceeding."
- **Incorrect:** "You should create..." / "You need to run..."

**Body guidelines:**
- Keep under 500 lines (~2,000 words)
- Include only what Claude does not already know
- Reference bundled resources clearly so Claude knows they exist
- Structure with clear headings and steps
- Provide a default approach with escape hatches, not multiple competing options

**Recommended body structure:**

```markdown
# Skill Name

## Purpose
[2-3 sentences on what this skill does]

## Instructions / Workflow
[Core steps in imperative form]

## Important Rules
[Critical constraints — use strong language like MUST, NEVER]

## Additional Resources
[Pointers to references/, examples/, scripts/]
```

#### Bundled Resources (Level 3)

Reference all bundled files from SKILL.md so Claude discovers them:

```markdown
## Additional Resources

For detailed patterns: see `references/patterns.md`
For working examples: see `examples/`
For validation: run `scripts/validate.sh`
```

**Rules for bundled resources:**
- Keep references one level deep from SKILL.md (no chains: A → B → C)
- Add a table of contents to reference files over 100 lines
- Name files descriptively (`form_validation_rules.md`, not `doc2.md`)
- Use forward slashes in all paths (never backslashes)
- Make clear whether scripts should be executed or read as reference
- No README.md inside skill folders
- Information should live in either SKILL.md or references, not both

### Step 5: Write Bundled Resources

Start with the reusable resources identified in Step 2 before finalizing SKILL.md. This may require user input (e.g., brand assets, API schemas, domain documentation).

**For scripts:** Handle errors explicitly rather than failing silently. Document any magic numbers. Scripts save tokens and improve reliability vs. generated code.

**For references:** Move anything beyond core instructions here — detailed patterns, API docs, migration guides, edge cases. Each file can be 2,000-5,000+ words.

### Step 6: Validate

Run through the checklist in `references/checklist.md`. Key checks:

1. **Triggering** — description has specific trigger phrases in third person
2. **Conciseness** — SKILL.md body under 500 lines, no redundant explanations
3. **Progressive disclosure** — detailed content in references, not SKILL.md
4. **References exist** — all files mentioned in SKILL.md actually exist
5. **Writing style** — imperative form throughout body, third person in description
6. **No anti-patterns** — no Windows paths, no vague names, no time-sensitive info

### Step 7: Test

Test the skill with real queries:
- **Triggering tests**: Does it trigger on obvious tasks? Paraphrased requests? NOT on unrelated topics?
- **Functional tests**: Does it produce correct outputs? Handle edge cases?
- **Performance comparison**: Fewer tool calls, less user correction vs. without the skill?

Test with the models users will use — Haiku needs more guidance, Opus needs less explaining.

### Step 8: Iterate

Skills are living documents. Watch for:
- **Under-triggering**: Add more trigger phrases and keywords to description
- **Over-triggering**: Add negative triggers, be more specific
- **Ignored content**: If Claude never accesses a file, it may be unnecessary or poorly signaled
- **Overreliance**: If Claude repeatedly reads one reference file, its content may belong in SKILL.md

## Workflow Patterns for Complex Skills

For skills with multi-step workflows, provide checklists Claude can track:

```markdown
## Workflow

Task Progress:
- [ ] Step 1: Analyze input
- [ ] Step 2: Generate plan
- [ ] Step 3: Validate plan
- [ ] Step 4: Execute
- [ ] Step 5: Verify output
```

For quality-critical tasks, implement feedback loops: run validator → fix errors → repeat.

For destructive/batch operations, use plan-validate-execute: create intermediate plan file → validate with script → execute only after validation passes.

## Additional Resources

### Best Practices Reference

For comprehensive best practices synthesized from official Anthropic documentation, see `references/best-practices.md`. Covers:
- Description writing with examples
- Progressive disclosure patterns
- Content guidelines (terminology, time-sensitivity)
- Common patterns (template, examples, conditional workflow)
- Anti-patterns to avoid
- Evaluation-driven development
- Executable scripts best practices

### Validation Checklist

For a complete pre-publish checklist, see `references/checklist.md`.
