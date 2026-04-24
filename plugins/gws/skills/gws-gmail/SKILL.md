---
name: gws-gmail
description: "This skill should be used when the user asks to 'send email', 'read email', 'check inbox', 'reply to email', 'forward email', 'triage emails', 'watch for emails', 'manage Gmail', 'list messages', 'search email', or mentions Gmail operations using the gws CLI."
version: 0.1.0
---

# Gmail — Send, Read, and Manage Email

Requires the `gws` CLI on `$PATH`. Authenticate with `gws auth login` before first use.

```bash
gws gmail <resource> <method> [flags]
```

## Security Rules

- Never output secrets (API keys, tokens) directly.
- Always confirm with user before executing write/delete commands.
- Prefer `--dry-run` for destructive operations.

## Global Flags

| Flag | Description |
|------|-------------|
| `--format <FORMAT>` | Output format: `json` (default), `table`, `yaml`, `csv` |
| `--dry-run` | Validate locally without calling the API |
| `--params '{"key": "val"}'` | URL/query parameters |
| `--json '{"key": "val"}'` | Request body |
| `--page-all` | Auto-paginate (NDJSON output) |

## Helper Commands

### +send — Send an email

```bash
gws gmail +send --to <EMAILS> --subject <SUBJECT> --body <TEXT>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--to` | yes | — | Recipient email(s), comma-separated |
| `--subject` | yes | — | Email subject |
| `--body` | yes | — | Email body (plain text, or HTML with --html) |
| `--from` | — | — | Sender address (for send-as/alias) |
| `--cc` | — | — | CC email(s), comma-separated |
| `--bcc` | — | — | BCC email(s), comma-separated |
| `--attach` | — | — | Attach a file (repeatable, 25MB total limit) |
| `--html` | — | — | Treat --body as HTML (use fragment tags, no wrapper needed) |
| `--draft` | — | — | Save as draft instead of sending |
| `--dry-run` | — | — | Preview without sending |

```bash
gws gmail +send --to alice@example.com --subject 'Hello' --body 'Hi Alice!'
gws gmail +send --to alice@example.com --subject 'Report' --body 'See attached' -a report.pdf
gws gmail +send --to alice@example.com --subject 'Hello' --body '<b>Bold</b>' --html
gws gmail +send --to alice@example.com --subject 'Hello' --body 'Hi!' --draft
```

> **WRITE command** — confirm with the user before executing.

### +triage — Show unread inbox summary

```bash
gws gmail +triage
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--max` | — | 20 | Maximum messages to show |
| `--query` | — | is:unread | Gmail search query |
| `--labels` | — | — | Include label names in output |

```bash
gws gmail +triage
gws gmail +triage --max 5 --query 'from:boss'
gws gmail +triage --format json | jq '.[].subject'
```

Read-only — never modifies the mailbox. Defaults to table output.

### +read — Read a message body or headers

```bash
gws gmail +read --id <ID>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--id` | yes | — | Gmail message ID to read |
| `--headers` | — | — | Include headers (From, To, Subject, Date) |
| `--format` | — | text | Output format (text, json) |
| `--html` | — | — | Return HTML body instead of plain text |

```bash
gws gmail +read --id 18f1a2b3c4d
gws gmail +read --id 18f1a2b3c4d --headers
gws gmail +read --id 18f1a2b3c4d --format json | jq '.body'
```

Converts HTML-only messages to plain text automatically. Handles multipart/alternative and base64 decoding.

### +reply — Reply to a message

```bash
gws gmail +reply --message-id <ID> --body <TEXT>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--message-id` | yes | — | Gmail message ID to reply to |
| `--body` | yes | — | Reply body (plain text, or HTML with --html) |
| `--from` | — | — | Sender address (for send-as/alias) |
| `--to` | — | — | Additional To email(s) |
| `--cc` | — | — | CC email(s), comma-separated |
| `--bcc` | — | — | BCC email(s), comma-separated |
| `--attach` | — | — | Attach a file (repeatable) |
| `--html` | — | — | Treat --body as HTML |
| `--draft` | — | — | Save as draft instead of sending |

```bash
gws gmail +reply --message-id 18f1a2b3c4d --body 'Thanks, got it!'
gws gmail +reply --message-id 18f1a2b3c4d --body 'Looping in Carol' --cc carol@example.com
```

Automatically sets In-Reply-To, References, and threadId headers. Quotes the original message.

> **WRITE command** — confirm with the user before executing.

### +reply-all — Reply-all to a message

```bash
gws gmail +reply-all --message-id <ID> --body <TEXT>
```

Same flags as `+reply`, plus:

| Flag | Description |
|------|-------------|
| `--remove` | Exclude recipients from the outgoing reply (comma-separated emails) |

```bash
gws gmail +reply-all --message-id 18f1a2b3c4d --body 'Sounds good!'
gws gmail +reply-all --message-id 18f1a2b3c4d --body 'Updated' --remove bob@example.com
```

Replies to the sender and all original To/CC recipients. Fails if no To recipient remains after exclusions.

> **WRITE command** — confirm with the user before executing.

### +forward — Forward a message

```bash
gws gmail +forward --message-id <ID> --to <EMAILS>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--message-id` | yes | — | Gmail message ID to forward |
| `--to` | yes | — | Recipient email(s), comma-separated |
| `--body` | — | — | Note to include above forwarded message |
| `--from` | — | — | Sender address (for send-as/alias) |
| `--cc` | — | — | CC email(s), comma-separated |
| `--bcc` | — | — | BCC email(s), comma-separated |
| `--attach` | — | — | Attach extra files (repeatable) |
| `--no-original-attachments` | — | — | Exclude original message's attachments |
| `--html` | — | — | Treat --body as HTML |
| `--draft` | — | — | Save as draft instead of sending |

```bash
gws gmail +forward --message-id 18f1a2b3c4d --to dave@example.com
gws gmail +forward --message-id 18f1a2b3c4d --to dave@example.com --body 'FYI see below'
```

Original attachments are included by default. Combined size limit: 25MB.

> **WRITE command** — confirm with the user before executing.

### +watch — Watch for new emails (streaming)

```bash
gws gmail +watch --project <GCP_PROJECT_ID>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--project` | — | — | GCP project ID for Pub/Sub resources |
| `--subscription` | — | — | Existing Pub/Sub subscription name (skip setup) |
| `--topic` | — | — | Existing Pub/Sub topic with Gmail push permission |
| `--label-ids` | — | — | Comma-separated Gmail label IDs to filter |
| `--max-messages` | — | 10 | Max messages per pull batch |
| `--poll-interval` | — | 5 | Seconds between pulls |
| `--msg-format` | — | full | Gmail message format: full, metadata, minimal, raw |
| `--once` | — | — | Pull once and exit |
| `--cleanup` | — | — | Delete created Pub/Sub resources on exit |
| `--output-dir` | — | — | Write each message to a separate JSON file |

```bash
gws gmail +watch --project my-gcp-project
gws gmail +watch --project my-project --label-ids INBOX --once
gws gmail +watch --project my-project --cleanup --output-dir ./emails
```

Gmail watch expires after 7 days — re-run to renew. Press Ctrl-C to stop.

## Raw API Resources

For operations not covered by helper commands, use the raw API:

```bash
gws schema gmail.<resource>.<method>
```

### users

- `getProfile` — Get current user's Gmail profile
- `stop` — Stop push notification watch
- `watch` — Set up push notification watch
- `drafts` — Operations on drafts
- `history` — Operations on history
- `labels` — Operations on labels
- `messages` — Operations on messages
- `settings` — Operations on settings
- `threads` — Operations on threads

## Shell Tips

Wrap `--params` and `--json` values in single quotes so the shell does not interpret inner double quotes:

```bash
gws gmail users messages list --params '{"maxResults": 5, "q": "is:unread"}'
```
