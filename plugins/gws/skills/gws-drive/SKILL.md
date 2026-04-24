---
name: gws-drive
description: "This skill should be used when the user asks to 'upload file', 'list files', 'search Drive', 'share file', 'create folder', 'download file', 'manage permissions', 'manage shared drives', or mentions Google Drive operations using the gws CLI."
version: 0.1.0
---

# Google Drive — Manage Files, Folders, and Shared Drives

Requires the `gws` CLI on `$PATH`. Authenticate with `gws auth login` before first use.

```bash
gws drive <resource> <method> [flags]
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
| `-o, --output <PATH>` | Save binary responses to file |
| `--upload <PATH>` | Upload file content (multipart) |
| `--page-all` | Auto-paginate (NDJSON output) |
| `--page-limit <N>` | Max pages when using --page-all (default: 10) |

## Helper Commands

### +upload — Upload a file with automatic metadata

```bash
gws drive +upload <file>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `<file>` | yes | — | Path to file to upload |
| `--parent` | — | — | Parent folder ID |
| `--name` | — | — | Target filename (defaults to source filename) |

```bash
gws drive +upload ./report.pdf
gws drive +upload ./report.pdf --parent FOLDER_ID
gws drive +upload ./data.csv --name 'Sales Data.csv'
```

MIME type is detected automatically. Filename is inferred from the local path unless `--name` is given.

> **WRITE command** — confirm with the user before executing.

## Raw API Resources

For operations not covered by helper commands, use the raw API:

```bash
gws schema drive.<resource>.<method>
```

### files

- `list` — List files. Accepts `q` parameter for search queries. Returns all files including trashed by default; use `trashed=false` to exclude.
- `get` — Get file metadata or content by ID. Use `alt=media` to download content.
- `create` — Create a file. Supports upload via `--upload`. Max file size: 5,120 GB.
- `copy` — Copy a file with patch semantics.
- `update` — Update file metadata, content, or both. Supports `--upload`.
- `download` — Download file content. Operations valid for 24 hours.
- `export` — Export Google Workspace documents to requested MIME type. Limited to 10 MB.
- `generateIds` — Generate file IDs for use in create/copy requests.
- `listLabels` — List labels on a file.
- `modifyLabels` — Modify labels applied to a file.
- `watch` — Subscribe to changes to a file.

### permissions

- `create` — Create a permission for a file or shared drive. Warning: concurrent permission operations on the same file are not supported.
- `delete` — Delete a permission.
- `get` — Get a permission by ID.
- `list` — List permissions on a file or shared drive.
- `update` — Update a permission with patch semantics.

### drives (shared drives)

- `create` — Create a shared drive.
- `get` — Get shared drive metadata by ID.
- `list` — List the user's shared drives. Accepts `q` parameter for search.
- `hide` — Hide a shared drive from the default view.
- `unhide` — Restore a shared drive to the default view.
- `update` — Update shared drive metadata.

### comments

- `create` — Create a comment on a file.
- `delete` — Delete a comment.
- `get` — Get a comment by ID.
- `list` — List comments on a file.
- `update` — Update a comment.

### replies

- `create` — Create a reply to a comment.
- `delete` — Delete a reply.
- `get` — Get a reply by ID.
- `list` — List replies to a comment.
- `update` — Update a reply.

### revisions

- `delete` — Delete a file version (binary content only, not Google Docs/Sheets/Slides).
- `get` — Get revision metadata or content by ID.
- `list` — List file revisions (may be incomplete for files with large revision history).
- `update` — Update a revision.

### about

- `get` — Get user info, Drive info, and system capabilities. Requires `fields` parameter.

### changes

- `getStartPageToken` — Get starting pageToken for listing future changes.
- `list` — List changes for a user or shared drive.
- `watch` — Subscribe to changes.

### accessproposals

- `get` — Get an access proposal by ID.
- `list` — List access proposals on a file (approvers only).
- `resolve` — Approve or deny an access proposal.

## Common Workflows

### List recent files

```bash
gws drive files list --params '{"pageSize": 10, "orderBy": "modifiedTime desc", "fields": "files(id,name,modifiedTime)"}'
```

### Search for files

```bash
gws drive files list --params '{"q": "name contains '\''report'\'' and mimeType = '\''application/pdf'\''", "fields": "files(id,name)"}'
```

### Upload a file to a folder

```bash
gws drive +upload ./report.pdf --parent FOLDER_ID
```

### Download a file

```bash
gws drive files get --params '{"fileId": "FILE_ID", "alt": "media"}' -o ./downloaded_file.pdf
```

### Export a Google Doc as PDF

```bash
gws drive files export --params '{"fileId": "DOC_ID", "mimeType": "application/pdf"}' -o ./document.pdf
```

### Create a folder

```bash
gws drive files create --json '{"name": "New Folder", "mimeType": "application/vnd.google-apps.folder"}'
```

### Share a file

```bash
gws drive permissions create \
  --params '{"fileId": "FILE_ID"}' \
  --json '{"role": "reader", "type": "user", "emailAddress": "user@example.com"}'
```

### List shared drives

```bash
gws drive drives list --params '{"fields": "drives(id,name)"}'
```

## Shell Tips

Wrap `--params` and `--json` values in single quotes so the shell does not interpret inner double quotes:

```bash
gws drive files list --params '{"pageSize": 5}'
```
