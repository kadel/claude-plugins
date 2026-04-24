---
name: gws-calendar
description: "This skill should be used when the user asks to 'check calendar', 'show agenda', 'create event', 'list events', 'schedule meeting', 'find free time', 'manage calendar', 'delete event', 'update event', or mentions Google Calendar operations using the gws CLI."
version: 0.1.0
---

# Google Calendar — Manage Calendars and Events

Requires the `gws` CLI on `$PATH`. Authenticate with `gws auth login` before first use.

```bash
gws calendar <resource> <method> [flags]
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

### +agenda — Show upcoming events

```bash
gws calendar +agenda
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--today` | — | — | Show today's events |
| `--tomorrow` | — | — | Show tomorrow's events |
| `--week` | — | — | Show this week's events |
| `--days` | — | — | Number of days ahead to show |
| `--calendar` | — | — | Filter to specific calendar name or ID |
| `--timezone` | — | — | IANA timezone override (e.g. America/Denver) |

```bash
gws calendar +agenda
gws calendar +agenda --today
gws calendar +agenda --week --format table
gws calendar +agenda --days 3 --calendar 'Work'
gws calendar +agenda --today --timezone America/New_York
```

Read-only — never modifies events. Queries all calendars by default; use `--calendar` to filter. Uses Google account timezone by default.

### +insert — Create a new event

```bash
gws calendar +insert --summary <TEXT> --start <TIME> --end <TIME>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--summary` | yes | — | Event summary/title |
| `--start` | yes | — | Start time (ISO 8601, e.g. 2026-06-17T09:00:00-07:00) |
| `--end` | yes | — | End time (ISO 8601) |
| `--calendar` | — | primary | Calendar ID |
| `--location` | — | — | Event location |
| `--description` | — | — | Event description/body |
| `--attendee` | — | — | Attendee email (repeatable) |
| `--meet` | — | — | Add a Google Meet video conference link |

```bash
gws calendar +insert --summary 'Standup' --start '2026-06-17T09:00:00-07:00' --end '2026-06-17T09:30:00-07:00'
gws calendar +insert --summary 'Review' --start '2026-06-17T14:00:00-07:00' --end '2026-06-17T15:00:00-07:00' --attendee alice@example.com
gws calendar +insert --summary 'Sync' --start '2026-06-17T10:00:00-07:00' --end '2026-06-17T10:30:00-07:00' --meet
```

Use RFC 3339 format for times. The `--meet` flag automatically adds a Google Meet link.

> **WRITE command** — confirm with the user before executing.

## Raw API Resources

For operations not covered by helper commands, use the raw API:

```bash
gws schema calendar.<resource>.<method>
```

### events

- `list` — List events on a calendar.
- `get` — Get an event by its Google Calendar ID.
- `insert` — Create an event.
- `update` — Update an event.
- `patch` — Update an event (patch semantics).
- `delete` — Delete an event.
- `move` — Move an event to another calendar (default events only).
- `quickAdd` — Create an event from a simple text string.
- `instances` — List instances of a recurring event.
- `import` — Import a private copy of an existing event.
- `watch` — Watch for changes to events.

### calendars

- `get` — Get calendar metadata.
- `insert` — Create a secondary calendar.
- `update` — Update calendar metadata.
- `patch` — Update calendar metadata (patch semantics).
- `delete` — Delete a secondary calendar.
- `clear` — Clear all events on the primary calendar.

### calendarList

- `list` — List calendars on the user's calendar list.
- `get` — Get a calendar from the user's list.
- `insert` — Add an existing calendar to the user's list.
- `update` — Update a calendar on the user's list.
- `patch` — Update a calendar on the user's list (patch semantics).
- `delete` — Remove a calendar from the user's list.
- `watch` — Watch for changes to calendar list.

### freebusy

- `query` — Return free/busy information for a set of calendars.

### acl

- `list` — List access control rules for a calendar.
- `get` — Get an access control rule.
- `insert` — Create an access control rule.
- `update` — Update an access control rule.
- `patch` — Update an access control rule (patch semantics).
- `delete` — Delete an access control rule.
- `watch` — Watch for changes to ACL.

### colors

- `get` — Get color definitions for calendars and events.

### settings

- `list` — List all user settings.
- `get` — Get a single user setting.
- `watch` — Watch for changes to settings.

## Common Workflows

### View today's agenda

```bash
gws calendar +agenda --today
```

### View this week across all calendars

```bash
gws calendar +agenda --week --format table
```

### Create an event with attendees and Meet

```bash
gws calendar +insert --summary 'Design Review' \
  --start '2026-06-17T14:00:00-07:00' \
  --end '2026-06-17T15:00:00-07:00' \
  --attendee alice@example.com --attendee bob@example.com \
  --meet
```

### Quick-add an event from natural text

```bash
gws calendar events quickAdd --params '{"calendarId": "primary", "text": "Lunch with Alice tomorrow at noon"}'
```

### Check free/busy for scheduling

```bash
gws calendar freebusy query --json '{
  "timeMin": "2026-06-17T00:00:00Z",
  "timeMax": "2026-06-18T00:00:00Z",
  "items": [{"id": "primary"}]
}'
```

### List all calendars

```bash
gws calendar calendarList list --params '{"fields": "items(id,summary)"}'
```

## Shell Tips

Wrap `--params` and `--json` values in single quotes so the shell does not interpret inner double quotes:

```bash
gws calendar events list --params '{"calendarId": "primary", "maxResults": 10}'
```
