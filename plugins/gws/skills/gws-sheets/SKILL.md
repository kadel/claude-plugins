---
name: gws-sheets
description: "This skill should be used when the user asks to 'read spreadsheet', 'write to sheet', 'append row', 'create spreadsheet', 'update cells', 'get sheet data', 'read Google Sheets', or mentions Google Sheets operations using the gws CLI."
version: 0.1.0
---

# Google Sheets — Read and Write Spreadsheets

Requires the `gws` CLI on `$PATH`. Authenticate with `gws auth login` before first use.

```bash
gws sheets <resource> <method> [flags]
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

### +read — Read values from a spreadsheet

```bash
gws sheets +read --spreadsheet <ID> --range <RANGE>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--spreadsheet` | yes | — | Spreadsheet ID |
| `--range` | yes | — | Range to read in A1 notation (e.g. `Sheet1!A1:B2`) |

```bash
gws sheets +read --spreadsheet ID --range "Sheet1!A1:D10"
gws sheets +read --spreadsheet ID --range Sheet1
```

Read-only — never modifies the spreadsheet. For advanced options, use the raw `values.get` API.

### +append — Append rows to a spreadsheet

```bash
gws sheets +append --spreadsheet <ID>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--spreadsheet` | yes | — | Spreadsheet ID |
| `--values` | — | — | Comma-separated values for a single row |
| `--json-values` | — | — | JSON array of rows, e.g. `'[["a","b"],["c","d"]]'` |
| `--range` | — | `A1` | Target range in A1 notation to select a specific tab |

```bash
gws sheets +append --spreadsheet ID --values 'Alice,100,true'
gws sheets +append --spreadsheet ID --json-values '[["a","b"],["c","d"]]'
gws sheets +append --spreadsheet ID --range "Sheet2!A1" --values 'Alice,100'
```

Use `--values` for simple single-row appends. Use `--json-values` for bulk multi-row inserts. Use `--range` to target a specific sheet tab (default: first sheet).

> **WRITE command** — confirm with the user before executing.

## Raw API Resources

For operations not covered by helper commands, use the raw API:

```bash
gws schema sheets.<resource>.<method>
```

### spreadsheets

- `batchUpdate` — Apply one or more updates to the spreadsheet. Each request is validated before being applied. If any request is invalid, the entire request fails.
- `create` — Create a new spreadsheet. Returns the newly created spreadsheet.
- `get` — Get the spreadsheet at the given ID. By default, grid data is not returned. Use the `fields` parameter or `includeGridData` to include it.
- `getByDataFilter` — Get the spreadsheet using data filters to select specific subsets of data.
- `developerMetadata` — Operations on developer metadata.
- `sheets` — Operations on sheets (tabs) within the spreadsheet.
- `values` — Operations on cell values (get, update, append, batchGet, batchUpdate, batchClear, clear).

## Common Workflows

### Create a new spreadsheet

```bash
gws sheets spreadsheets create --json '{"properties": {"title": "Q4 Report"}}'
```

### Read a range

```bash
gws sheets +read --spreadsheet SHEET_ID --range "Sheet1!A1:E20"
```

### Append a row

```bash
gws sheets +append --spreadsheet SHEET_ID --values 'Name,Score,Date'
```

### Bulk append multiple rows

```bash
gws sheets +append --spreadsheet SHEET_ID --json-values '[["Alice",95,"2025-01"],["Bob",87,"2025-01"]]'
```

### Update specific cells (raw API)

```bash
gws sheets spreadsheets.values update \
  --params '{"spreadsheetId": "SHEET_ID", "range": "Sheet1!A1", "valueInputOption": "USER_ENTERED"}' \
  --json '{"values": [["Updated Value"]]}'
```

## Shell Tips

Sheet ranges like `Sheet1!A1` contain `!` which zsh interprets as history expansion. Use double quotes:

```bash
# WRONG (zsh will mangle the !)
gws sheets +read --spreadsheet ID --range 'Sheet1!A1:D10'

# CORRECT
gws sheets +read --spreadsheet ID --range "Sheet1!A1:D10"
```

Wrap `--params` and `--json` values in single quotes:

```bash
gws sheets spreadsheets get --params '{"spreadsheetId": "ID"}'
```
