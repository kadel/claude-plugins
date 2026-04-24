# Google Workspace CLI

Claude Code plugin for interacting with Google Workspace services (Gmail, Docs, Sheets, Drive) using the [`gws` CLI](https://github.com/googleworkspace/cli).

## Skills

| Skill | Description |
|-------|-------------|
| `gws-gmail` | Send, read, triage, reply, forward, and watch emails |
| `gws-docs` | Create, read, and write Google Docs |
| `gws-sheets` | Read, append, create, and update Google Sheets |
| `gws-drive` | Upload, list, search, download, share files, manage permissions and shared drives |

## Prerequisites

1. **Install gws CLI**: https://github.com/googleworkspace/cli
   ```bash
   # See the gws repository for install options
   ```

2. **Authenticate**:
   ```bash
   # Browser-based OAuth (interactive)
   gws auth login

   # Or use a service account
   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
   ```

## Quick Examples

```bash
# Check unread emails
gws gmail +triage

# Send an email
gws gmail +send --to alice@example.com --subject 'Hello' --body 'Hi Alice!'

# Read a Google Doc
gws docs documents get --params '{"documentId": "DOC_ID"}'

# Read spreadsheet data
gws sheets +read --spreadsheet SHEET_ID --range "Sheet1!A1:D10"

# Upload a file to Drive
gws drive +upload ./report.pdf

# List recent files
gws drive files list --params '{"pageSize": 10, "orderBy": "modifiedTime desc", "fields": "files(id,name,modifiedTime)"}'
```

## Resources

- [gws CLI Repository](https://github.com/googleworkspace/cli)
- [Google Workspace API Documentation](https://developers.google.com/workspace)
