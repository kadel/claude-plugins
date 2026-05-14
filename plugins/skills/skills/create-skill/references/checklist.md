# Skill Validation Checklist

Use this checklist to validate a skill before sharing or deploying.

## Structure

- [ ] Skill folder named in kebab-case (no spaces, underscores, or capitals)
- [ ] SKILL.md file exists with exact spelling (not SKILL.MD, skill.md, etc.)
- [ ] YAML frontmatter has `---` delimiters on both sides
- [ ] `name` field: kebab-case, no spaces, no capitals, matches folder name
- [ ] `name` field: max 64 characters, no "claude" or "anthropic"
- [ ] `description` field: non-empty, max 1024 characters
- [ ] `version` field: semver format if included (optional but recommended)
- [ ] No XML angle brackets (< >) in frontmatter
- [ ] No README.md inside skill folder
- [ ] Only necessary subdirectories created (references/, scripts/, examples/, assets/)

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
- [ ] Only includes information Claude does not already know
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

- [ ] Scripts handle errors explicitly (don't punt to Claude)
- [ ] No magic numbers (all values documented)
- [ ] Required packages listed in instructions
- [ ] Execution vs. read intent clear in SKILL.md
- [ ] Validation/verification steps for critical operations
- [ ] No Windows-style paths (all forward slashes)
- [ ] MCP tools use fully qualified names (ServerName:tool_name)

## Testing

- [ ] Triggers on obvious tasks
- [ ] Triggers on paraphrased requests
- [ ] Does NOT trigger on unrelated topics
- [ ] Functional tests produce correct outputs
- [ ] Tested with intended model(s) (Haiku/Sonnet/Opus)
- [ ] Tested with real usage scenarios

## Post-Deploy

- [ ] Monitor for under/over-triggering
- [ ] Collect user feedback
- [ ] Iterate on description and instructions
- [ ] Update version in metadata
