# claude-plugins

A collection of Claude Code plugins.

## Installation

### From GitHub (after publishing)

```bash
# Add the marketplace
/plugin marketplace add kadel/claude-plugins

# Install a plugin
/plugin install worktree-feature@claude-plugins
```

### Local Development

```bash
claude --plugin-dir ./plugins/worktree-feature
```

## Available Plugins

### worktree-feature

Start new feature development in a separate git worktree.

**Skills:**
- **Worktree Feature Development** - Creates a new git worktree with a dedicated feature branch, enabling isolated parallel development.

**Usage:**
- "Start a new feature called user-auth"
- "Create a feature branch in a worktree"
- "Set up isolated feature development"

## Adding New Plugins

1. Create a new directory under `plugins/`:
   ```
   plugins/my-plugin/
   └── skills/
       └── my-skill/
           └── SKILL.md
   ```

2. Add the plugin to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "my-plugin",
     "source": "my-plugin",
     "description": "Description of my plugin",
     "version": "0.1.0",
     "strict": false
   }
   ```

## License

MIT
