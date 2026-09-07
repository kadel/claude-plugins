# Agent Skills

A collection of agent-neutral skills following the [Agent Skills specification](https://agentskills.io) and managed with [`npx skills`](https://github.com/vercel-labs/skills).

These skills enhance AI coding assistants (such as Claude Code, Codex, and others) with domain knowledge, specialized workflows, and CLI integrations.

## Installation & Usage

Skills are installed and managed using `npx skills`. By default, skills install to the current project directory. Use `-g` to install globally, and `-a` to select specific target agents (e.g., `claude-code`, `codex`).

```bash
# Discover available skills in this collection
npx skills add kadel/skills --list

# Choose skills interactively
npx skills add kadel/skills

# Install a specific skill for the current project
npx skills add kadel/skills --skill commit

# Install globally for selected agents
npx skills add kadel/skills --skill commit -g -a claude-code codex

# List installed skills
npx skills list

# Update installed skills to latest versions
npx skills update

# Remove an installed skill
npx skills remove commit
```

## Available Skills

All 22 skills live as independent directories at the repository root:

| Skill | Description |
|---|---|
| [`address-pr-comments`](address-pr-comments/SKILL.md) | Address code review comments with technical rigor, verification, and critical thinking rather than performative agreement. |
| [`backstage-custom-resource`](backstage-custom-resource/SKILL.md) | Create and configure `Backstage` Custom Resources (CR) for deploying RHDH via the `rhdh-operator` across API versions `v1alpha3`–`v1alpha5`. |
| [`commit`](commit/SKILL.md) | Guide structured Git commits with meaningful messages, explicit staging, sign-offs, and appropriate harness attribution. |
| [`create-skill`](create-skill/SKILL.md) | Guide creation of agent-neutral skills following the Agent Skills specification, progressive disclosure, and validation rules. |
| [`generate-frontend-wiring`](generate-frontend-wiring/SKILL.md) | Generate frontend dynamic plugin configuration for RHDH, including mount points, routes, and menu items. |
| [`ghostty`](ghostty/SKILL.md) | Control the Ghostty terminal emulator on macOS via AppleScript to open splits and display markdown previews. |
| [`grill-me`](grill-me/SKILL.md) | Rigorously stress-test and challenge plans, designs, and architectures through one-by-one interviewing questions. |
| [`gws-calendar`](gws-calendar/SKILL.md) | Manage Google Calendar events, agendas, and schedules via the `gws` CLI. |
| [`gws-docs`](gws-docs/SKILL.md) | Read, create, and append text to Google Docs documents via the `gws` CLI. |
| [`gws-drive`](gws-drive/SKILL.md) | Upload, search, share, and organize Google Drive files, folders, and shared drives via the `gws` CLI. |
| [`gws-gmail`](gws-gmail/SKILL.md) | Read, draft, send, search, and triage emails via the `gws` CLI. |
| [`gws-sheets`](gws-sheets/SKILL.md) | Read, create, append rows to, and update cells in Google Sheets spreadsheets via the `gws` CLI. |
| [`md-to-jira`](md-to-jira/SKILL.md) | Convert Markdown text into Jira wiki markup syntax for tickets, comments, or Jira CLI input. |
| [`obsidian-cli`](obsidian-cli/SKILL.md) | Interact with Obsidian vaults via the `obsidian` CLI for note management, search, tags, tasks, and daily notes. |
| [`obsidian-knowledge-base`](obsidian-knowledge-base/SKILL.md) | Query, ingest sources into, and maintain an interlinked knowledge base inside an Obsidian vault. |
| [`obsidian-notes`](obsidian-notes/SKILL.md) | Navigate vault structure and adhere to organization and frontmatter rules before creating or updating Obsidian notes. |
| [`review-documentation`](review-documentation/SKILL.md) | Review documentation changes in pull requests for ease of understanding, technical accuracy, and structural clarity. |
| [`rhdh-backend-dynamic-plugin-bootstrap`](rhdh-backend-dynamic-plugin-bootstrap/SKILL.md) | Bootstrap, export, package, and configure backend dynamic plugins for Red Hat Developer Hub. |
| [`rhdh-catalog-index`](rhdh-catalog-index/SKILL.md) | Extract and inspect the RHDH catalog index OCI image to discover dynamic plugins and configuration schemas. |
| [`rhdh-context`](rhdh-context/SKILL.md) | Essential architectural context on Red Hat Developer Hub, upstream Backstage differences, and plugin runtime nuances. |
| [`rhdh-frontend-dynamic-plugin-bootstrap`](rhdh-frontend-dynamic-plugin-bootstrap/SKILL.md) | Bootstrap, develop, build, package, and configure frontend dynamic plugins for Red Hat Developer Hub. |
| [`use-jira-cli`](use-jira-cli/SKILL.md) | Manage Jira issues, sprints, epics, and transitions from the command line using `jira-cli`. |

## Contributing

Skills in this repository are agent-neutral and follow the open [Agent Skills specification](https://agentskills.io).

To scaffold a new skill in this repository:

```bash
npx skills init <skill-name>
```

Guidelines:
- Each skill must reside in its own root directory matching its canonical frontmatter `name`: `<name>/SKILL.md`.
- Keep skills self-contained; place supporting files in subdirectories (`references/`, `scripts/`, `examples/`).
- Do not introduce plugin wrapper directories, marketplaces, or client-specific frontmatter fields (`model`, `argument-hint`, `allowed-tools`).
- Put version numbers under `metadata.version` (e.g. `metadata:\n  version: "0.1.0"`).
- Always update this README table when adding or renaming a skill.
- See [`create-skill/SKILL.md`](create-skill/SKILL.md) and [`AGENTS.md`](AGENTS.md) for full instructions and best practices.

## Migration Guide

This repository was reorganized from a Claude Code plugin collection (`kadel/claude-plugins`) into a multi-agent skill collection (`kadel/skills`).

### For Existing Plugin Users

If you previously installed these as Claude Code plugins via `/plugin`:
1. Remove old plugin installations using your client's plugin removal command.
2. Reinstall desired skills using `npx skills`:
   ```bash
   npx skills add kadel/skills --skill <canonical-name> -a claude-code
   ```

### For Existing `npx skills` Users

If you previously installed skills pointing to historical nested paths (e.g., `plugins/...`):
1. Re-add skills from `kadel/skills` so paths and sources resolve cleanly:
   ```bash
   npx skills add kadel/skills --skill <canonical-name>
   ```

### Renamed Skills

Six skills have been updated to their canonical names. When specifying `--skill`, use the new canonical name:

| Old Historical Directory | New Canonical Name |
|---|---|
| `backstage-cr` | `backstage-custom-resource` |
| `git-commit` | `commit` |
| `ghostty-applescript` | `ghostty` |
| `documentation` | `review-documentation` |
| `rhdh-backend-dynamic-plugin` | `rhdh-backend-dynamic-plugin-bootstrap` |
| `rhdh-frontend-dynamic-plugin` | `rhdh-frontend-dynamic-plugin-bootstrap` |

## License

MIT
