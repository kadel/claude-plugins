# claude-plugins

A collection of Claude Code plugins for development workflows.

## Installation

### Claude Code

**From marketplace:**
```bash
/plugin marketplace add kadel/claude-plugins

/plugin install worktree-feature@claude-plugins
/plugin install rhdh-plugin-dev@claude-plugins
/plugin install rhdh-context@claude-plugins
/plugin install review@claude-plugins
/plugin install jira-utils@claude-plugins
```

**Local development:**
```bash
claude --plugin-dir ./plugins/worktree-feature
claude --plugin-dir ./plugins/rhdh-plugin-dev
claude --plugin-dir ./plugins/rhdh-context
claude --plugin-dir ./plugins/review
claude --plugin-dir ./plugins/jira-utils
```

### Install individual skills

Install skills directly using [skillmanager](https://github.com/kadel/skillmanager):

```bash
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/worktree-feature/skills/worktree-feature
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/jira-utils/skills/use-jira-cli
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/rhdh-plugin-dev/skills/rhdh-backend-dynamic-plugin
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/rhdh-plugin-dev/skills/rhdh-frontend-dynamic-plugin
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/rhdh-plugin-dev/skills/generate-frontend-wiring
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/rhdh-plugin-dev/skills/backstage-cr
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/rhdh-context/skills/rhdh-context
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/review/skills/documentation
npx @tomaskral/skillmanager@latest install https://github.com/kadel/claude-plugins/tree/main/plugins/git-commit/skills/git-commit
```

Update all installed skills:

```bash
npx @tomaskral/skillmanager@latest update --all
```

## Skills

| Skill | Description |
|-------|-------------|
| [worktree-feature](plugins/worktree-feature/skills/worktree-feature/SKILL.md) | Git worktree for isolated feature development |
| [use-jira-cli](plugins/jira-utils/skills/use-jira-cli/SKILL.md) | Interact with Jira issues, sprints, and projects via CLI |
| [rhdh-backend-dynamic-plugin](plugins/rhdh-plugin-dev/skills/rhdh-backend-dynamic-plugin/SKILL.md) | Bootstrap backend dynamic plugins for RHDH |
| [rhdh-frontend-dynamic-plugin](plugins/rhdh-plugin-dev/skills/rhdh-frontend-dynamic-plugin/SKILL.md) | Bootstrap frontend dynamic plugins for RHDH |
| [generate-frontend-wiring](plugins/rhdh-plugin-dev/skills/generate-frontend-wiring/SKILL.md) | Generate RHDH wiring config for Backstage frontend plugins |
| [backstage-cr](plugins/rhdh-plugin-dev/skills/backstage-cr/SKILL.md) | Create and configure Backstage Custom Resources for rhdh-operator |
| [rhdh-context](plugins/rhdh-context/skills/rhdh-context/SKILL.md) | RHDH product context — what it is, how it differs from Backstage, key nuances |
| [documentation](plugins/review/skills/documentation/SKILL.md) | Review documentation changes in GitHub PRs for clarity and correctness |
| [git-commit](plugins/git-commit/skills/git-commit/SKILL.md) | Create well-structured git commits with meaningful messages and attribution |

## License

MIT
