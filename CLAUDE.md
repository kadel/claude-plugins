# Claude Code Plugins Repository

This repository contains Claude Code plugins that extend Claude's capabilities with specialized workflows and domain knowledge.

## Repository Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Plugin registry configuration
├── plugins/
│   ├── address-pr-comments/  # Address GitHub PR review comments
│   ├── ghostty/              # Ghostty terminal control via AppleScript
│   ├── git-commit/           # Git commit workflow
│   ├── gws/                  # Google Workspace CLI (Gmail, Docs, Sheets, Drive)
│   ├── jira-utils/           # Jira CLI utilities
│   ├── obsidian/             # Obsidian vault — CLI, notes, knowledge base
│   ├── review/               # Documentation review for PRs
│   ├── rhdh-context/         # RHDH product context and nuances
│   └── rhdh-plugin-dev/      # RHDH dynamic plugin development
├── CLAUDE.md                 # This file
└── README.md                 # User-facing documentation
```

## Plugin Development Guidelines

### Skill Structure

Each skill follows this structure:
```
skill-name/
├── SKILL.md           # Required: Core workflow (1,500-2,000 words ideal)
├── references/        # Optional: Detailed documentation
└── examples/          # Optional: Working examples
```

### SKILL.md Requirements

1. **Frontmatter**: Must include `name`, `description`, `version`
2. **Description**: Use third person with trigger phrases
   - Good: "This skill should be used when the user asks to..."
   - Include specific phrases: "create X", "bootstrap Y"
3. **Body**: Use imperative form, not second person
   - Good: "Create the plugin using..."
   - Bad: "You should create the plugin..."

### Progressive Disclosure

- Keep SKILL.md lean (under 3,000 words)
- Move detailed content to `references/`
- Put working code in `examples/`

## Available Plugins

### address-pr-comments
Address GitHub PR review comments:
- **address-pr-comments**: Assess validity of review comments, make fixes, reply, resolve threads, and commit changes

### ghostty
Ghostty terminal control via AppleScript:
- **ghostty-applescript**: Open splits, render markdown with glow, and send commands to terminal panes

### rhdh-plugin-dev
Red Hat Developer Hub (RHDH) dynamic plugin development:
- **rhdh-backend-dynamic-plugin**: Backend plugins, scaffolder actions, processors
- **rhdh-frontend-dynamic-plugin**: Frontend plugins, UI components, themes
- **generate-frontend-wiring**: Analyze existing plugins and generate RHDH wiring configuration
- **rhdh-catalog-index**: Extract and inspect the RHDH plugin catalog index OCI image for plugin discovery

### rhdh-context
RHDH product context and background knowledge:
- **rhdh-context**: What RHDH is, how it differs from Backstage, dynamic plugins, deployment model, version compatibility, and common nuances

### review
Documentation review for pull requests:
- **documentation**: Review documentation changes in GitHub PRs for clarity and technical correctness

### git-commit
Git commit workflow:
- **git-commit**: Create well-structured git commits with meaningful messages, proper attribution, and sign-off

### jira-utils
Jira CLI utilities for issue and project management:
- **use-jira-cli**: Interact with Jira issues, sprints, epics using the `jira` CLI (non-interactive mode only)
- **md-to-jira**: Convert GitHub-flavored Markdown to Jira wiki markup for use in Jira and Confluence

### gws
Google Workspace CLI for Gmail, Docs, Sheets, Drive, and Calendar:
- **gws-gmail**: Send, read, triage, reply, forward, and watch emails
- **gws-docs**: Create, read, and write Google Docs
- **gws-sheets**: Read, append, create, and update Google Sheets
- **gws-drive**: Upload, list, search, download, share files, manage permissions and shared drives
- **gws-calendar**: View agenda, create events, manage calendars, check free/busy

### obsidian
Obsidian vault — CLI, notes, knowledge base:
- **obsidian-cli**: Create, read, search, and manage notes, tags, properties, tasks, daily notes, plugins, sync, and more
- **obsidian-notes**: Understand vault organization and work with notes — references vault's own organization docs
- **obsidian-knowledge-base**: LLM-maintained knowledge base — references vault's `Knowledge Base.md` for all conventions and workflows

## Testing Plugins Locally

```bash
# Test a specific plugin
claude --plugin-dir ./plugins/rhdh-plugin-dev

# Test with verbose output
claude --plugin-dir ./plugins/rhdh-plugin-dev --verbose
```

## Adding a New Plugin

1. Create plugin directory: `plugins/<plugin-name>/`
2. Add skills: `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`
3. Register in `.claude-plugin/marketplace.json`
4. Update `README.md` with usage examples

## Conventions

- Plugin names: kebab-case (`my-plugin`)
- Skill names: kebab-case (`my-skill`)
- Version format: semver (`0.1.0`)
- License: MIT (unless specified otherwise)
