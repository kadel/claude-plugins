# claude-plugins

A collection of Claude Code plugins for development workflows.

## Installation

### From GitHub (after publishing)

```bash
# Add the marketplace
/plugin marketplace add kadel/claude-plugins

# Install a plugin
/plugin install worktree-feature@claude-plugins
/plugin install rhdh-plugin-dev@claude-plugins
/plugin install jira-utils@claude-plugins
```

### Local Development

```bash
claude --plugin-dir ./plugins/worktree-feature
claude --plugin-dir ./plugins/rhdh-plugin-dev
claude --plugin-dir ./plugins/jira-utils
```

### Install Skills Locally

Install skills to your local AI assistant (Cursor, Claude Code, GitHub Copilot):

```bash
# Install to all supported assistants
./scripts/install-skills.sh

# Install to a specific assistant
./scripts/install-skills.sh --target cursor
./scripts/install-skills.sh --target claude
./scripts/install-skills.sh --target copilot

# Options
./scripts/install-skills.sh --force    # Overwrite existing skills
./scripts/install-skills.sh --clean    # Remove installed skills
./scripts/install-skills.sh --dry-run  # Preview changes
```

Skills are installed to:
- Cursor: `~/.cursor/skills/`
- Claude: `~/.claude/skills/`
- Copilot: `~/.copilot/skills/`

## Available Plugins

### worktree-feature

Start new feature development in a separate git worktree.

**Skills:**
- **Worktree Feature Development** - Creates a new git worktree with a dedicated feature branch, enabling isolated parallel development.

**Usage:**
- "Start a new feature called user-auth"
- "Create a feature branch in a worktree"
- "Set up isolated feature development"

---

### rhdh-plugin-dev

Bootstrap and develop dynamic plugins for Red Hat Developer Hub (RHDH/Backstage).

**Skills:**

#### RHDH Backend Dynamic Plugin Bootstrap
Create backend dynamic plugins for RHDH including API plugins, scaffolder actions, catalog processors, and backend modules.

**Usage:**
- "Create RHDH backend plugin"
- "Bootstrap backend dynamic plugin"
- "New scaffolder action for RHDH"
- "Create catalog processor"

**Covers:**
- Version compatibility (RHDH 1.5 - 1.8)
- New backend system (`createBackendPlugin`)
- Export with `@red-hat-developer-hub/cli`
- OCI image packaging
- Debugging (local and container)

#### RHDH Frontend Dynamic Plugin Bootstrap
Create frontend dynamic plugins for RHDH including UI pages, entity cards, themes, and visual customizations.

**Usage:**
- "Create RHDH frontend plugin"
- "Add entity card to RHDH"
- "Create dynamic route"
- "Configure mount points"
- "Add sidebar menu item"

**Covers:**
- Scalprum module federation
- Dynamic routes and pages
- Entity page mount points
- Menu items and icons
- Themes and customizations
- Route bindings

#### Generate Frontend Wiring
Analyze an existing Backstage frontend plugin and generate the RHDH dynamic plugin wiring configuration.

**Usage:**
- "Generate frontend wiring"
- "Show frontend wiring"
- "Create RHDH binding"
- "Generate dynamic plugin config"
- "Show plugin wiring for RHDH"
- "Create app-config for frontend plugin"

**Covers:**
- Plugin source analysis (package.json, plugin.ts, index.ts)
- Scalprum name detection
- Dynamic routes configuration
- Mount points generation
- API factories configuration
- App icons setup

---

### jira-utils

Interact with Jira using the Jira CLI from the command line.

**Skills:**
- **Use Jira CLI** - Manage Jira issues, sprints, epics, and projects using the `jira` CLI tool.

**Usage:**
- "List Jira issues"
- "Create Jira issue"
- "View issue PROJ-123"
- "Move issue to Done"
- "Show current sprint"
- "Assign issue to me"

**Prerequisites:**
- Jira CLI installed (`jira` command)
- Configured with `jira init` and `JIRA_API_TOKEN`

**Note:** Always uses non-interactive mode (`--plain` or `--raw`) to avoid hanging.

---

## Plugin Structure

```
plugins/
├── worktree-feature/
│   └── skills/
│       └── worktree-feature/
│           └── SKILL.md
├── rhdh-plugin-dev/
│   └── skills/
│       ├── rhdh-backend-dynamic-plugin/
│       │   ├── SKILL.md
│       │   ├── references/
│       │   │   ├── versions.md
│       │   │   ├── export-guide.md
│       │   │   ├── packaging-guide.md
│       │   │   └── debugging.md
│       │   └── examples/
│       │       └── dynamic-plugins.yaml
│       ├── rhdh-frontend-dynamic-plugin/
│       │   ├── SKILL.md
│       │   ├── references/
│       │   │   ├── frontend-wiring.md
│       │   │   ├── scalprum-config.md
│       │   │   └── entity-page.md
│       │   └── examples/
│       │       └── frontend-plugin-config.yaml
│       └── generate-frontend-wiring/
│           ├── SKILL.md
│           └── references/
│               ├── frontend-wiring.md
│               └── entity-page.md
└── jira-utils/
    └── skills/
        └── use-jira-cli/
            └── SKILL.md
```

## Adding New Plugins

1. Create a new directory under `plugins/`:
   ```
   plugins/my-plugin/
   └── skills/
       └── my-skill/
           ├── SKILL.md
           ├── references/    # Optional detailed docs
           └── examples/      # Optional examples
   ```

2. Add the plugin to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "my-plugin",
     "source": "my-plugin",
     "description": "Description of my plugin",
     "version": "0.1.0",
     "category": "development",
     "tags": ["tag1", "tag2"],
     "strict": false
   }
   ```

## License

MIT
