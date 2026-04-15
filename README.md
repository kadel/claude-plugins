# claude-plugins

A collection of Claude Code plugins for development workflows.

## Installation

### Claude Code

**From marketplace:**
```bash
/plugin marketplace add kadel/claude-plugins

/plugin install rhdh-plugin-dev@claude-plugins
/plugin install rhdh-context@claude-plugins
/plugin install review@claude-plugins
/plugin install jira-utils@claude-plugins
```

**Local development:**
```bash
claude --plugin-dir ./plugins/rhdh-plugin-dev
claude --plugin-dir ./plugins/rhdh-context
claude --plugin-dir ./plugins/review
claude --plugin-dir ./plugins/jira-utils
```

### Install individual skills

Install skills using [skills](https://github.com/vercel-labs/skills) CLI.

**Interactive mode** — browse and select skills to install:
```bash
npx skills add kadel/claude-plugins
```

**Install a specific skill:**
```bash
npx skills add kadel/claude-plugins --skill use-jira-cli
```

## Skills

| Skill | Description | Install |
|-------|-------------|---------|
| [use-jira-cli](plugins/jira-utils/skills/use-jira-cli/SKILL.md) | Interact with Jira issues, sprints, and projects via CLI | `npx skills add kadel/claude-plugins --skill use-jira-cli` |
| [md-to-jira](plugins/jira-utils/skills/md-to-jira/SKILL.md) | Convert Markdown to Jira wiki markup syntax for Jira and Confluence | `npx skills add kadel/claude-plugins --skill md-to-jira` |
| [rhdh-backend-dynamic-plugin](plugins/rhdh-plugin-dev/skills/rhdh-backend-dynamic-plugin/SKILL.md) | Bootstrap backend dynamic plugins for RHDH | `npx skills add kadel/claude-plugins --skill rhdh-backend-dynamic-plugin` |
| [rhdh-frontend-dynamic-plugin](plugins/rhdh-plugin-dev/skills/rhdh-frontend-dynamic-plugin/SKILL.md) | Bootstrap frontend dynamic plugins for RHDH | `npx skills add kadel/claude-plugins --skill rhdh-frontend-dynamic-plugin` |
| [generate-frontend-wiring](plugins/rhdh-plugin-dev/skills/generate-frontend-wiring/SKILL.md) | Generate RHDH wiring config for Backstage frontend plugins | `npx skills add kadel/claude-plugins --skill generate-frontend-wiring` |
| [backstage-cr](plugins/rhdh-plugin-dev/skills/backstage-cr/SKILL.md) | Create and configure Backstage Custom Resources for rhdh-operator | `npx skills add kadel/claude-plugins --skill backstage-cr` |
| [rhdh-catalog-index](plugins/rhdh-plugin-dev/skills/rhdh-catalog-index/SKILL.md) | Extract and inspect the RHDH plugin catalog index OCI image | `npx skills add kadel/claude-plugins --skill rhdh-catalog-index` |
| [rhdh-context](plugins/rhdh-context/skills/rhdh-context/SKILL.md) | RHDH product context — what it is, how it differs from Backstage, key nuances | `npx skills add kadel/claude-plugins --skill rhdh-context` |
| [documentation](plugins/review/skills/documentation/SKILL.md) | Review documentation changes in GitHub PRs for clarity and correctness | `npx skills add kadel/claude-plugins --skill documentation` |
| [git-commit](plugins/git-commit/skills/git-commit/SKILL.md) | Create well-structured git commits with meaningful messages and attribution | `npx skills add kadel/claude-plugins --skill git-commit` |

## License

MIT
