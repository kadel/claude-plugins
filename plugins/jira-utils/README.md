# Jira Utils

Claude Code plugin for interacting with Jira using the Jira CLI (`jira`).

## Skills

### Use Jira CLI (`use-jira-cli`)

Use the Jira CLI to interact with Jira issues, sprints, epics, and projects from the command line.

**Trigger phrases:**
- "Interact with Jira"
- "List Jira issues"
- "Create Jira issue"
- "Manage sprints"
- "View epics"
- "Search issues"
- "Move issue status"
- "Assign issue"

**What it covers:**
- Issue management (list, create, view, edit, move, assign)
- Sprint management (list sprints, view current sprint)
- Epic management (list epics, add issues to epics)
- Board operations
- Non-interactive output formats (`--plain`, `--raw`, `--csv`)

## Prerequisites

1. **Install Jira CLI**: https://github.com/ankitpokhrel/jira-cli
   ```bash
   # macOS
   brew install ankitpokhrel/jira-cli/jira-cli

   # or via Go
   go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
   ```

2. **Configure Jira CLI**:
   ```bash
   # Set API token
   export JIRA_API_TOKEN="your-api-token"

   # Initialize configuration
   jira init
   ```

## Important: Non-Interactive Mode

This skill always uses non-interactive output modes:
- `--plain` for readable text output (default)
- `--raw` for JSON output when detailed data is needed
- `--no-input` for commands that would otherwise prompt for input

Interactive mode is never used as it requires user input and will hang.

## Quick Examples

```bash
# List issues assigned to you
jira issue list -a$(jira me) --plain

# View issue details
jira issue view PROJ-123 --plain

# Create an issue
jira issue create -t"Bug" -s"Fix login error" -b"Description" --no-input

# Move issue to Done
jira issue move PROJ-123 "Done"

# View current sprint
jira sprint list --current --plain

# Get issue as JSON for parsing
jira issue view PROJ-123 --raw
```

## Resources

- [Jira CLI GitHub](https://github.com/ankitpokhrel/jira-cli)
- [Jira CLI Documentation](https://github.com/ankitpokhrel/jira-cli#readme)
