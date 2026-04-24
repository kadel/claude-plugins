---
name: gws-docs
description: "This skill should be used when the user asks to 'create a document', 'read a Google Doc', 'write to a doc', 'append text to doc', 'get document content', 'update document', or mentions Google Docs operations using the gws CLI."
version: 0.1.0
---

# Google Docs — Read and Write Documents

Requires the `gws` CLI on `$PATH`. Authenticate with `gws auth login` before first use.

```bash
gws docs <resource> <method> [flags]
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

## Helper Commands

### +write — Append text to a document

```bash
gws docs +write --document <ID> --text <TEXT>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--document` | yes | — | Document ID |
| `--text` | yes | — | Text to append (plain text) |

```bash
gws docs +write --document DOC_ID --text 'Hello, world!'
```

Text is inserted at the end of the document body. For rich formatting, use the raw `batchUpdate` API instead.

> **WRITE command** — confirm with the user before executing.

## Raw API Resources

For operations not covered by helper commands, use the raw API:

```bash
gws schema docs.<resource>.<method>
```

### documents

- `batchUpdate` — Apply one or more updates to the document. Each request is validated before being applied. If any request is invalid, the entire request fails and nothing is applied. Some requests return replies with information about how they were applied.
- `create` — Create a blank document using the title given in the request. Other fields (including content) are ignored. Returns the created document.
- `get` — Get the latest version of the specified document.

## Common Workflows

### Create a new document

```bash
gws docs documents create --json '{"title": "Meeting Notes"}'
```

### Read a document

```bash
gws docs documents get --params '{"documentId": "DOC_ID"}'
```

### Append text

```bash
gws docs +write --document DOC_ID --text 'New section content here'
```

### Rich formatting with batchUpdate

Use `gws schema docs.documents.batchUpdate` to inspect the available request types, then build a request body:

```bash
gws docs documents batchUpdate \
  --params '{"documentId": "DOC_ID"}' \
  --json '{
    "requests": [
      {
        "insertText": {
          "location": {"index": 1},
          "text": "Hello World\n"
        }
      }
    ]
  }'
```

## Shell Tips

Wrap `--params` and `--json` values in single quotes so the shell does not interpret inner double quotes:

```bash
gws docs documents get --params '{"documentId": "DOC_ID"}'
```
