# Skill Validation Checklist

Use this checklist to validate a skill before sharing or deploying.

## Structure

- [ ] Skill folder named in kebab-case (no spaces, underscores, or capitals)
- [ ] SKILL.md file exists with exact spelling (not SKILL.MD, skill.md, etc.)
- [ ] YAML frontmatter has `---` delimiters on both sides
- [ ] `name` field: kebab-case, no spaces, no capitals, matches folder name exactly
- [ ] `name` field: max 64 characters, unique within repository
- [ ] `description` field: non-empty, max 1024 characters
- [ ] `metadata.version`: semver format if included (e.g., `metadata:\n  version: "0.1.0"`)
- [ ] No XML angle brackets (< >) in frontmatter
- [ ] No harness-specific fields (e.g., `model`, `argument-hint`, `allowed-tools`)
- [ ] No README.md inside skill folder
- [ ] Only necessary subdirectories created (`references/`, `scripts/`, `examples/`, `assets/`)

## Description Quality

- [ ] Uses third person ("This skill should be used when the user asks to...")
- [ ] Includes specific trigger phrases in quotes
- [ ] Lists concrete scenarios ("create X", "configure Y", "analyze Z")
- [ ] Mentions relevant file types if applicable
- [ ] Includes negative triggers if over-triggering is a risk
- [ ] Follows formula: [What it does] + [When to use it] + [Key capabilities]
- [ ] Not vague or generic
- [ ] Under 1024 characters

## Content Quality

- [ ] SKILL.md body uses imperative/infinitive form (not second person)
- [ ] Body is under 500 lines (~2,000 words)
- [ ] Only includes information the agent does not already know
- [ ] Provides default approaches, not menus of options
- [ ] Uses consistent terminology throughout
- [ ] No time-sensitive information (or in "old patterns" section)
- [ ] Examples are concrete, not abstract
- [ ] Critical constraints use strong language (MUST, NEVER)

## Progressive Disclosure

- [ ] Core concepts and workflow in SKILL.md
- [ ] Detailed documentation in references/
- [ ] Working code in examples/
- [ ] Utility scripts in scripts/
- [ ] SKILL.md clearly references all bundled resources
- [ ] File references are one level deep (no chains)
- [ ] Reference files over 100 lines have table of contents
- [ ] No duplicated information across files

## Scripts and Code (if applicable)

- [ ] Scripts handle errors explicitly (don't punt to the agent)
- [ ] No magic numbers (all values documented)
- [ ] Required packages listed in instructions
- [ ] Execution vs. read intent clear in SKILL.md
- [ ] Validation/verification steps for critical operations
- [ ] No Windows-style paths (all forward slashes)
- [ ] MCP tools use fully qualified names (ServerName:tool_name)

## Testing & Tooling

- [ ] Discovered cleanly with `npx skills add . --list`
- [ ] Validated installation in a temporary directory outside the repository
- [ ] Triggers on obvious tasks
- [ ] Triggers on paraphrased requests
- [ ] Does NOT trigger on unrelated topics
- [ ] Functional tests produce correct outputs
- [ ] Tested with intended coding agent(s) (e.g., Claude Code, Codex, etc.)
- [ ] Tested with real usage scenarios

## Post-Deploy

- [ ] Monitor for under/over-triggering
- [ ] Collect user feedback
- [ ] Iterate on description and instructions
- [ ] Update version in metadata when making changes
