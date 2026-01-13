# Claude Code Plugins Repository

This repository contains Claude Code plugins that extend Claude's capabilities with specialized workflows and domain knowledge.

## Repository Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Plugin registry configuration
├── plugins/
│   ├── worktree-feature/     # Git worktree workflow plugin
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

### worktree-feature
Git worktree workflow for isolated feature development.

### rhdh-plugin-dev
Red Hat Developer Hub (RHDH) dynamic plugin development:
- **rhdh-backend-dynamic-plugin**: Backend plugins, scaffolder actions, processors
- **rhdh-frontend-dynamic-plugin**: Frontend plugins, UI components, themes
- **generate-frontend-wiring**: Analyze existing plugins and generate RHDH wiring configuration

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
